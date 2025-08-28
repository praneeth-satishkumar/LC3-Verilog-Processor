`timescale 1ns / 1ps

module alu(
    input [15:0] A,
    input [15:0] B,
    input [2:0] alu_op,
    output reg [15:0] result
    );
    
    parameter ADD = 3'b000, AND = 3'b001, NOT = 3'b010, PASS = 3'b011;
    
    always@ (*) begin
    
        case(alu_op)
            ADD: result <= A + B;
            AND: result <= A & B;
            NOT: result <= ~A;
            PASS: result <= A; 
            default: result <= 16'h0000;
        endcase

    end
    
endmodule