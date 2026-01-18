`timescale 1ns / 1ps

module main_decoder (
    input  wire [6:0] opcode,

    output reg        RegWrite,
    output reg        ALUSrc,
    output reg        MemWrite,
    output reg        Branch,
    output reg        Jump,

    output reg [2:0]  ALUOp,
    output reg [2:0]  ImmType,
    output reg [1:0]  ResultSrc
);

    always @(*) begin
        // -------------------------------------------------
        // DEFAULTS (safe NOP behavior)
        // -------------------------------------------------
        RegWrite  = 0;
        ALUSrc    = 0;
        MemWrite  = 0;   // 0 = read / no write
        Branch    = 0;
        Jump      = 0;
        ALUOp     = 3'b000;
        ImmType   = 3'b000;
        ResultSrc = 2'b00;

        case (opcode)

            // ---------------- R-TYPE ----------------
            7'b0110011: begin
            Jump=0;
                RegWrite  = 1;
                ALUSrc    = 0;
                ALUOp     = 3'b010;
                ResultSrc = 2'b00; // ALU
            end

            // ---------------- I-TYPE ALU ----------------
            7'b0010011: begin
            Jump=0;
                RegWrite  = 1;
                ALUSrc    = 1;
                ALUOp     = 3'b011;
                ImmType   = 3'b000; // I-type
                ResultSrc = 2'b00;  // ALU
            end

            // ---------------- LOAD ----------------
            7'b0000011: begin
            Jump=0;
                RegWrite  = 1;
                ALUSrc    = 1;
                ALUOp     = 3'b000; // address = rs1 + imm
                ImmType   = 3'b000; // I-type
                ResultSrc = 2'b01;  // memory
            end

            // ---------------- STORE ----------------
            7'b0100011: begin
            Jump=0;
                ALUSrc    = 1;
                MemWrite  = 1;      // write enable
                ALUOp     = 3'b000; // address = rs1 + imm
                ImmType   = 3'b001; // S-type
            end

            // ---------------- BRANCH ----------------
            7'b1100011: begin
            Jump=0;
                Branch    = 1;
                ALUSrc    = 0;
                ALUOp     = 3'b001; // compare
                ImmType   = 3'b010; // B-type
            end

            // ---------------- JAL ----------------
            7'b1101111: begin
                Jump      = 1;
                RegWrite  = 1;
                ALUSrc    = 1;
                ALUOp     = 3'b000;
                ImmType   = 3'b100; // J-type
                ResultSrc = 2'b10;  // PC+4
            end

            // ---------------- JALR (I-TYPE) ----------------
            7'b1100111: begin
                Jump      = 1;
                RegWrite  = 1;
                ALUSrc    = 1;
                ALUOp     = 3'b000;
                ImmType   = 3'b000; // I-type
                ResultSrc = 2'b10;  // PC+4
            end

            // ---------------- LUI ----------------
            7'b0110111: begin
                RegWrite  = 1;
                ALUSrc    = 1;
                ALUOp     = 3'b100; // pass immediate
                ImmType   = 3'b011; // U-type
                ResultSrc = 2'b00;
            end

            // ---------------- AUIPC ----------------
            7'b0010111: begin
                RegWrite  = 1;
                ALUSrc    = 1;
                ALUOp     = 3'b000;
                ImmType   = 3'b011; // U-type
                ResultSrc = 2'b00;
            end

        endcase
    end

endmodule
