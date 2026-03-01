`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.02.2026 16:22:39
// Design Name: 
// Module Name: data_memory
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

module data_memory (
    input  wire        clk,
    input  wire        MemWrite,        // ONLY control signal
    input  wire [31:0] address,
    input  wire [31:0] write_data,
    output reg  [31:0] read_data
);

    // 256 words = 1 KB data memory
    reg [31:0] mem [0:255];
    integer i;

    // -------------------------
    // INITIALIZE MEMORY
    // -------------------------
    initial begin
        for (i = 0; i < 256; i = i + 1)
            mem[i] = 32'd0;
    end

    // -------------------------
    // WRITE (synchronous)
    // -------------------------
    always @(posedge clk) begin
        if (MemWrite) begin
            mem[address[9:2]] <= write_data;

            `ifndef SYNTHESIS
                $display("Time=%0t | MEM WRITE | mem[%0d] = %0d (0x%h)",
                         $time, address[9:2], write_data, write_data);
            `endif
        end
    end

    // -------------------------
    // READ (combinational, ALWAYS ON)
    // -------------------------
    always @(*) begin
        read_data = mem[address[9:2]];
    end

endmodule

