`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: G.Naga Sai Krishna
// 
// Create Date: 23.02.2026 16:14:52
// Design Name: 
// Module Name: alu
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

module alu (
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire [3:0]  alu_ctrl,
    output reg  [31:0] result,
    output wire        zero
);

    always @(*) begin
        case (alu_ctrl)

            4'b0000: result = a + b;                       // ADD
            4'b0001: result = a - b;                       // SUB
            4'b0010: result = a & b;                       // AND
            4'b0011: result = a | b;                       // OR
            4'b0100: result = a ^ b;                       // XOR
            4'b0101: result = ($signed(a) < $signed(b));   // SLT
            4'b0110: result = (a < b);                     // SLTU
            4'b0111: result = a << b[4:0];                 // SLL
            4'b1000: result = a >> b[4:0];                 // SRL
            4'b1001: result = $signed(a) >>> b[4:0];       // SRA
            4'b1010: result = b;                           // LUI (PASS IMM)

            default: result = 32'b0;

        endcase
    end

    assign zero = (result == 32'b0);

endmodule
