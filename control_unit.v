`timescale 1ns / 1ps

module control_unit(
    input clk,
    input reset,
    input [15:0] instr,
    input n_flag,
    input z_flag,
    input p_flag,
    output reg pc_write, 
    output reg [1:0] pc_sel,
    output reg reg_write_en, 
    output reg [2:0] reg_dst,
    output reg [2:0] alu_op,
    output reg imm_flag,
    output reg mem_read, mem_write, mem_to_reg,
    output reg cc_write,
    output reg [2:0] SR1_out,
    output reg [2:0] SR2_out,
    output reg [15:0] IR = 16'h0000
);

parameter FETCH = 3'b000, DECODE = 3'b001, EXECUTE = 3'b010;
parameter ADD = 3'b000, AND = 3'b001, NOT = 3'b010, PASS = 3'b011;
parameter pc_1 = 2'b00, pc_offset = 2'b01, pc_reg = 2'b10;

reg [3:0] oppcode = 4'b0000;
reg [2:0] state;
reg [2:0] SR1, SR2, DR, SR, BR;
reg alu_src;
reg signed [15:0] PCoffset;

always@ (posedge clk) begin
    if (reset) begin
        state <= FETCH;
        pc_sel <= pc_1;
        pc_write <= 0;
        reg_write_en <= 0;
        imm_flag <= 0;
        mem_read <= 0;
        mem_write <= 0;
        mem_to_reg <= 0;
        cc_write <= 0;
        reg_dst <= 3'bXXX;
        alu_op <= 3'bXXX;
        IR <= 16'hXXXX;
        oppcode <= 4'bXXXX;
    end else begin
        case(state)
            FETCH: begin
                cc_write <= 0;
                reg_write_en <= 0;
                imm_flag <= 0;
                mem_read <= 0;
                mem_write <= 0;
                mem_to_reg <= 0;
                reg_dst <= 3'bXXX;
                alu_op <= 3'bXXX;
                pc_sel <= pc_1;
                pc_write <= 0;
                oppcode <= instr[15:12];
                state <= DECODE;
            end

            DECODE: begin
                case(oppcode)
                    4'b0001, 4'b0101: begin // ADD, AND
                        alu_op <= (IR[15:12] == 4'b0001) ? ADD : AND;
                        DR <= IR[11:9];
                        reg_dst <= IR[11:9];
                        SR1 <= IR[8:6];
                        if (IR[5] == 0)
                            SR2 <= IR[2:0];
                        else
                            imm_flag <= 1;
                        SR1_out <= IR[8:6];
                        SR2_out <= (IR[5] == 0) ? IR[2:0] : 3'b000;
                    end
                    4'b1001: begin // NOT
                        alu_op <= NOT;
                        DR <= IR[11:9];
                        reg_dst <= IR[11:9];
                        SR <= IR[8:6];
                        SR1_out <= IR[8:6];
                        SR2_out <= 3'b000;
                    end
                    4'b0000: begin // BR
                        PCoffset <= {{7{IR[8]}}, IR[8:0]};
                    end
                    4'b1100: begin // JMP
                        BR <= IR[8:6];
                        SR1_out <= IR[8:6];
                        SR2_out <= 3'b000;
                    end
                    4'b0100: begin // JSR/JSRR
                        if(IR[11])
                            PCoffset <= {{5{IR[10]}}, IR[10:0]};
                        else
                            BR <= IR[8:6];
                        SR1_out <= IR[8:6];
                    end
                    4'b0010, 4'b1010, 4'b1110: begin // LD, LDI, LEA
                        DR <= IR[11:9];
                        reg_dst <= IR[11:9];
                        PCoffset <= {{7{IR[8]}}, IR[8:0]};
                    end
                    4'b0011, 4'b1011: begin // ST, STI
                        SR1 <= IR[11:9];
                        PCoffset <= {{7{IR[8]}}, IR[8:0]};
                        SR1_out <= IR[11:9];
                    end
                    4'b0110, 4'b0111: begin // LDR, STR
                        DR <= IR[11:9];
                        SR1 <= IR[8:6];
                        PCoffset <= {{10{IR[5]}}, IR[5:0]};
                        SR1_out <= IR[8:6];
                    end
                endcase
                state <= EXECUTE;
            end

            EXECUTE: begin
                pc_write <= 1;
                IR <= instr;
                case(oppcode)
                    4'b0001, 4'b0101, 4'b1001: begin
                        alu_src <= IR[5];
                        reg_write_en <= 1;
                        mem_to_reg <= 0;
                        cc_write <= 1;
                    end
                    4'b0000: begin
                        if ((n_flag && IR[11]) || (z_flag && IR[10]) || (p_flag && IR[9])) begin
                            pc_sel <= pc_offset;
                            pc_write <= 1;
                        end else begin
                            pc_write <= 0;
                        end
                    end
                    4'b1100: begin
                        pc_sel <= pc_reg;
                        pc_write <= 1;
                    end
                    4'b0100: begin
                        reg_write_en <= 1;
                        reg_dst <= 3'b111;
                        alu_op <= PASS;
                        alu_src <= 1;
                        pc_sel <= pc_offset;
                        pc_write <= 1;
                    end
                    4'b0010, 4'b1010: begin
                        alu_src <= 1;
                        alu_op <= ADD;
                        mem_read <= 1;
                        reg_write_en <= 1;
                        mem_to_reg <= 1;
                        cc_write <= 1;
                    end
                    4'b1110: begin
                        alu_src <= 1;
                        alu_op <= ADD;
                        reg_write_en <= 1;
                        mem_to_reg <= 1;
                        cc_write <= 1;
                    end
                    4'b0011: begin
                        alu_src <= 1;
                        alu_op <= ADD;
                        mem_write <= 1;
                    end
                    4'b1011: begin
                        alu_src <= 1;
                        alu_op <= ADD;
                        mem_read <= 1;
                        mem_write <= 1;
                    end
                    4'b0110: begin
                        alu_src <= 1;
                        alu_op <= ADD;
                        mem_read <= 1;
                        reg_write_en <= 1;
                        mem_to_reg <= 1;
                        cc_write <= 1;
                    end
                    4'b0111: begin
                        alu_src <= 1;
                        alu_op <= ADD;
                        mem_write <= 1;
                    end
                endcase
                state <= FETCH;
            end
        endcase
    end
end

endmodule
