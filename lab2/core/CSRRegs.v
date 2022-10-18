`timescale 1ns / 1ps

module CSRRegs(
    input clk, rst,
    input[11:0] raddr, waddr, waddr2,
    input[31:0] wdata, wdata2,
    input csr_w, csr_w2,
    input[1:0] csr_wsc_mode, csr_wsc_mode2,
    input trap_begin, trap_end,
    // input [2:0] cause,
    // input [31:0] PC_cur,
    output[31:0] rdata,
    output[31:0] mstatus,
    output[31:0] mtvec,
    output[31:0] mepc
);

    reg[31:0] CSR [0:15];

    // Address mapping. The address is 12 bits, but only 4 bits are used in this module.
    wire raddr_valid = raddr[11:7] == 5'h6 && raddr[5:3] == 3'h0;
    wire[3:0] raddr_map = (raddr[6] << 3) + raddr[2:0];
    wire waddr_valid = waddr[11:7] == 5'h6 && waddr[5:3] == 3'h0;
    wire[3:0] waddr_map = (waddr[6] << 3) + waddr[2:0];
    wire[3:0] waddr_map2 = (waddr2[6] << 3) + waddr2[2:0];

    assign mstatus = CSR[0];
    assign mtvec = CSR[5];
    assign mepc = CSR[9];
    // mepc: 9
    // mtvec: 5

    assign rdata = CSR[raddr_map];

    always@(posedge clk or posedge rst) begin
        if(rst) begin
			CSR[0] = 32'h88;
			CSR[1] = 0;
			CSR[2] = 0;
			CSR[3] = 0;
			CSR[4] = 32'hfff;
			CSR[5] = 0;
			CSR[6] = 0;
			CSR[7] = 0;
			CSR[8] = 0;
			CSR[9] = 0;
			CSR[10] = 0;
			CSR[11] = 0;
			CSR[12] = 0;
			CSR[13] = 0;
			CSR[14] = 0;
			CSR[15] = 0;
		end
        else begin
            if(csr_w) begin
                case(csr_wsc_mode)
                    2'b01: CSR[waddr_map] = wdata;
                    2'b10: CSR[waddr_map] = CSR[waddr_map] | wdata;
                    2'b11: CSR[waddr_map] = CSR[waddr_map] & ~wdata;
                    default: CSR[waddr_map] = wdata;
                endcase            
            end
            if(csr_w2) begin
                case(csr_wsc_mode2)
                    2'b01: CSR[waddr_map2] = wdata2;
                    2'b10: CSR[waddr_map2] = CSR[waddr_map2] | wdata2;
                    2'b11: CSR[waddr_map2] = CSR[waddr_map2] & ~wdata2;
                    default: CSR[waddr_map2] = wdata2;
                endcase            
            end
            if (trap_begin) begin
                CSR[0][7] = CSR[0][3];
                CSR[0][3] = 1'b0;
            end
            else if (trap_end) begin
                CSR[0][3] = CSR[0][7];
                CSR[0][7] = 1'b1;
            end 
        end
    end
endmodule