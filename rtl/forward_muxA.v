`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.02.2026 15:40:55
// Design Name: 
// Module Name: forward_muxA
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
module forward_muxA (
    input  wire [1:0]  ForwardAE,

    input  wire [31:0] rd1E,          // normal register value
    input  wire [31:0] alu_resultM,   // EX/MEM stage
    input  wire [31:0] resultW,       // MEM/WB stage (final WB value)

    output reg  [31:0] srcAE
);

always @(*) begin
    case (ForwardAE)
        2'b00: srcAE = rd1E;          // no forwarding
        2'b01: srcAE = alu_resultM;   // forward from EX/MEM
        2'b10: srcAE = resultW;       // forward from MEM/WB
        default: srcAE = rd1E;
    endcase
end

endmodule