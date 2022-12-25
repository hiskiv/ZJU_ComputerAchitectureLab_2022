`timescale 1ns / 1ps

module FU_jump(
	input clk, EN, JALR,
	input[3:0] cmp_ctrl,
	input[31:0] rs1_data, rs2_data, imm, PC,
	output[31:0] PC_jump, PC_wb,
	output is_jump, finish
);

	wire cmp_res;
    reg state;
    assign finish = // fill sth. here
	initial begin
        state = 0;
    end

	reg JALR_reg;
	reg[3:0] cmp_ctrl_reg = 0;
	reg[31:0] rs1_data_reg = 0, rs2_data_reg = 0, imm_reg = 0, PC_reg = 0;

	// fill sth. here

	assign is_jump = // fill sth. here

endmodule