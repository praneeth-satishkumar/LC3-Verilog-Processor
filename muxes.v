`timescale 1ns / 1ps

module muxes(
    // pc mux
    input [1:0]pc_sel,
    input [15:0] pc_plus_1,
    input [15:0] branch_addr,
    input [15:0] jump_addr,
    output reg [15:0] pc_out,
    // alu_b_mux
    input alu_b_sel,
    input [15:0]reg_b,
    input [15:0]imm_val,
    output reg [15:0] alu_b,
    // writeback mux
    input mem_to_reg,
    input [15:0] alu_result,
    input [15:0] mem_data,
    output reg [15:0] writeback_data
    );
    
    parameter pc_1 = 2'b00, pc_offset = 2'b01, pc_reg = 2'b10;
    
    always@ (*) begin
    
        case(pc_sel)
            pc_1: pc_out <= pc_plus_1;
            pc_offset: pc_out <= branch_addr;
            pc_reg: pc_out <= jump_addr;
            default: pc_out <= 16'h0000;
        endcase
        
        if (alu_b_sel == 0)
            alu_b <= reg_b;
        else if (alu_b_sel == 1)
            alu_b <= imm_val;
            
        if (mem_to_reg == 0)
            writeback_data <= alu_result;
        else if (mem_to_reg == 1)
            writeback_data <= mem_data;
    
    end

endmodule