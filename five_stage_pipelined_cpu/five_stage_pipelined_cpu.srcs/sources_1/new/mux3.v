`timescale 1ns / 1ps

module mux3 (
    input  wire [31:0] in0,   // select = 00
    input  wire [31:0] in1,   // select = 01
    input  wire [31:0] in2,   // select = 10
    input  wire [1:0]  sel,
    output reg  [31:0] out
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
