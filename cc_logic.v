`timescale 1ns / 1ps

module cc_logic(
    input clk,
    input reset,
    input [15:0] result,
    input cc_write,
    output reg n_flag,
    output reg z_flag,
    output reg p_flag
    );
    
    always@ (posedge clk) begin
    
        if (reset)
            n_flag <= 1;
            z_flag <= 0;
            p_flag <= 0;
        
        if (cc_write == 1)
            if (result[15] == 1) begin
               n_flag <= 1;
               z_flag <= 0;
               p_flag <= 0;
            end else if (result == 16'h0000) begin
               n_flag <= 0;
               z_flag <= 1;
               p_flag <= 0;
            end else if (result[15] == 0 && result != 0) begin
               n_flag <= 0;
               z_flag <= 0;
               p_flag <= 1;
            end
    end
endmodule