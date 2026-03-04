`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: G.Naga Sai Krishna
// 
// Create Date: 23.02.2026 15:30:53
// Design Name: 
// Module Name: mux3
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


module mux3 (
    input  [31:0] in0,   // ALU result
    input  [31:0] in1,   // Memory data
    input  [31:0] in2,   // PC + 4
    input  [1:0]  sel,   // Writeback select
    output reg [31:0] out
);

    always @(*) begin
        case (sel)
            2'b00: out = in0;
            2'b01: out = in1;
            2'b10: out = in2;
            default: out = 32'b0;
        endcase
    end

endmodule
