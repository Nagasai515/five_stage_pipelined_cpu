`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: G.Naga Sai Krishna
// 
// Create Date: 25.02.2026 15:01:51
// Design Name: 
// Module Name: id_ex
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


module id_ex (
    input  wire        clk,
    input  wire        reset,

    // control
    input  wire        clear,    // bubble insertion (load-use hazard)

    // ===== data from ID stage =====
    input  wire [31:0] rd1_d,
    input  wire [31:0] rd2_d,
    input  wire [31:0] immext_d,
    input  wire [31:0] pc_d,
    input  wire [31:0] pc_plus4_d,

    // register numbers
    input  wire [4:0]  rs1_d,
    input  wire [4:0]  rs2_d,
    input  wire [4:0]  rd_d,

    // ===== control from ID stage =====
    input  wire        alusrc_d,
    input  wire [3:0]  alu_ctrl_d,
    input  wire        branch_d,
    input  wire        jump_d,
    input  wire        memwrite_d,
    input  wire        regwrite_d,
    input  wire [1:0]  resultsrc_d,

    // ===== outputs to EX stage =====
    output reg  [31:0] rd1_e,
    output reg  [31:0] rd2_e,
    output reg  [31:0] immext_e,
    output reg  [31:0] pc_e,
    output reg  [31:0] pc_plus4_e,

    output reg  [4:0]  rs1_e,
    output reg  [4:0]  rs2_e,
    output reg  [4:0]  rd_e,

    output reg         alusrc_e,
    output reg  [3:0]  alu_ctrl_e,
    output reg         branch_e,
    output reg         jump_e,
    output reg         memwrite_e,
    output reg         regwrite_e,
    output reg  [1:0]  resultsrc_e
);

always @(posedge clk) begin
    if (reset) begin
        // full reset
        rd1_e <= 0; rd2_e <= 0; immext_e <= 0;
        pc_e  <= 0; pc_plus4_e <= 0;
        rs1_e <= 0; rs2_e <= 0; rd_e <= 0;

        alusrc_e    <= 0;
        alu_ctrl_e     <= 0;
        branch_e    <= 0;
        jump_e      <= 0;
        memwrite_e  <= 0;
        regwrite_e  <= 0;
        resultsrc_e <= 0;
    end
    else if (clear) begin
        // bubble ? kill all side effects (CONTROL = 0)
        rd_e  <= 0;
        rs1_e <= 0;
        rs2_e <= 0;
        rd1_e <= 0;
        rd2_e <= 0;
        immext_e <= 0;
        pc_e <= 0;
        pc_plus4_e <= 0;
        alusrc_e    <= 0;
        alu_ctrl_e     <= 0;
        branch_e    <= 0;
        jump_e      <= 0;
        memwrite_e  <= 0;
        regwrite_e  <= 0;
        resultsrc_e <= 0;
    end
    else begin
        // always advance
        rd1_e <= rd1_d;
        rd2_e <= rd2_d;
        immext_e <= immext_d;
        pc_e <= pc_d;
        pc_plus4_e <= pc_plus4_d;

        rs1_e <= rs1_d;
        rs2_e <= rs2_d;
        rd_e  <= rd_d;

        alusrc_e    <= alusrc_d;
        alu_ctrl_e     <= alu_ctrl_d;
        branch_e    <= branch_d;
        jump_e      <= jump_d;
        memwrite_e  <= memwrite_d;
        regwrite_e  <= regwrite_d;
        resultsrc_e <= resultsrc_d;
    end
end

endmodule
