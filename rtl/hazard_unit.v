`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: G.Naga Sai Krishna
// 
// Create Date: 25.02.2026 15:33:09
// Design Name: 
// Module Name: hazard_unit
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

module hazard_unit (
    // ---------- ID stage ----------
    input  wire [4:0] rs1D,
    input  wire [4:0] rs2D,

    // ---------- EX stage ----------
    input  wire [4:0] rs1E,
    input  wire [4:0] rs2E,
    input  wire [4:0] rdE,
    input  wire [1:0] ResultSrcE,   // 01 = load
    input  wire       PCSrcE,        // Jump || (Branch & Zero)

    // ---------- MEM stage ----------
    input  wire [4:0] rdM,
    input  wire       RegWriteM,

    // ---------- WB stage ----------
    input  wire [4:0] rdW,
    input  wire       RegWriteW,

    // ---------- outputs ----------
    output wire       stallF,
    output wire       stallD,
    output wire       flushD,   // IF/ID flush
    output wire       flushE,   // ID/EX bubble

    output reg  [1:0] ForwardAE,
    output reg  [1:0] ForwardBE
);

    // --------------------------------------------------
    // LOAD-USE HAZARD DETECTION
    // load if ResultSrcE == 01
    // --------------------------------------------------
    wire isLoadE;
    assign isLoadE = (ResultSrcE == 2'b01);

    wire load_use_hazard;
    assign load_use_hazard =
        isLoadE &&
        (rdE != 5'b0) &&
        ((rdE == rs1D) || (rdE == rs2D));

    // --------------------------------------------------
    // STALL / FLUSH CONTROL
    // --------------------------------------------------
    assign stallF = load_use_hazard;
    assign stallD = load_use_hazard;

    // bubble in EX on load-use
    assign flushE = load_use_hazard|PCSrcE;

    // flush IF/ID on branch or jump taken
    assign flushD = PCSrcE;

    // --------------------------------------------------
    // FORWARDING LOGIC
    // --------------------------------------------------
    always @(*) begin
        // defaults: no forwarding
        ForwardAE = 2'b00;
        ForwardBE = 2'b00;

        // -------- EX/MEM forwarding (highest priority) --------
        if (RegWriteM && (rdM != 5'b0) && (rdM == rs1E))
            ForwardAE = 2'b01;

        if (RegWriteM && (rdM != 5'b0) && (rdM == rs2E))
            ForwardBE = 2'b01;

        // -------- MEM/WB forwarding --------
        if (RegWriteW && (rdW != 5'b0) &&
            !(RegWriteM && (rdM != 5'b0) && (rdM == rs1E)) &&
            (rdW == rs1E))
            ForwardAE = 2'b10;

        if (RegWriteW && (rdW != 5'b0) &&
            !(RegWriteM && (rdM != 5'b0) && (rdM == rs2E)) &&
            (rdW == rs2E))
            ForwardBE = 2'b10;
    end

endmodule
