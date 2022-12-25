`timescale 1ns / 1ps

module FU_mul(
    input clk, EN,
    input[31:0] A, B,
    output[31:0] res
);

    reg[6:0] state;
    initial begin
        state = 0;
    end

    reg[31:0] A_reg, B_reg;

    always @(posedge clk) begin         //! to fill sth.in
        if (EN && ~state) begin
            A_reg <= A;
            B_reg <= B;
            state <= 7'h3f;
        end
        else state <= state >> 1;
    end


    wire [63:0] mulres;
    multiplier mul(.CLK(clk),.A(A_reg),.B(B_reg),.P(mulres));

    assign res = mulres[31:0];

endmodule