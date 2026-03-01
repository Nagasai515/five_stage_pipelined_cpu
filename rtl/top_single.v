`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.02.2026 16:26:38
// Design Name: 
// Module Name: top_single
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

module top_single(
    input wire clk,
    input wire reset
);

// =====================================================
// IF STAGE
// =====================================================

wire stallF, stallD, flushD, flushE;

wire [31:0] pcF, pc_plus4F, pc_nextF;
wire [31:0] instrF;

pc PC (
    .clk(clk),
    .reset(reset),
    .enable(~stallF),
    .next_pc(pc_nextF),
    .pc(pcF)
);

pc_adder PC_ADD (
    .pc(pcF),
    .pc_plus_4(pc_plus4F)
);

instruction_memory IMEM (
    .address(pcF),
    .instruction(instrF)
);

// =====================================================
// IF/ID
// =====================================================

wire [31:0] instrD, pcD, pc_plus4D;

if_id IF_ID (
    .clk(clk),
    .reset(reset),
    .enable(~stallD),
    .clear(flushD),
    .instr_f(instrF),
    .pc_f(pcF),
    .pc_plus4_f(pc_plus4F),
    .instr_d(instrD),
    .pc_d(pcD),
    .pc_plus4_d(pc_plus4D)
);

// =====================================================
// ID STAGE
// =====================================================

wire RegWriteD, ALUSrcD, MemWriteD, BranchD, JumpD;
wire [2:0] ALUOpD;
wire [2:0] ImmSrcD;
wire [1:0] ResultSrcD;

wire [4:0] rs1D = instrD[19:15];
wire [4:0] rs2D = instrD[24:20];
wire [4:0] rdD  = instrD[11:7];

main_decoder CONTROL (
    .opcode(instrD[6:0]),
    .RegWrite(RegWriteD),
    .ALUSrc(ALUSrcD),
    .MemWrite(MemWriteD),
    .Branch(BranchD),
    .Jump(JumpD),
    .ALUOp(ALUOpD),
    .ImmSrc(ImmSrcD),
    .ResultSrc(ResultSrcD)
);

// ALU CONTROL GENERATED IN ID STAGE
wire [3:0] alu_ctrlD;

alu_control ALU_CONTROL (
    .funct3(instrD[14:12]),
    .funct7(instrD[31:25]),
    .alu_op(ALUOpD),
    .alu_ctrl(alu_ctrlD)
);

wire [31:0] rd1D, rd2D;

wire [31:0] resultW;
wire [4:0]  rdW;
wire        regwriteW;

register_file RF (
    .clk(clk),
    .reg_write(regwriteW),
    .rs1(rs1D),
    .rs2(rs2D),
    .rd(rdW),
    .write_data(resultW),
    .read_data1(rd1D),
    .read_data2(rd2D)
);

wire [31:0] immextD;

imm_gen IMM (
    .instr(instrD),
    .ImmSrc(ImmSrcD),
    .imm_out(immextD)
);

// =====================================================
// ID/EX
// =====================================================

wire [31:0] rd1E, rd2E, immextE, pcE, pc_plus4E;
wire [4:0] rs1E, rs2E, rdE;
wire ALUSrcE, MemWriteE, BranchE, JumpE, RegWriteE;
wire [1:0] ResultSrcE;
wire [3:0] alu_ctrlE;

id_ex ID_EX (
    .clk(clk),
    .reset(reset),
    .clear(flushE),

    .rd1_d(rd1D),
    .rd2_d(rd2D),
    .immext_d(immextD),
    .pc_d(pcD),
    .pc_plus4_d(pc_plus4D),

    .rs1_d(rs1D),
    .rs2_d(rs2D),
    .rd_d(rdD),

    .alusrc_d(ALUSrcD),
    .alu_ctrl_d(alu_ctrlD),   // << changed
    .branch_d(BranchD),
    .jump_d(JumpD),
    .memwrite_d(MemWriteD),
    .regwrite_d(RegWriteD),
    .resultsrc_d(ResultSrcD),

    .rd1_e(rd1E),
    .rd2_e(rd2E),
    .immext_e(immextE),
    .pc_e(pcE),
    .pc_plus4_e(pc_plus4E),

    .rs1_e(rs1E),
    .rs2_e(rs2E),
    .rd_e(rdE),

    .alusrc_e(ALUSrcE),
    .alu_ctrl_e(alu_ctrlE),   // << changed
    .branch_e(BranchE),
    .jump_e(JumpE),
    .memwrite_e(MemWriteE),
    .regwrite_e(RegWriteE),
    .resultsrc_e(ResultSrcE)
);

// =====================================================
// HAZARD UNIT
// =====================================================

wire PCSrcE;
wire [1:0] ForwardAE, ForwardBE;
wire [4:0] rdM;
wire RegWriteM;

hazard_unit HAZARD (
    .rs1D(rs1D),
    .rs2D(rs2D),
    .rs1E(rs1E),
    .rs2E(rs2E),
    .rdE(rdE),
    .ResultSrcE(ResultSrcE),
    .PCSrcE(PCSrcE),
    .rdM(rdM),
    .RegWriteM(RegWriteM),
    .rdW(rdW),
    .RegWriteW(regwriteW),
    .stallF(stallF),
    .stallD(stallD),
    .flushD(flushD),
    .flushE(flushE),
    .ForwardAE(ForwardAE),
    .ForwardBE(ForwardBE)
);

// =====================================================
// FORWARDING
// =====================================================

wire [31:0] alu_resultM;
wire [31:0] srcAE, forwardedBE;

forward_muxA FWD_A (
    .ForwardAE(ForwardAE),
    .rd1E(rd1E),
    .alu_resultM(alu_resultM),
    .resultW(resultW),
    .srcAE(srcAE)
);

forward_muxB FWD_B (
    .ForwardBE(ForwardBE),
    .rd2E(rd2E),
    .alu_resultM(alu_resultM),
    .resultW(resultW),
    .srcBE(forwardedBE)
);

// ALUSrc mux
wire [31:0] srcBE_final;

mux2 ALUSRC_MUX (
    .in0(forwardedBE),
    .in1(immextE),
    .sel(ALUSrcE),
    .out(srcBE_final)
);

// =====================================================
// EX STAGE
// =====================================================

wire [31:0] alu_resultE;
wire zeroE;

alu ALU (
    .a(srcAE),
    .b(srcBE_final),
    .alu_ctrl(alu_ctrlE),
    .result(alu_resultE),
    .zero(zeroE)
);

pcsrc_logic PCS (
    .Branch(BranchE),
    .Jump(JumpE),
    .Zero(zeroE),
    .PCSrc(PCSrcE)
);

wire [31:0] branch_targetE;

branch_adder BR_ADD (
    .pc(pcE),
    .imm(immextE),
    .branch_target(branch_targetE)
);

// =====================================================
// EX/MEM
// =====================================================

wire [31:0] write_dataM, pc_plus4M;
wire MemWriteM;
wire [1:0] ResultSrcM;

ex_mem EX_MEM (
    .clk(clk),
    .reset(reset),
    .alu_result_e(alu_resultE),
    .write_data_e(forwardedBE),
    .pc_plus4_e(pc_plus4E),
    .rd_e(rdE),
    .memwrite_e(MemWriteE),
    .regwrite_e(RegWriteE),
    .resultsrc_e(ResultSrcE),
    .alu_result_m(alu_resultM),
    .write_data_m(write_dataM),
    .pc_plus4_m(pc_plus4M),
    .rd_m(rdM),
    .memwrite_m(MemWriteM),
    .regwrite_m(RegWriteM),
    .resultsrc_m(ResultSrcM)
);

// =====================================================
// MEM
// =====================================================

wire [31:0] read_dataM;

data_memory DMEM (
    .clk(clk),
    .MemWrite(MemWriteM),
    .address(alu_resultM),
    .write_data(write_dataM),
    .read_data(read_dataM)
);

// =====================================================
// MEM/WB
// =====================================================

wire [31:0] alu_resultW, read_dataW, pc_plus4W;
wire [1:0] resultsrcW;

mem_wb MEM_WB (
    .clk(clk),
    .reset(reset),
    .alu_result_m(alu_resultM),
    .read_data_m(read_dataM),
    .pc_plus4_m(pc_plus4M),
    .rd_m(rdM),
    .regwrite_m(RegWriteM),
    .resultsrc_m(ResultSrcM),
    .alu_result_w(alu_resultW),
    .read_data_w(read_dataW),
    .pc_plus4_w(pc_plus4W),
    .rd_w(rdW),
    .regwrite_w(regwriteW),
    .resultsrc_w(resultsrcW)
);

// =====================================================
// WRITEBACK
// =====================================================

mux3 RESULT_MUX (
    .in0(alu_resultW),
    .in1(read_dataW),
    .in2(pc_plus4W),
    .sel(resultsrcW),
    .out(resultW)
);

// =====================================================
// NEXT PC LOGIC
// =====================================================

mux2 PC_MUX (
    .in0(pc_plus4F),
    .in1(branch_targetE),
    .sel(PCSrcE),
    .out(pc_nextF)
);

endmodule