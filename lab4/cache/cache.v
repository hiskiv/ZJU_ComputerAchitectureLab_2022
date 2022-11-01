// | ----------- address 32 ----------- |
// | 31   9 | 8     4 | 3    2 | 1    0 |
// | tag 23 | index 5 | word 2 | byte 2 |

module cache (
	input wire clk,  // clock
	input wire rst,  // reset
	input wire [ADDR_BITS-1:0] addr,  // address
    input wire load,    //  read refreshes recent bit
	input wire store,  // set valid to 1 and reset dirty to 0
	input wire edit,  // set dirty to 1
	input wire invalid,  // reset valid to 0
    input wire [2:0] u_b_h_w, // select signed or not & data width
                              // please refer to definition of LB, LH, LW, LBU, LHU in RV32I Instruction Set  
	input wire [31:0] din,  // data write in
	output reg hit = 0,  // hit or not
	output reg [31:0] dout = 0,  // data read out
	output reg valid = 0,  // valid bit
	output reg dirty = 0,  // dirty bit
	output reg [TAG_BITS-1:0] tag = 0  // tag bits
	);

    `include "addr_define.vh"

    // your implementation

endmodule
