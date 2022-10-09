`timescale 1ps/1ps

module HazardDetectionUnit(
    input clk,
    input Branch_ID, JAL, rs1use_ID, rs2use_ID,
    input[1:0] hazard_optype_ID,
    input[4:0] rd_EXE, rd_MEM, rs1_ID, rs2_ID, rs2_EXE,
    input DatatoReg_MEM, WR_EX,
    output reg reg_FD_stall, reg_FD_flush, PC_EN_IF, reg_DE_flush,
    output reg_FD_EN, reg_DE_EN,
           reg_EM_EN, reg_EM_flush, reg_MW_EN,
    output reg forward_ctrl_ls,
    output reg [1:0] forward_ctrl_A, forward_ctrl_B
);
            //according to the diagram, design the Hazard Detection Unit
    
    // 00: normal; 01: get a Load; 10: get a R-type; 11: (might be)stall hazard
    reg [1:0] hazard_state;
    initial begin
        hazard_state <= 2'b00;
        reg_FD_stall <= 1'b0;
        reg_FD_flush <= 1'b0;
        PC_EN_IF <= 1'b1;
        reg_DE_flush <= 1'b0;
    end

    reg last_rs2_EX_hazard;
    reg rs1_EX_hazard, rs2_EX_hazard;
    reg rs1_MEM_hazard, rs2_MEM_hazard;
    always @(negedge clk) begin
        if (hazard_state == 2'b00) begin
            if (hazard_optype_ID == 2'b00) hazard_state = 2'b01;
            else if (hazard_optype_ID == 2'b01) hazard_state = 2'b10;
            else hazard_state = 2'b00;
        end
        else if (hazard_state == 2'b01) begin
            if (hazard_optype_ID == 2'b01) hazard_state = 2'b11;
            else if (hazard_optype_ID == 2'b10) hazard_state = 2'b11;
            else if (hazard_optype_ID == 2'b00) hazard_state = 2'b01;
            else hazard_state = 2'b00;
        end
        else if (hazard_state == 2'b10) begin
            if (hazard_optype_ID == 2'b10) hazard_state = 2'b11;
            else if (hazard_optype_ID == 2'b01) hazard_state = 2'b10;
            else hazard_state = 2'b00;
        end
        else if (hazard_state == 2'b11) begin
            hazard_state = 2'b00;
        end
    end

    always @(posedge clk) begin
        last_rs2_EX_hazard <= rs2_EX_hazard;
    end

    always @(*) begin
        if (rd_EXE != 5'b0 && (rs1use_ID == 1'b1 && rd_EXE == rs1_ID)) begin
            rs1_EX_hazard = 1'b1;
        end
        else rs1_EX_hazard = 1'b0;
        if (rd_EXE != 5'b0 && (rs2use_ID == 1'b1 && rd_EXE == rs2_ID)) begin
            rs2_EX_hazard = 1'b1;
        end
        else rs2_EX_hazard = 1'b0;

        if (rd_MEM != 5'b0 && (rs1use_ID == 1'b1 && rd_MEM == rs1_ID)) begin
            rs1_MEM_hazard = 1'b1;
        end
        else rs1_MEM_hazard = 1'b0;
        if (rd_MEM != 5'b0 && (rs2use_ID == 1'b1 && rd_MEM == rs2_ID)) begin
            rs2_MEM_hazard = 1'b1;
        end
        else rs2_MEM_hazard = 1'b0;

        if (Branch_ID == 1'b1) begin
            if (hazard_state == 2'b11 && (rs1_EX_hazard || rs2_EX_hazard)) begin
                reg_FD_stall = 1'b1;
                reg_DE_flush = 1'b1;
            end
            else begin
                reg_FD_stall = 1'b0;
                reg_DE_flush = 1'b0;
                reg_FD_flush = 1'b1;
            end
        end
        else if (JAL == 1'b1) begin
            reg_FD_flush = 1'b1;
        end
        else begin
            reg_FD_flush = 1'b0;
            if (hazard_state == 2'b11 && (rs1_EX_hazard || rs2_EX_hazard)) begin
                reg_FD_stall = 1'b1;
                reg_DE_flush = 1'b1;
                PC_EN_IF = 1'b0;
            end
            else begin
                reg_FD_stall = 1'b0;
                reg_DE_flush = 1'b0;
                PC_EN_IF = 1'b1;
            end
        end

        if (WR_EX == 1'b1 && DatatoReg_MEM == 1'b1 && last_rs2_EX_hazard == 1'b1) begin
            forward_ctrl_ls = 1'b1;
        end
        else forward_ctrl_ls = 1'b0;

        if (rs1_EX_hazard == 1'b1) begin
            forward_ctrl_A = 2'b01;
        end
        else if (rs1_MEM_hazard == 1'b1) begin
            if (DatatoReg_MEM == 1'b1) forward_ctrl_A = 2'b11;
            else forward_ctrl_A = 2'b10;
        end
        else forward_ctrl_A = 2'b00;

        if (rs2_EX_hazard == 1'b1) begin
            forward_ctrl_B = 2'b01;
        end
        else if (rs2_MEM_hazard == 1'b1) begin
            if (DatatoReg_MEM == 1'b1) forward_ctrl_B = 2'b11;
            else forward_ctrl_B = 2'b10;
        end
        else forward_ctrl_B = 2'b00;
    end

    assign reg_FD_EN = 1'b1;
    assign reg_DE_EN = 1'b1;
    assign reg_EM_EN = 1'b1;
    assign reg_MW_EN = 1'b1;
    assign reg_EM_flush = 1'b0;
endmodule