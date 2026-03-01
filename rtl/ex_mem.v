`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.02.2026 15:25:03
// Design Name: 
// Module Name: ex_mem
// Project Name: 
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

module ex_mem (
    input  wire        clk,
    input  wire        reset,

    // ===== inputs from EX stage =====
    input  wire [31:0] alu_result_e,
    input  wire [31:0] write_data_e,
    input  wire [31:0] pc_plus4_e,

    input  wire [4:0]  rd_e,

    // control signals
    input  wire        memwrite_e,
    input  wire        regwrite_e,
    input  wire [1:0]  resultsrc_e,

    // ===== outputs to MEM stage =====
    output reg  [31:0] alu_result_m,
    output reg  [31:0] write_data_m,
    output reg  [31:0] pc_plus4_m,

    output reg  [4:0]  rd_m,

    // control signals
    output reg         memwrite_m,
    output reg         regwrite_m,
    output reg  [1:0]  resultsrc_m
);

always @(posedge clk) begin
    if (reset) begin
        alu_result_m <= 32'b0;
        write_data_m <= 32'b0;
        pc_plus4_m   <= 32'b0;

        rd_m         <= 5'b0;

        memwrite_m  <= 1'b0;
        regwrite_m  <= 1'b0;
        resultsrc_m <= 2'b00;
    end
    else begin
        alu_result_m <= alu_result_e;
        write_data_m <= write_data_e;
        pc_plus4_m   <= pc_plus4_e;

        rd_m         <= rd_e;

        memwrite_m  <= memwrite_e;
        regwrite_m  <= regwrite_e;
        resultsrc_m <= resultsrc_e;
    end
end

endmodule
