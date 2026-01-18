`timescale 1ns / 1ps

module pcsrc_logic (
    input  wire Branch,   // asserted for beq/bne
    input  wire Jump,     // asserted for jal
    input  wire Zero,     // from ALU compare
    output wire PCSrc
);

    // PCSrc = 1 means take branch or jump
    // Branch taken only when Zero = 1 (beq)
    // Jump always taken (jal)
    assign PCSrc = Jump | (Branch & Zero);

endmodule
