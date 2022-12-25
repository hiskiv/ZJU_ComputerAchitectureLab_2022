`timescale 1ns / 1ps

module  RV32core(
        input debug_en,  // debug enable
        input debug_step,  // debug step clock
        input [6:0] debug_addr,  // debug address
        output[31:0] debug_data,  // debug data
        input clk,  // main clock
        input rst,  // synchronous reset
        input interrupter  // interrupt source, for future use
    );

    wire debug_clk;
    wire[31:0] debug_regs;
    wire[31:0] Test_signal;
    
	assign debug_data = debug_addr[5] ? Test_signal : debug_regs;

    debug_clk clock(.clk(clk),.debug_en(debug_en),.debug_step(debug_step),.debug_clk(debug_clk));

    wire PC_EN_IF, IS_EN, FU_ALU_EN, FU_mem_EN, FU_mul_EN, FU_div_EN, FU_jump_EN;
    wire[2:0] ImmSel_ctrl, bhw_ctrl;

    //  ALU
    wire RegWrite_ctrl_ALU;
    wire[4:0] rs1_addr_ctrl_ALU, rs2_addr_ctrl_ALU, rd_ctrl_ALU;
    wire[31:0]rs1_data_RO_ALU, rs2_data_RO_ALU;

    wire[31:0] PC_ctrl_ALU,  imm_ctrl_ALU;
    wire ALUSrcA_ctrl, ALUSrcB_ctrl;
    wire[3:0] ALUControl_ctrl;

    //  Register file JUMP
    wire RegWrite_ctrl_JUMP;
    wire[4:0] rs1_addr_ctrl_JUMP, rs2_addr_ctrl_JUMP, rd_ctrl_JUMP;
    wire[31:0]rs1_data_RO_JUMP, rs2_data_RO_JUMP;   

    wire[4:0] Jump_ctrl;
    wire[31:0] PC_ctrl_JUMP, imm_ctrl_JUMP;

    //  Register file MEM
    wire RegWrite_ctrl_MEM;
    wire[4:0] rs1_addr_ctrl_MEM, rs2_addr_ctrl_MEM, rd_ctrl_MEM;
    wire[31:0]rs1_data_RO_MEM, rs2_data_RO_MEM;

    wire[31:0] imm_ctrl_MEM;
    wire mem_w_ctrl;

    //  Register file MUL
    wire RegWrite_ctrl_MUL;
    wire[4:0] rs1_addr_ctrl_MUL, rs2_addr_ctrl_MUL, rd_ctrl_MUL;
    wire[31:0]rs1_data_RO_MUL, rs2_data_RO_MUL;

    //  Register file DIV
    wire RegWrite_ctrl_DIV;
    wire[4:0] rs1_addr_ctrl_DIV, rs2_addr_ctrl_DIV, rd_ctrl_DIV;
    wire[31:0]rs1_data_RO_DIV, rs2_data_RO_DIV;


    wire [31:0] PC_IF, next_PC_IF, PC_4_IF, inst_IF;

    wire[31:0]inst_IS, PC_IS, Imm_out_IS;

    wire[31:0]ALUA_RO, ALUB_RO;

    wire FU_ALU_finish, FU_mem_finish, FU_mul_finish, FU_div_finish, FU_jump_finish, is_jump_FU;
    wire[31:0]ALUout_FU, mem_data_FU, mulres_FU, divres_FU, PC_jump_FU, PC_wb_FU;

    wire[31:0]ALUout_WB, mem_data_WB, mulres_WB, divres_WB, PC_wb_WB;


    // IF
    assign PC_EN_IF = IS_EN | FU_jump_finish & is_jump_FU;

    REG32 REG_PC(.clk(debug_clk),.rst(rst),.CE(PC_EN_IF),.D(next_PC_IF),.Q(PC_IF));
    
    add_32 add_IF(.a(PC_IF),.b(32'd4),.c(PC_4_IF));

    MUX2T1_32 mux_IF(.I0(PC_4_IF),.I1(PC_jump_FU),.s(FU_jump_finish & is_jump_FU),.o(next_PC_IF));

    ROM_D inst_rom(.a(PC_IF[8:2]),.spo(inst_IF));


    //Issue
    REG_IF_IS reg_IF_IS(.clk(debug_clk),.rst(rst),.EN(IS_EN),
        .flush(1'b0),.PCOUT(PC_IF),.IR(inst_IF),

        .IR_IS(inst_IS),.PCurrent_IS(PC_IS));
    
    ImmGen imm_gen(.ImmSel(ImmSel_ctrl),.inst_field(inst_IS),.Imm_out(Imm_out_IS));

    CtrlUnit ctrl(.clk(debug_clk),.rst(rst),.PC(PC_IS),.inst(inst_IS),.imm(Imm_out_IS),
        .PC_IF(PC_IF), .inst_IF(inst_IF),
        
        .ALU_done(FU_ALU_finish),.MEM_done(FU_mem_finish),.MUL_done(FU_mul_finish),.DIV_done(FU_div_finish),.JUMP_done(FU_jump_finish),
        .is_jump(is_jump_FU),
        .IS_en(IS_EN),.ImmSel(ImmSel_ctrl),
        
        .ALU_en(FU_ALU_EN),.MEM_en(FU_mem_EN),.MUL_en(FU_mul_EN),.DIV_en(FU_div_EN),.JUMP_en(FU_jump_EN),

        .PC_ctrl_ALU(PC_ctrl_ALU),.imm_ctrl_ALU(imm_ctrl_ALU),
        .rs1_ctrl_ALU(rs1_addr_ctrl_ALU),.rs2_ctrl_ALU(rs2_addr_ctrl_ALU),

        .PC_ctrl_JUMP(PC_ctrl_JUMP),.imm_ctrl_JUMP(imm_ctrl_JUMP),
        .rs1_ctrl_JUMP(rs1_addr_ctrl_JUMP),.rs2_ctrl_JUMP(rs2_addr_ctrl_JUMP),

        .imm_ctrl_MEM(imm_ctrl_MEM),
        .rs1_ctrl_MEM(rs1_addr_ctrl_MEM),.rs2_ctrl_MEM(rs2_addr_ctrl_MEM),

        .rs1_ctrl_MUL(rs1_addr_ctrl_MUL),.rs2_ctrl_MUL(rs2_addr_ctrl_MUL),
        .rs1_ctrl_DIV(rs1_addr_ctrl_DIV),.rs2_ctrl_DIV(rs2_addr_ctrl_DIV),

        .JUMP_op(Jump_ctrl),.ALU_op(ALUControl_ctrl),.ALU_use_PC(ALUSrcA_ctrl),.ALU_use_imm(ALUSrcB_ctrl),
        .MEM_we(mem_w_ctrl),.MEM_bhw(bhw_ctrl),.MUL_op(),.DIV_op(),
        
        .reg_write_JUMP(RegWrite_ctrl_JUMP),.rd_ctrl_JUMP(rd_ctrl_JUMP),
        .reg_write_ALU(RegWrite_ctrl_ALU),  .rd_ctrl_ALU(rd_ctrl_ALU),
        .reg_write_MEM(RegWrite_ctrl_MEM),  .rd_ctrl_MEM(rd_ctrl_MEM),
        .reg_write_MUL(RegWrite_ctrl_MUL),  .rd_ctrl_MUL(rd_ctrl_MUL),
        .reg_write_DIV(RegWrite_ctrl_DIV),  .rd_ctrl_DIV(rd_ctrl_DIV),

        .debug_addr(debug_addr[4:0]),
        .Testout(Test_signal)
    );


    // RO
    Regs register(.clk(debug_clk),.rst(rst),

        //  ALU
        .R_addr_A_ALU( rs1_addr_ctrl_ALU ), .rdata_A_ALU( rs1_data_RO_ALU ),    
        .R_addr_B_ALU( rs2_addr_ctrl_ALU ), .rdata_B_ALU( rs2_data_RO_ALU ),
        .L_S_ALU( RegWrite_ctrl_ALU ),
        .Wt_addr_ALU( rd_ctrl_ALU ), .Wt_data_ALU( ALUout_WB ),

        //  JUMP
        .R_addr_A_JUMP( rs1_addr_ctrl_JUMP ), .rdata_A_JUMP( rs1_data_RO_JUMP ),
        .R_addr_B_JUMP( rs2_addr_ctrl_JUMP ), .rdata_B_JUMP( rs2_data_RO_JUMP ),
        .L_S_JUMP( RegWrite_ctrl_JUMP ),
        .Wt_addr_JUMP( rd_ctrl_JUMP ), .Wt_data_JUMP( PC_wb_WB ),

        //  MEM
        .R_addr_A_MEM( rs1_addr_ctrl_MEM ), .rdata_A_MEM( rs1_data_RO_MEM ),
        .R_addr_B_MEM( rs2_addr_ctrl_MEM ), .rdata_B_MEM( rs2_data_RO_MEM ),
        .L_S_MEM( RegWrite_ctrl_MEM ),
        .Wt_addr_MEM( rd_ctrl_MEM ), .Wt_data_MEM( mem_data_WB ),

        //  MUL
        .R_addr_A_MUL( rs1_addr_ctrl_MUL ), .rdata_A_MUL( rs1_data_RO_MUL ),
        .R_addr_B_MUL( rs2_addr_ctrl_MUL ), .rdata_B_MUL( rs2_data_RO_MUL ),
        .L_S_MUL( RegWrite_ctrl_MUL ),
        .Wt_addr_MUL( rd_ctrl_MUL ), .Wt_data_MUL( mulres_WB ),

        //  DIV
        .R_addr_A_DIV( rs1_addr_ctrl_DIV ), .rdata_A_DIV( rs1_data_RO_DIV ),
        .R_addr_B_DIV( rs2_addr_ctrl_DIV ), .rdata_B_DIV( rs2_data_RO_DIV ),
        .L_S_DIV( RegWrite_ctrl_DIV ),
        .Wt_addr_DIV( rd_ctrl_DIV ), .Wt_data_DIV( divres_WB ),
        
        .Debug_addr(debug_addr[4:0]),.Debug_regs(debug_regs));

    MUX2T1_32 mux_imm_ALU_RO_A(.I0(rs1_data_RO_ALU),.I1(PC_ctrl_ALU),.s(ALUSrcA_ctrl),.o(ALUA_RO));

    MUX2T1_32 mux_imm_ALU_RO_B(.I0(rs2_data_RO_ALU),.I1(imm_ctrl_ALU),.s(ALUSrcB_ctrl),.o(ALUB_RO));


    // FU
    FU_ALU alu(.clk(debug_clk),.EN(FU_ALU_EN),.finish(FU_ALU_finish),
        .ALUControl(ALUControl_ctrl),.ALUA(ALUA_RO),.ALUB(ALUB_RO),.res(ALUout_FU),
        .zero(),.overflow());

    FU_mem mem(.clk(debug_clk),.EN(FU_mem_EN),.finish(FU_mem_finish),
        .mem_w(mem_w_ctrl),.bhw(bhw_ctrl),.rs1_data(rs1_data_RO_MEM),.rs2_data(rs2_data_RO_MEM),
        .imm(imm_ctrl_MEM),.mem_data(mem_data_FU));

    FU_mul mu(.clk(debug_clk),.EN(FU_mul_EN),.finish(FU_mul_finish),
        .A(rs1_data_RO_MUL),.B(rs2_data_RO_MUL),.res(mulres_FU));

    FU_div du(.clk(debug_clk),.EN(FU_div_EN),.finish(FU_div_finish),
        .A(rs1_data_RO_DIV),.B(rs2_data_RO_DIV),.res(divres_FU));

    FU_jump ju(.clk(debug_clk),.EN(FU_jump_EN),.finish(FU_jump_finish),
        .JALR(Jump_ctrl[4]),.cmp_ctrl(Jump_ctrl[3:0]),.rs1_data(rs1_data_RO_JUMP),.rs2_data(rs2_data_RO_JUMP),
        .imm(imm_ctrl_JUMP),.PC(PC_ctrl_JUMP),.PC_jump(PC_jump_FU),.PC_wb(PC_wb_FU),.is_jump(is_jump_FU));


    // WB

    REG32 reg_WB_ALU(.clk(debug_clk),.rst(rst),.CE(FU_ALU_finish),.D(ALUout_FU),.Q(ALUout_WB));       // fill sth. here

    REG32 reg_WB_mem(.clk(debug_clk),.rst(rst),.CE(FU_mem_finish),.D(mem_data_FU),.Q(mem_data_WB));       // fill sth. here      

    REG32 reg_WB_mul(.clk(debug_clk),.rst(rst),.CE(FU_mul_finish),.D(mulres_FU),.Q(mulres_WB));       // fill sth. here

    REG32 reg_WB_div(.clk(debug_clk),.rst(rst),.CE(FU_div_finish),.D(divres_FU),.Q(divres_WB));       // fill sth. here
    
    REG32 reg_WB_jump(.clk(debug_clk),.rst(rst),.CE(FU_jump_finish),.D(PC_wb_FU),.Q(PC_wb_WB));      // fill sth. here


    

endmodule