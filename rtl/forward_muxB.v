`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.02.2026 15:43:27
// Design Name: 
// Module Name: forward_muxB
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

module forward_muxB (
    input  wire [1:0]  ForwardBE,

    input  wire [31:0] rd2E,          // normal register value
    input  wire [31:0] alu_resultM,   // EX/MEM stage
    input  wire [31:0] resultW,       // MEM/WB stage

    output reg  [31:0] srcBE
);

always @(*) begin
    case (ForwardBE)
        2'b00: srcBE = rd2E;
        2'b01: srcBE = alu_resultM;
        2'b10: srcBE = resultW;
        default: srcBE = rd2E;
    endcase
end

endmodule