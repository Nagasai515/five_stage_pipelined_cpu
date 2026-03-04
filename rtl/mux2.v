`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: G.Naga Sai Krishna
// 
// Create Date: 23.02.2026 15:30:13
// Design Name: 
// Module Name: mux2
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

module mux2 (
    input  wire [31:0] in0,
    input  wire [31:0] in1,
    input  wire        sel,
    output wire [31:0] out
);

    assign out = sel ? in1 : in0;

endmodule
