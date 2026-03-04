`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: G.Naga Sai Krishna
// 
// Create Date: 23.02.2026 16:17:19
// Design Name: 
// Module Name: branch_adder
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

module branch_adder (
    input  wire [31:0] pc,
    input  wire [31:0] imm,
    output wire [31:0] branch_target
);

    assign branch_target = pc + imm;

endmodule
