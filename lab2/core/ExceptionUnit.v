`timescale 1ns / 1ps

module ExceptionUnit(
    input clk, rst,
    input csr_rw_in,
    input[1:0] csr_wsc_mode_in,
    input csr_w_imm_mux,
    input[11:0] csr_rw_addr_in,
    input[31:0] csr_w_data_reg,
    input[4:0] csr_w_data_imm,
    output[31:0] csr_r_data_out,

    input interrupt,
    input illegal_inst,
    input l_access_fault,
    input s_access_fault,
    input ecall_m,

    input mret,

    input[31:0] epc_cur,
    input[31:0] epc_next,
    output reg [31:0] PC_redirect,
    output reg redirect_mux,

    output reg reg_FD_flush, reg_DE_flush, reg_EM_flush, reg_MW_flush, 
    output reg RegWrite_cancel
);

    // reg[11:0] csr_raddr, csr_waddr;
    // reg[31:0] csr_wdata;
    // reg csr_w;
    // reg[1:0] csr_wsc;

    // wire[31:0] mstatus;

    // CSRRegs csr(.clk(clk),.rst(rst),.csr_w(csr_w),.raddr(csr_raddr),.waddr(csr_waddr),
    //     .wdata(csr_wdata),.rdata(csr_r_data_out),.mstatus(mstatus),.csr_wsc_mode(csr_wsc));

    //According to the diagram, design the Exception Unit

    wire [31:0] csr_wdata = (csr_w_imm_mux == 1'b1) ? ({{26{csr_w_data_imm[4]}}, csr_w_data_imm}) : csr_w_data_reg;
    wire [31:0] mstatus, mtvec, mepc;

    reg trap_begin, trap_end;
    reg [31:0] cause;

    CSRRegs csr(.clk(clk),.rst(rst),.csr_w(csr_rw_in),.raddr(csr_rw_addr_in),.waddr(csr_rw_addr_in), .trap_begin(trap_begin), .trap_end(trap_end),
        .wdata(csr_wdata),.rdata(csr_r_data_out),.csr_wsc_mode(csr_wsc_mode_in),
        .PC_cur(epc_cur),.cause(cause),
        .mstatus(mstatus),.mtvec(mtvec),.mepc(mepc));

    always @(posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            trap_begin = 1'b0; trap_end = 1'b0;
            reg_FD_flush = 1'b0;
            reg_DE_flush = 1'b0;
            reg_EM_flush = 1'b0;
            reg_MW_flush = 1'b0;
            RegWrite_cancel = 1'b0;
            redirect_mux = 1'b0;
        end
        else if (mstatus[3] == 1'b1 && (interrupt || illegal_inst || l_access_fault || s_access_fault || ecall_m)) begin
            if (interrupt == 1'b1) cause = 32'h80000000;
            else if (illegal_inst == 1'b1) cause = 32'h00000002;
            else if (l_access_fault == 1'b1) cause = 32'h00000005;
            else if (s_access_fault == 1'b1) cause = 32'h00000007;
            else cause = 32'h0000000b;
            trap_begin = 1'b1; trap_end = 1'b0;
            reg_FD_flush = 1'b1;
            reg_DE_flush = 1'b1;
            reg_EM_flush = 1'b1;
            reg_MW_flush = 1'b1;
            RegWrite_cancel = 1'b1;
            PC_redirect = mtvec;
            redirect_mux = 1'b1;
        end
        else if (mret == 1'b1) begin
            trap_begin = 1'b0; trap_end = 1'b1;
            reg_FD_flush = 1'b1;
            reg_DE_flush = 1'b1;
            reg_EM_flush = 1'b1;
            reg_MW_flush = 1'b1;
            PC_redirect = mepc;
            redirect_mux = 1'b1;
        end
        else begin // no entering or mret
            trap_begin = 1'b0; trap_end = 1'b0;
            reg_FD_flush = 1'b0;
            reg_DE_flush = 1'b0;
            reg_EM_flush = 1'b0;
            reg_MW_flush = 1'b0;
            RegWrite_cancel = 1'b0;
            redirect_mux = 1'b0;
        end
    end

endmodule