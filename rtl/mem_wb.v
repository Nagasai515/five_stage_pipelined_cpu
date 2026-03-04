`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: G.Naga Sai Krishna
// 
// Create Date: 25.02.2026 15:26:15
// Design Name: 
// Module Name: mem_wb
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


module mem_wb (
    input  wire        clk,
    input  wire        reset,

    // ===== inputs from MEM stage =====
    input  wire [31:0] alu_result_m,
    input  wire [31:0] read_data_m,
    input  wire [31:0] pc_plus4_m,

    input  wire [4:0]  rd_m,

    // control (WB stage only)
    input  wire        regwrite_m,
    input  wire [1:0]  resultsrc_m,

    // ===== outputs to WB stage =====
    output reg  [31:0] alu_result_w,
    output reg  [31:0] read_data_w,
    output reg  [31:0] pc_plus4_w,

    output reg  [4:0]  rd_w,

    // control
    output reg         regwrite_w,
    output reg  [1:0]  resultsrc_w
);

always @(posedge clk) begin
    if (reset) begin
        alu_result_w <= 32'b0;
        read_data_w  <= 32'b0;
        pc_plus4_w   <= 32'b0;

        rd_w         <= 5'b0;

        regwrite_w  <= 1'b0;
        resultsrc_w <= 2'b00;
    end
    else begin
        alu_result_w <= alu_result_m;
        read_data_w  <= read_data_m;
        pc_plus4_w   <= pc_plus4_m;

        rd_w         <= rd_m;

        regwrite_w  <= regwrite_m;
        resultsrc_w <= resultsrc_m;
    end
end

endmodule
