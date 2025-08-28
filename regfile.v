`timescale 1ns / 1ps

module regfile(
    input clk,
    input reg_write_en,
    input [2:0] DR,
    input [2:0] SR1,
    input [2:0] SR2,
    input [15:0] write_data,
    output reg [15:0] read_data1,
    output reg [15:0] read_data2
    );
    
    reg [15:0] registers [0:7];
    initial begin
        registers[0] = 16'h0000;
        registers[1] = 16'h0000;
        registers[2] = 16'h0000;
        registers[3] = 16'h0000;
        registers[4] = 16'h0000;
        registers[5] = 16'h0000;
        registers[6] = 16'h0000;
        registers[7] = 16'h0000;
    end
            
    
    always@ (*) begin
        $display("Read R%d = %h, R%d = %h", SR1, registers[SR1], SR2, registers[SR2]);
        read_data1 <= registers[SR1];
        read_data2 <= registers[SR2];
        
    end
    
    always@ (posedge clk) begin

        if (reg_write_en)
            $display("Writing %h to R%d", write_data, DR); 
            registers[DR] <= write_data;
    end
endmodule
