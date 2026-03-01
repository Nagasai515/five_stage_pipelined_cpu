`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.02.2026 16:29:00
// Design Name: 
// Module Name: tb_top_single
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
module tb_top_single;

    // --------------------------------
    // Testbench Signals
    // --------------------------------
    reg clk;
    reg reset;

    // --------------------------------
    // Instantiate DUT
    // --------------------------------
    top_single DUT (
        .clk(clk),
        .reset(reset)
    );

    // --------------------------------
    // Clock Generation (10ns period)
    // --------------------------------
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 100 MHz clock
    end

    // --------------------------------
    // Reset Sequence
    // --------------------------------
    initial begin
        reset = 1;
        #20;
        reset = 0;
    end

    // --------------------------------
    // Simulation Control
    // --------------------------------
    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, tb_top_single);

        // Run long enough for pipeline to complete program
        #2000;

        $display("Pipeline Simulation Finished");
        $finish;
    end

endmodule