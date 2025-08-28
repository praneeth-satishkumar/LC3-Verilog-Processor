`timescale 1ns / 1ps

module instr_mem(
    input [15:0] addr,
    output reg [15:0] instr_out = 16'h0000
    );
    
    reg [15:0] memory_array [0:65535];
    
    initial begin
        // Add instructions here
        // Example instructions:
        memory_array[16'h3000] = 16'b0101_000_000_1_00000; // AND R0, R0, #0
        memory_array[16'h3001] = 16'b0001_001_001_1_00001; // ADD R1, R1, #1
    end
    
    always@ (*) begin
        instr_out = memory_array[addr];
    end
    
endmodule