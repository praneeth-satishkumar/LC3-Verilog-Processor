`timescale 1ns / 1ps

module data_mem(
    input clk,
    input mem_read,
    input mem_write,
    input [15:0] addr,
    input [15:0] write_data,
    output reg [15:0] read_data     
    );
    
    reg [15:0] memory_array [0:65535];
    initial begin
        memory_array[16'h300c] = 16'b0000_0000_0000_0000;   // VALSTR: .FILL x0000
        memory_array[16'h300d] = 16'b0000_0000_0000_1010;   // NEWVAL: .FILL #10
    end
    
    always@ (*) begin
    
        if (mem_read == 1)
            read_data <= memory_array[addr];
        else
            read_data <= 16'b0000;
            
    end
    
    always@ (posedge clk) begin
        
        if (mem_write == 1)
            memory_array[addr] <= write_data;       
        
    end
    
endmodule

