`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: G.Naga Sai Krishna
// 
// Create Date: 23.02.2026 16:32:14
// Design Name: 
// Module Name: pcsrc_logic
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



module pcsrc_logic (
    input  wire Branch,
    input  wire Jump,
    input  wire Zero,
    output wire PCSrc
);

    assign PCSrc = Jump | (Branch & Zero);

endmodule
