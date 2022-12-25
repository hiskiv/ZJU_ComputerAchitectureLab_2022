`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:34:44 03/12/2012 
// Design Name: 
// Module Name:    Regs 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module Regs(input clk,
			input rst,	
			//	为每一个FU分配对应的读写口
			//	ALU
			input [4:0] R_addr_A_ALU, 
			input [4:0] R_addr_B_ALU, 
			input [4:0] Wt_addr_ALU, 
			input [31:0]Wt_data_ALU, 
			input L_S_ALU, 
			output [31:0] rdata_A_ALU, 
			output [31:0] rdata_B_ALU,

			//	JUMP
			input [4:0] R_addr_A_JUMP, 
			input [4:0] R_addr_B_JUMP, 
			input [4:0] Wt_addr_JUMP, 
			input [31:0]Wt_data_JUMP, 
			input L_S_JUMP, 
			output [31:0] rdata_A_JUMP, 
			output [31:0] rdata_B_JUMP,
			
			//	MEM
			input [4:0] R_addr_A_MEM, 
			input [4:0] R_addr_B_MEM, 
			input [4:0] Wt_addr_MEM, 
			input [31:0]Wt_data_MEM, 
			input L_S_MEM, 
			output [31:0] rdata_A_MEM, 
			output [31:0] rdata_B_MEM,

			//	MUL
			input [4:0] R_addr_A_MUL, 
			input [4:0] R_addr_B_MUL, 
			input [4:0] Wt_addr_MUL, 
			input [31:0]Wt_data_MUL, 
			input L_S_MUL, 
			output [31:0] rdata_A_MUL, 
			output [31:0] rdata_B_MUL,

			//	DIV
			input [4:0] R_addr_A_DIV, 
			input [4:0] R_addr_B_DIV, 
			input [4:0] Wt_addr_DIV, 
			input [31:0]Wt_data_DIV, 
			input L_S_DIV, 
			output [31:0] rdata_A_DIV, 
			output [31:0] rdata_B_DIV,

			input [4:0] Debug_addr,         // debug address
			output[31:0] Debug_regs        // debug data
);

	reg [31:0] register [1:31]; 				// r1 - r31
	integer i;


	// fill sth. here
	assign rdata_A_JUMP = 		// read JUMP
	assign rdata_B_JUMP =    	// read JUMP

	assign rdata_A_ALU = 		// read ALU
	assign rdata_B_ALU =		// read ALU
	
	assign rdata_A_MEM = 		// read MEM
	assign rdata_B_MEM = 	  	// read MEM	

	assign rdata_A_MUL = 		// read MUL
	assign rdata_B_MUL = 		// read MUL
	
	assign rdata_A_DIV = 		// read DIV
	assign rdata_B_DIV = 	  	// read DIV	

	//	write data
	always @(negedge clk or posedge rst) 
      begin
		if (rst) 	 begin 			// reset
		    for (i=1; i<32; i=i+1)
		    register[i] <= 0;	//i;
		end 
		else begin			
		// fill sth. here	//	write
		end
	end
    	
    assign Debug_regs = (Debug_addr == 0) ? 0 : register[Debug_addr];               //TEST

endmodule


