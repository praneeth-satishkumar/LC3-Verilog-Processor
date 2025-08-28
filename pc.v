`timescale 1ns / 1ps

module pc(
    input clk_25M,
    input reset,
    input pc_load,
    input [15:0] pc_in,
    output reg [15:0] pc_out = 16'h0000
    );

    always @(posedge clk_25M) begin
        
        if (reset)
            pc_out <= 16'h3000;
        else if (pc_load > 0)
            pc_out <= pc_in;
            
    end
endmodule