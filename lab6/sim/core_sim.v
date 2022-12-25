`timescale 1ns / 1ps

module core_sim;
    reg clk, rst;

    RV32core core(
        .debug_en(1'b0),
        .debug_step(1'b0),
        .debug_addr(7'b0),
        .debug_data(),
        .clk(clk),
        .rst(rst),
        .interrupter(1'b0)
    );

    initial begin
        clk = 0;
        rst = 1;
        #5 rst = 0;	// Wait 100 ns for global reset to finish
    end

    always #1 clk = ~clk;

endmodule