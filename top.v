`timescale 1ns / 1ps

module top(
    input clk,
    input reset
);

    // Clock divider
    wire clk_25M;
    clock_divider clkdiv(clk, clk_25M);

    // Program Counter
    wire [15:0] pc_out, pc_in;
    wire pc_write;
    pc pc_inst(clk_25M, reset, pc_write, pc_in, pc_out);

    // Instruction Memory
    wire [15:0] instr;
    instr_mem imem(pc_out, instr);

    // Instruction Register wiring
    wire [2:0] DR, SR1, SR2;

    // Control signals
    wire reg_write_en, alu_src, mem_read, mem_write, mem_to_reg, cc_write;
    wire [2:0] alu_op;
    wire [1:0] pc_sel;

    // Register File
    wire [15:0] read_data1, read_data2, writeback_data;
    regfile rf(clk_25M, reg_write_en, DR, SR1, SR2, writeback_data, read_data1, read_data2);

    // ALU
    wire [15:0] alu_b, alu_result;
    alu alu_unit(read_data1, alu_b, alu_op, alu_result);

    // Data Memory
    wire [15:0] mem_data;
    data_mem dmem(clk_25M, mem_read, mem_write, alu_result, read_data2, mem_data);

    // Condition Code Logic
    wire n_flag, z_flag, p_flag;
    cc_logic cc(clk_25M, reset, alu_result, cc_write, n_flag, z_flag, p_flag);

    // Sign Extender
    wire [15:0] IR;
    wire [15:0] ext_value;
    wire [11:0] in_value = IR[11:0];
    wire [3:0] in_width = (IR[15:12] == 4'b0001 || IR[15:12] == 4'b0101) ? 4'd5 : 4'd9;
    sign_extender se(in_value, in_width, ext_value);

    // Muxes
    wire [15:0] pc_plus_1 = pc_out + 1;
    wire [15:0] branch_addr = pc_out + ext_value;
    wire [15:0] jump_addr = read_data1; // for JMP, JSRR

    muxes mux_unit(
        pc_sel, pc_plus_1, branch_addr, jump_addr, pc_in,
        alu_src, read_data2, ext_value, alu_b,
        mem_to_reg, alu_result, mem_data, writeback_data
    );

    // Control Unit
    control_unit ctrl(
        clk_25M, reset, instr, n_flag, z_flag, p_flag,
        pc_write, pc_sel,
        reg_write_en, DR,
        alu_op, alu_src,
        mem_read, mem_write, mem_to_reg,
        cc_write,
        SR1, SR2, IR
    );

endmodule