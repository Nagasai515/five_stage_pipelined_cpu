`timescale 1ns / 1ps

module cpu_tb;

    reg clk;
    reg reset;

    // -------------------------------------------------
    // Instantiate CPU
    // -------------------------------------------------
    top_cpu CPU (
        .clk(clk),
        .reset(reset)
    );

    // -------------------------------------------------
    // Clock generation: 10 ns period
    // -------------------------------------------------
    initial begin
        clk = 0;
        forever #5 clk = ~clk;   // 10 ns clock
    end

    // -------------------------------------------------
    // Reset logic
    // -------------------------------------------------
    initial begin
        reset = 1;
        #20 reset = 0;           // Release reset after 20 ns
    end

    // -------------------------------------------------
    // Simulation runtime
    // -------------------------------------------------
    initial begin
        #3000;
        $display("Simulation finished.");
        $finish;
    end

    // -------------------------------------------------
    // Monitor important signals
    // -------------------------------------------------
    initial begin
        $display(" Time |   PC   | Instruction | ALU_Result | WB_Data ");
        $display("-----------------------------------------------------");

        $monitor(
            "%4t | %h | %h | %h | %h",
            $time,
            CPU.pc,
            CPU.instr,
            CPU.alu_result,
            CPU.wb_data
        );
    end

endmodule
