`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: G.Naga Sai Krishna
// 
// Create Date: 23.02.2026 15:19:51
// Design Name: 
// Module Name: instruction_memory
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

module instruction_memory (
    input  wire [31:0] address,
    output wire [31:0] instruction
);

    // 256 words × 32-bit = 1 KB instruction memory
    reg [31:0] mem [0:255];
    integer i;

    initial begin
        // =====================================================
        // Register initialization
        // =====================================================
        mem[0]  = 32'h00500093; // addi x1, x0, 5
        mem[1]  = 32'h00A00113; // addi x2, x0, 10

        // =====================================================
        // R-type ALU operations
        // =====================================================
        mem[2]  = 32'h002081B3; // add  x3, x1, x2   = 15
        mem[3]  = 32'h40110233; // sub  x4, x2, x1   = 5
        mem[4]  = 32'h0020F2B3; // and  x5, x1, x2
        mem[5]  = 32'h0020E333; // or   x6, x1, x2
        mem[6]  = 32'h0020C3B3; // xor  x7, x1, x2

        // =====================================================
        // I-type ALU operations
        // =====================================================
        mem[7]  = 32'h00308413; // addi x8, x1, 3
        mem[8]  = 32'h0070F493; // andi x9, x1, 7
        mem[9]  = 32'h0080E513; // ori  x10, x1, 8

        // =====================================================
        // Memory operations
        // =====================================================
        mem[10] = 32'h00302023; // sw   x3, 0(x0)
        mem[11] = 32'h00002883; // lw   x17, 0(x0)

        // =====================================================
        // Branch test (BEQ ONLY)
        // =====================================================
        mem[12] = 32'h00388463; // beq  x17, x3, +8  (skip next)
        mem[13] = 32'h00100913; // addi x18, x0, 1   (skipped)

        mem[14] = 32'h00200993; // addi x19, x0, 2   (executed)

        // =====================================================
        // JAL test
        // rd = PC+4, PC = PC + imm
        // =====================================================
        mem[15] = 32'h008000EF; // jal x1, +8 (skip next instruction)
        mem[16] = 32'h00100A13; // addi x20, x0, 1   (skipped)
        mem[17] = 32'h00200A93; // addi x21, x0, 2   (executed)

        // =====================================================
        // INFINITE LOOP (supported)
        // =====================================================
        mem[18] = 32'h00000063; // beq x0, x0, 0  (infinite loop)

        // =====================================================
        // Fill rest with NOPs
        // =====================================================
        for (i = 19; i < 256; i = i + 1)
            mem[i] = 32'h00000013; // NOP (addi x0, x0, 0)
    end

    // Word-aligned instruction fetch
    assign instruction = mem[address[9:2]];

endmodule
