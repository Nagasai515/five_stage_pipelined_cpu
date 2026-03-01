`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.02.2026 16:04:07
// Design Name: 
// Module Name: alu_control
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

module alu_control (
    input  wire [2:0] funct3,
    input  wire [6:0] funct7,
    input  wire [2:0] alu_op,   // from main decoder
    output reg  [3:0] alu_ctrl
);

    /*
        alu_op encoding:
        000 : ADD (lw, sw)
        001 : BEQ only (use SUB)
        010 : R-type
        011 : I-type ALU
        100 : LUI (pass immediate)
    */

    always @(*) begin
        case (alu_op)

            // ----------------------------------------
            // ADD (lw, sw)
            // ----------------------------------------
            3'b000: alu_ctrl = 4'b0000; // ADD


            // ----------------------------------------
            // BEQ (compare using SUB)
            // ----------------------------------------
            3'b001: alu_ctrl = 4'b0001; // SUB


            // ----------------------------------------
            // R-TYPE
            // ----------------------------------------
            3'b010: begin
                case ({funct7, funct3})

                    {7'b0000000, 3'b000}: alu_ctrl = 4'b0000; // ADD
                    {7'b0100000, 3'b000}: alu_ctrl = 4'b0001; // SUB

                    {7'b0000000, 3'b111}: alu_ctrl = 4'b0010; // AND
                    {7'b0000000, 3'b110}: alu_ctrl = 4'b0011; // OR
                    {7'b0000000, 3'b100}: alu_ctrl = 4'b0100; // XOR

                    {7'b0000000, 3'b010}: alu_ctrl = 4'b0101; // SLT
                    {7'b0000000, 3'b011}: alu_ctrl = 4'b0110; // SLTU

                    {7'b0000000, 3'b001}: alu_ctrl = 4'b0111; // SLL
                    {7'b0000000, 3'b101}: alu_ctrl = 4'b1000; // SRL
                    {7'b0100000, 3'b101}: alu_ctrl = 4'b1001; // SRA

                    default: alu_ctrl = 4'b0000;
                endcase
            end


            // ----------------------------------------
            // I-TYPE ALU
            // ----------------------------------------
            3'b011: begin
                case (funct3)

                    3'b000: alu_ctrl = 4'b0000; // ADDI
                    3'b111: alu_ctrl = 4'b0010; // ANDI
                    3'b110: alu_ctrl = 4'b0011; // ORI
                    3'b100: alu_ctrl = 4'b0100; // XORI

                    3'b010: alu_ctrl = 4'b0101; // SLTI
                    3'b011: alu_ctrl = 4'b0110; // SLTIU

                    3'b001: alu_ctrl = 4'b0111; // SLLI

                    3'b101: begin
                        if (funct7 == 7'b0100000)
                            alu_ctrl = 4'b1001; // SRAI
                        else
                            alu_ctrl = 4'b1000; // SRLI
                    end

                    default: alu_ctrl = 4'b0000;
                endcase
            end


            // ----------------------------------------
            // LUI
            // ----------------------------------------
            3'b100: alu_ctrl = 4'b1010; // PASS IMM


            // ----------------------------------------
            // DEFAULT
            // ----------------------------------------
            default: alu_ctrl = 4'b0000;

        endcase
    end

endmodule
