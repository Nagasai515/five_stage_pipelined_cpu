`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.02.2026 16:00:32
// Design Name: 
// Module Name: main_decoder
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
module main_decoder (
    input  wire [6:0] opcode,

    output reg        RegWrite,
    output reg        ALUSrc,
    output reg        MemWrite,
    output reg        Branch,     // BEQ only
    output reg        Jump,       // JAL only

    output reg [2:0]  ALUOp,
    output reg [2:0]  ImmSrc,
    output reg [1:0]  ResultSrc   // 00=ALU, 01=MEM, 10=PC+4
);

    always @(*) begin
        // -------------------------
        // SAFE DEFAULTS
        // -------------------------
        RegWrite  = 1'b0;
        ALUSrc    = 1'b0;
        MemWrite  = 1'b0;
        Branch    = 1'b0;
        Jump      = 1'b0;
        ALUOp     = 3'b000;
        ImmSrc    = 3'b000;
        ResultSrc = 2'b00;

        case (opcode)

            // -------------------------
            // R-TYPE
            // -------------------------
            7'b0110011: begin
                RegWrite  = 1'b1;
                ALUSrc    = 1'b0;
                ALUOp     = 3'b010;
                ResultSrc = 2'b00;  // ALU result
            end

            // -------------------------
            // I-TYPE (ADDI, ANDI, ORI...)
            // -------------------------
            7'b0010011: begin
                RegWrite  = 1'b1;
                ALUSrc    = 1'b1;
                ALUOp     = 3'b011;
                ImmSrc    = 3'b000; // I-type
                ResultSrc = 2'b00;  // ALU result
            end

            // -------------------------
            // LOAD (LW)
            // -------------------------
            7'b0000011: begin
                RegWrite  = 1'b1;
                ALUSrc    = 1'b1;
                ALUOp     = 3'b000; // address calculation
                ImmSrc    = 3'b000; // I-type
                ResultSrc = 2'b01;  // memory data
            end

            // -------------------------
            // STORE (SW)
            // -------------------------
            7'b0100011: begin
                ALUSrc    = 1'b1;
                MemWrite  = 1'b1;
                ALUOp     = 3'b000; // address calculation
                ImmSrc    = 3'b001; // S-type
            end

            // -------------------------
            // BRANCH (BEQ ONLY)
            // -------------------------
            7'b1100011: begin
                Branch    = 1'b1;
                ALUSrc    = 1'b0;
                ALUOp     = 3'b001; // compare operation
                ImmSrc    = 3'b010; // B-type
            end

            // -------------------------
            // JAL
            // -------------------------
            7'b1101111: begin
                RegWrite  = 1'b1;
                Jump      = 1'b1;
                ImmSrc    = 3'b100; // J-type
                ResultSrc = 2'b10;  // PC + 4
                // ALU not required
            end

            // -------------------------
            // LUI
            // -------------------------
            7'b0110111: begin
                RegWrite  = 1'b1;
                ImmSrc    = 3'b011; // U-type
                ALUSrc    = 1'b1;
                ALUOp     = 3'b100; // dedicated LUI operation
                ResultSrc = 2'b00;  // ALU result
            end

            default: begin
                // Keep safe defaults
            end

        endcase
    end

endmodule
