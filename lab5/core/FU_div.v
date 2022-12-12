`timescale 1ns / 1ps

module FU_div(
    input clk, EN,
    input[31:0] A, B,
    output[31:0] res
);

    wire res_valid;
    wire[63:0] divres;
    
    reg[23:0] state;
    initial begin
        state = 0;
    end

    reg A_valid, B_valid;
    reg[31:0] A_reg, B_reg;

    always @(posedge clk) begin             //! to fill sth.in
        if (EN && ~state) begin
            A_reg <= A;
            B_reg <= B;
            A_valid <= 1'b1;
            B_valid <= 1'b1;
            state <= 23'h7fffff;
        end
        else begin
            state <= state >> 1;
            A_valid <= 1'b0;
            B_valid <= 1'b0;
        end
    end

    divider div(.aclk(clk),
        .s_axis_dividend_tvalid(A_valid),
        .s_axis_dividend_tdata(A_reg),
        .s_axis_divisor_tvalid(B_valid), 
        .s_axis_divisor_tdata(B_reg),
        .m_axis_dout_tvalid(res_valid), 
        .m_axis_dout_tdata(divres)
    );

    assign res = divres[63:32];

endmodule