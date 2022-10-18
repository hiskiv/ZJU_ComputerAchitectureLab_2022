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
    output redirect_mux,

    output FD_flush, DE_flush, EM_flush, MW_flush, 
    output RegWrite_cancel
);
    //According to the diagram, design the Exception Unit

    reg [31:0] cause; // 0: interrupt; 1: ill; 2: l_a_f; 3: s_a_f; 4: ecall
    wire int = interrupt | illegal_inst | l_access_fault | s_access_fault | ecall_m;
    always @(int) begin
        if (interrupt == 1'b1) cause = 32'h80000000;
        else if (illegal_inst == 1'b1) cause = 32'h2;
        else if (l_access_fault == 1'b1) cause = 32'h5;
        else if (s_access_fault == 1'b1) cause = 32'h7;
        else cause = 32'hB;
    end

    // trap_begin == 1'b1: write slot 1 write mepc
    wire csr_w1 = csr_rw_in | trap_begin;
    wire [11:0] csr_waddr1 = (trap_begin == 1'b1) ? 12'h341 : csr_rw_addr_in;
    wire [1:0] csr_wmode = (trap_begin == 1'b1) ? 2'b01 : csr_wsc_mode_in;
    wire [31:0] csr_wdata = (trap_begin == 1'b1) ? (epc_cur)
                            : ((csr_w_imm_mux == 1'b1) ? ({27'b0, csr_w_data_imm}) : csr_w_data_reg);
    // write slot 2 is used for writing mcause now
    wire csr_w2 = trap_begin;
    wire [11:0] waddr2 = 12'h342;
    wire [1:0] csr_wmode2 = 2'b01;

    wire [31:0] mstatus, mtvec, mepc;

    reg trap_begin, trap_end;

    CSRRegs csr(.clk(clk),.rst(rst),.raddr(csr_rw_addr_in),.rdata(csr_r_data_out),
        .csr_w(csr_w1),.waddr(csr_waddr1),.wdata(csr_wdata),.csr_wsc_mode(csr_wmode),
        .csr_w2(csr_w2),.waddr2(waddr2),.wdata2(cause),.csr_wsc_mode2(csr_wmode2),
        .trap_begin(trap_begin),.trap_end(trap_end),
        .mstatus(mstatus),.mtvec(mtvec),.mepc(mepc));

    always @(posedge clk or posedge rst or posedge mret or posedge int) begin
        if (rst == 1'b1) begin
            trap_begin = 1'b0; trap_end = 1'b0;
        end
        else if (trap_begin == 1'b0 && mstatus[3] == 1'b1 && int) begin
            trap_begin = 1'b1; trap_end = 1'b0;
            PC_redirect = mtvec;
        end
        else if (mret == 1'b1 && trap_end == 1'b0) begin
            trap_begin = 1'b0; trap_end = 1'b1;
            PC_redirect = mepc;
        end
        else begin // no entering/mret
            trap_begin = 1'b0; trap_end = 1'b0;
        end
    end

    assign FD_flush = (trap_begin == 1'b1 || trap_end == 1'b1) ? 1'b1 : 1'b0;
    assign DE_flush = (trap_begin == 1'b1 || trap_end == 1'b1) ? 1'b1 : 1'b0;
    assign EM_flush = (trap_begin == 1'b1 || trap_end == 1'b1) ? 1'b1 : 1'b0;
    assign MW_flush = (trap_begin == 1'b1 || trap_end == 1'b1) ? 1'b1 : 1'b0;
    assign RegWrite_cancel = (trap_begin == 1'b1 || trap_end == 1'b1) ? 1'b1 : 1'b0;
    assign redirect_mux = (trap_begin == 1'b1 || trap_end == 1'b1) ? 1'b1 : 1'b0;

endmodule