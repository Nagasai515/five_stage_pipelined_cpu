`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: G.Naga Sai Krishna
// 
// Create Date: 25.02.2026 14:59:47
// Design Name: 
// Module Name: if_id
// Project Name: five_stage_pipelined_cpu
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////



module if_id (
    input  wire        clk,
    input  wire        reset,

    // control signals
    input  wire        enable,   // = !stall
    input  wire        clear,    // = flush (branch taken)

    // inputs from IF stage
    input  wire [31:0] instr_f,
    input  wire [31:0] pc_f,
    input  wire [31:0] pc_plus4_f,

    // outputs to ID stage
    output reg  [31:0] instr_d,
    output reg  [31:0] pc_d,
    output reg  [31:0] pc_plus4_d
);

always @(posedge clk) begin
    if (reset) begin
        instr_d     <= 32'b0;
        pc_d        <= 32'b0;
        pc_plus4_d  <= 32'b0;
    end
    else if (clear) begin
        // flush ? insert NOP
        instr_d     <= 32'b0;
        pc_d        <= 32'b0;
        pc_plus4_d  <= 32'b0;
    end
    else if (enable) begin
        instr_d     <= instr_f;
        pc_d        <= pc_f;
        pc_plus4_d  <= pc_plus4_f;
    end
    // else: enable = 0 ? stall (hold previous values)
end

endmodule
