`timescale 1ns / 1ps

module FU_jump(
	input clk, EN, JALR,
	input[3:0] cmp_ctrl, // bit 0 stands for unconditional jump
	input[31:0] rs1_data, rs2_data, imm, PC,
	output[31:0] PC_jump, PC_wb,
	output is_jump, finish
);

	wire cmp_res;
    reg state;
    assign finish = state; // fill sth. here
	initial begin
        state = 0;
    end

	reg JALR_reg;
	reg[3:0] cmp_ctrl_reg = 0;
	reg[31:0] rs1_data_reg = 0, rs2_data_reg = 0, imm_reg = 0, PC_reg = 0;

	always @(posedge clk) begin         //! fill sth. here
		if (EN && ~state) begin
			PC_reg <= PC;
			cmp_ctrl_reg <= cmp_ctrl;
			imm_reg <= imm;
			rs1_data_reg <= rs1_data;
			rs2_data_reg <= rs2_data;
			JALR_reg <= JALR;
			state <= 1;
		end
		else state <= 0;
	end

	wire[31:0] JALR_PC, Branch_PC;
	assign PC_wb = PC_reg + 32'd4;
	assign JALR_PC = rs1_data_reg + imm_reg;
	assign Branch_PC = PC_reg + imm_reg;
	assign PC_jump = (JALR_reg == 1'b1) ? JALR_PC : Branch_PC;

	cmp_32 cmp(.a(rs1_data_reg),.b(rs2_data_reg),.ctrl(cmp_ctrl_reg[3:1]),.c(cmp_res));

	assign is_jump = cmp_ctrl_reg[0] | cmp_res; // fill sth. here

endmodule