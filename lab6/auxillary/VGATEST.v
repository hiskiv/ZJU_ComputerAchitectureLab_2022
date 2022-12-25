`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    16:35:20 09/25/2017
// Design Name:
// Module Name:    vga_debug
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
module VGA_TESTP(
	input clk,
	input clk25,
//	input [9:0] PCol,                                      //闂備浇銆€閸嬫捇姊洪锝囥€掗柛鐔凤躬閺屾稑鈻庨幇鎯扳偓鍧楁煕閿濆棙銇濈€规洏鍎遍鑹扮疀閺囩媭妲遍柣搴ｅ仯閸婃繄绱撳棰濇晩闁告侗鍠氶埢鏃傗偓骞垮劤椤庡盯闂備礁鎼崐绋棵洪敃鈧敃銏ゅ级鐠囧墽鍠栭崹鎯х暦閸モ晩鏀ㄧ紓鍌氬€烽懗鍫曞窗瀹ュ洨鍗氶柟缁㈠枟閺咁剟鎮橀悙鐢垫憘闁哄顭烽弻娑㈠籍閸屾碍顔慓A濠电姰鍨奸崺鏍偋閻愪警鏁婇柡鍥ュ灩杩濋梺绋挎湰閻熝呯矙鐠囩潿搴ㄥ炊鐠虹儤鐏嶉梺杞扮閵堢ǹ顫忔繝姘兼晪闁逞屽墴閵嗗倿鎳為妷銉х獮濡炪倕绻愮€氬嘲螣鐎ｎ喗鐓ユ繛鎴炆戝﹢鐗堢箾閸繄绠荤€殿噮鍣ｉ幊婊堝礂缁嬪灝鐏婂┑鐘灱濞夋稓绮欓崟顓燁潟闁跨噦鎷�
//	input [9:0] PRow,                                      //闂備浇銆€閸嬫捇姊洪锝囥€掗柛鐔凤躬閺屾稑鈻庨幇鎯扳偓鍧楁煕閿濆棙銇濋柡浣规崌閺佹捇鏁撻敓锟�??
    input SWO15,                                           //pipeline 闂備礁鎼崐鐟邦熆濮椻偓璺柨鐕傛嫹 闂備礁鎲￠悷銉х矓閻㈠憡鍎戦柛锔诲幘绾句粙鏌″蹇擃洭闁荤喆鍨介弻鐔虹矙閹稿海鐓戦梺纭呯堪閸婃繂鐣峰璺虹倞闁靛ǹ鍎辩花锟�
	input SWO14,                                           //闂佽瀛╃粙鎺楁晪闂佺ǹ顑呯粔鐟邦嚕椤愶附鍋嬮柛顐ｇ箘閵堬妇绱撻崒姘卞妞ゎ厾鍏樻俊瀛樺緞閹邦厽娅㈤梺璺ㄥ櫐閹凤拷??2021 Modify :濠电姭鎷冮崨顓濈捕婵犳鍠氶崑銈咁嚕娴兼潙绀堢憸瀣濞戞ǚ妲堥柟鎯у船閳ь剚娲熼獮搴☆潰婵傛发闂備浇妗ㄩ懗鑸垫櫠濡も偓閻ｇ敻鏁撻敓锟�
	input SWO13,                                           //ROM闂備線娼уΛ鏃堟⒓濞ｅ懂闂備礁鎲＄敮鎺懨洪敃鈧悾鐑芥晸閿燂拷
	input [31:0] Debug_data,
	input [31:0] MEM_Addr,                                 //2021 闂備礁鎼崐鐟邦熆濮椻偓璺柨鐕傛嫹 ROM婵犵數鍋炲娆擃敄閸儲鍎婃い鏍仜閹瑰爼鏌℃径瀣嚋缂佹彃顭烽弻銊╂偆閸屾稑顏�??
	input [31:0] MEM_Data,                                 //2021 闂備礁鎼崐鐟邦熆濮椻偓璺柨鐕傛嫹 ROM 婵犵數鍋炲娆擃敄閸儲鍎婃い鏍仜閺嬩線鏌ｅΔ鈧悧鍡欑矈閿曞倹鐓ラ柣鏇炲€圭€氾拷??

	output[3:0] Red,
    output[3:0] Green,
    output[3:0] Blue,
    output VSYNC,
    output HSYNC,

//	output reg [11:0]dout,
	output [6:0] Debug_addr);

reg [8*89-1:0] Headline="Zhejiang University Computer Organization Experimental SOC Test Environment (With RISC-V)";
reg [31:0] data_buf [0:3];
reg [31:0] MEMBUF[0:255];            //闂佽瀛╃粙鎺楁晪闂佺ǹ顑呯粔鐟扮暦閹惰棄惟闁挎柧鍕橀崑鐐烘煟閻樺弶澶勬繛鍙夛耿瀵娊鎮㈤悡搴ｎ唹濡炪倖鏌ㄦ晶鑺ュ緞閸曨垱鍊垫繛鎴炵懕閸忣剛绱掗幉瀣128闂備礁鎲￠〃鍡椕洪弽顓炲偍闁瑰墽绮弲顒勬倶閻愯泛袚闁稿﹦鏁哥槐鎾存媴閸繃澶勫ù鐘筹耿閹兘寮村槌栨М濡炪們鍊曢崯鏉戠暦濠靛鍋戦柛娑卞灣椤︻喖螖閻橀潧浠︽繝鈧ぐ鎺戠疄闁靛ň鏅涚紒鈺呮偡濞嗗繐顏柍缁樻⒒缁辨帡鍩€椤掑嫬浼犻柛鏇ㄥ幗濮ｅ孩绻涙潏鍓у埌缂佸鎸抽獮蹇斿閺夋垵鍞ㄩ梺缁樻尭濞撮娑甸埀锟�
reg [7:0] ascii_code;
reg [8*7:0] strdata;
reg [11:0]dout;
wire pixel;
wire [9:0] PRow, PCol;

wire  [9:0] row_addr =  PRow - 10'd35;     // pixel ram row addr
wire  [9:0] col_addr =  PCol- 10'd143;    // pixel ram col addr

wire should_latch_debug_data = (PCol < 10'd143) && (PCol[2:0] == 3'b000) && (row_addr[3:0] == 4'b0000);

wire [4:0] char_index_row = row_addr[8:4] - 3;
wire [6:0] char_index_col = (PCol < 10'd143) ? 0 : (col_addr / 8 + 1);
wire [1:0] char_page = char_index_col / 20;
wire [4:0] char_index_in_page = char_index_col % 20;
//wire [2:0] char_index_in_reg_buf = 7 - (char_index_in_page - 9);               //婵犵數鍋涙径鍥礈濠靛棴鑰垮ù锝堫潐婵挳鎮归幁鎺戝闁哄棴鎷�   2021 Modify 婵犵數鍋涢ˇ顓㈠礉閹达箑闂柟缁㈠枟閺呮悂鏌ㄩ悤鍌涘??

//    assign dout = pixel ? {4'b1111, {4{~Debug_addr[5]}}, {4{~Debug_addr[6]}}} : 12'b1100_0000_0000;         //Debug_addr[5]     12'b111111111111
reg flag;
    always @* begin                                                            // 2021 Modify 闂備礁鎲￠悧鏇㈠箹椤愶附鍋傛繛鍡樻尭缁€鍡涙煕閳╁啳澹樻い銉ョ箻閺岋繝宕掗悙鈺佷壕婵炴垶鍩冮弫鈧梺鑽ゅ枑閻熴儵宕愰幖浣瑰剬闁跨噦鎷�
       if(pixel)
            if(flag)dout = 12'b0000_0000_1111;
            else
            case(Debug_addr[6:5])
                2'b00:   dout = 12'b1111_1111_1111;
                2'b01:   dout = 12'b0000_0000_1111;
                2'b10:   dout = 12'b0000_1111_1111;
                default: dout = 12'b0000_1111_1111;
            endcase
      else if(SWO15 && ((row_addr[9:4] == 19 && col_addr[9:3] > 21 && col_addr[9:3] < 38)
                    || (row_addr[9:4] == 20 && col_addr[9:3] > 25 && col_addr[9:3] < 42)
                    || (row_addr[9:4] == 21 && col_addr[9:3] > 30 && col_addr[9:3] < 47)
                    || (row_addr[9:4] == 22 && col_addr[9:3] > 35 && col_addr[9:3] < 52)
                    || (row_addr[9:4] == 23 && col_addr[9:3] > 40 && col_addr[9:3] < 58)))
                dout = 12'b1100_1100_1100;
           else dout = 12'b1000_0000_0000;
    end

assign Debug_addr = {char_index_row , PCol[4:3]};
wire[7:0] current_display_reg_addr = {1'b0, char_index_row, char_page};
reg[31:0] code_if, code_id, code_exe, code_mem, code_wb;
wire [19*8-1:0] inst_if, inst_id, inst_exe, inst_mem, inst_wb;
    always @(negedge clk) begin                                     //2021 Modify 闂備焦瀵х粙鎺楁偤閹绘┇闁诲氦顫夐幃鍫曞磿閹殿喚绀婇柡鍐ㄧ墕閺嬩線鏌ｅΔ鈧悧鍡欑矈閿曞倹鐓曢柟閭﹀幘閹冲啴鏌涘▎娆愬
        MEMBUF[{SWO13,MEM_Addr[8:2]}] <= MEM_Data;                  //SWO13=1缂傚倸鍊搁崐褰掑箰閹间焦鍋ら柍顕呮缚M,闂備礁鎲￠悢顒傜不閹达箑鍨傞柣銈囧瑎M
        case(Debug_addr)
            7'b00100001: code_if <= Debug_data;
            7'b00100101: code_id <= Debug_data;
            7'b00101001: code_exe <= Debug_data;
            7'b00101101: code_mem <= Debug_data;
            7'b00110001: code_wb <= Debug_data;
            default: begin
                code_if <= code_if;
                code_id <= code_id;
                code_exe <= code_exe;
                code_mem <= code_mem;
                code_wb <= code_wb;
            end
        endcase
    end

    Code2Inst c2i1(.code(code_if), .inst(inst_if));
    Code2Inst c2i2(.code(code_id), .inst(inst_id));
    Code2Inst c2i3(.code(code_exe), .inst(inst_exe));
    Code2Inst c2i4(.code(code_mem), .inst(inst_mem));
    Code2Inst c2i5(.code(code_wb), .inst(inst_wb));

    wire [31:0] MEMDATA = MEMBUF[{SWO13,1'b0,SWO14 + Debug_addr[5],Debug_addr[4:0]}];  //2021 Modify 闂備礁鎼€氼剚鏅舵禒瀣︽慨婵嗩殹M/RAM闂備浇妗ㄩ懗鑸垫櫠濡も偓閻ｅ灚绗熼埀顒勫极瀹ュ洣娌柛鎾楀嫧鎸勯梻浣告惈閻楀棝藝閹剁瓔鏁嬮柣妤€鐗婃禍銈夋煕閵夈垺娅嗛柣锝変憾閺屻劑鎮ら崒娑橆伓??0000_00000H闂備線娼уΛ鏃傜紦缁插栋14闂備胶顢婇惌鍥礃閵娧冨箑濠电偞鍨堕幐鍫曞磹閺囥垹绠慨妯垮煐閺咁剟鎮橀悙鎻掆挃婵″眰鍔戦弻銊╂偆閸屾稑顏�??32濠电偞鍨堕幖鈺傜濠婂牊鍋ら柨鐕傛嫹

always @(posedge clk) begin                                         //2021 Modify
	if (should_latch_debug_data) begin
		if(Debug_addr[6]) data_buf[Debug_addr[1:0]] <= MEMDATA;   //闂佽绻掗崑娑氭崲閹邦喚涓嶉梺鍨儑閳绘棃鎮楅敐搴′簼闁绘挻鐟╅弻锟犲礋椤愨懇鎸冮梺闈涙处閻℃彊M闂備浇妗ㄩ懗鑸垫櫠濡も偓閻ｇ敻鏁撻敓锟�
		else data_buf[Debug_addr[1:0]] <= Debug_data;
	end
end
always @(posedge clk) begin
    flag <=0;                                                    //2021 Modify闂備焦瀵х粙鎺楁嚌閻愵剚鍙忛柍鍝勬噹缁犳垵霉閿濆牜娼愰柍缁樻⒒缁辨帡鍩€椤掑嫬浼犻柛鏇ㄥ幗濮ｅ酣姊虹捄銊ユ珢闁瑰嚖鎷�??
	if ((row_addr < 1 * 16) || (row_addr >= 480 - 1 * 16))
        ascii_code <= " ";
    else if(row_addr[9:4] <= 2)
        ascii_code <= row_addr[9:4] == 1 ? (col_addr[9:3] > 13 && col_addr[9:3] < 68 ) ? Headline[(89 - col_addr[9:3] +13)*8 +:8] : " "
                                         : (col_addr[9:3] > 23 && col_addr[9:3] < 58 ) ? Headline[(34 - col_addr[9:3] +23)*8 +:8] : " ";
    else begin
      if(SWO15 && row_addr[9:4] >= 19 && row_addr[9:4] <= 23 && col_addr[9:3] > 21 && col_addr[9:3] < 60) begin
        if(SWO15 && row_addr[9:4] == 19 && col_addr[9:3] > 21 && col_addr[9:3] < 40)begin
           ascii_code <= inst_if[(38 - col_addr[9:3] +2)*8 +:8] ;
           flag <= 1;
        end
        else if(SWO15 && row_addr[9:4] == 20 && col_addr[9:3] > 25 && col_addr[9:3] < 44)begin
           ascii_code <= inst_id[(42 - col_addr[9:3] +2)*8 +:8] ;
           flag <= 1;
        end
        else if(SWO15 && row_addr[9:4] == 21 && col_addr[9:3] > 30 && col_addr[9:3] < 49)begin
           ascii_code <= inst_exe[(47 - col_addr[9:3] +2)*8 +:8] ;
           flag <= 1;
        end
        else if(SWO15 && row_addr[9:4] == 22 && col_addr[9:3] > 35 && col_addr[9:3] < 54)begin
           ascii_code <= inst_mem[(52 - col_addr[9:3] +2)*8 +:8] ;
           flag <= 1;
        end
        else if(SWO15 && row_addr[9:4] == 23 && col_addr[9:3] > 41 && col_addr[9:3] < 60)begin
           ascii_code <= inst_wb[(58 - col_addr[9:3] +2)*8 +:8] ;
           flag <= 1;
        end
        else ascii_code <= " ";
     end
        else if (col_addr[2:0] == 3'b111) begin     //--------------
            if ((char_index_in_page >= 2) && (char_index_in_page <= 8)) begin
                    ascii_code <= strdata[(6 - (char_index_in_page - 2)) * 8 +:8];
            end
            else if ((char_index_in_page >= 10) && (char_index_in_page <= 10 + 7)) begin
                    ascii_code <=  num2str(data_buf[char_page][(7 - (char_index_in_page - 10)) * 4  +: 4]);
            end else ascii_code <= " ";
        end
        else ascii_code <= ascii_code;
    end
end

    wire [8*5:0] MEMADDRSTR = SWO13 ? "RAM:0" : "CODE-";                                   //闂備礁鎲＄敮鎺懨洪敃鈧悾鐑芥儓缁嬬兂/ROM闂備線娼婚梽鍕熆濡警鐒介柛鎰靛枛閸欏﹪鏌涢幘妞炬缁敻姊洪崫鍕㈡繛灞傚€楅幑銏ゆ晸閿燂拷
always @(posedge clk) begin                                                                 //2021 Modify ,闂備礁鎲￠懝鍓р偓娑掓櫅閿曘垽鍩勯崘鈺€姘﹀┑顔姐仜閸嬫挻绻涢幘鍐差暢闁硅尙澧楅幏鍛存偩鐏炵虎鍟€闂備浇娉曢崳锕傚箯閿燂拷??
		case (current_display_reg_addr[7:5])
			3'b000: //strdata <= {"REG-x", num2str(current_display_reg_addr[5:4]), num2str(current_display_reg_addr[3:0])};
			//begin strdata[23:0] <= {"x",num2str(current_display_reg_addr[5:4]), num2str(current_display_reg_addr[3:0])};
			       case (current_display_reg_addr[4:0])
			       0: strdata <= "x0:zero";
			       1: strdata <= "x01: ra";
			       2: strdata <= "x02: sp";
			       3: strdata <= "x03: gp";
			       4: strdata <= "x04: tp";
                   5: strdata <= "x05: t0";
                   6: strdata <= "x06: t1";
                   7: strdata <= "x07: t2";

 			       8: strdata <= "x8:fps0";
                   9: strdata <= "x09: s1";
                  10: strdata <= "x10: a0";
                  11: strdata <= "x11: a1";
                  12: strdata <= "x12: a2";
                  13: strdata <= "x13: a3";
                  14: strdata <= "x14: a4";
                  15: strdata <= "x15: a5";
                  16: strdata <= "x16: a6";
                  17: strdata <= "x17: a7";

                  18: strdata <= "x18: s2";
                  19: strdata <= "x19: s3";
                  20: strdata <= "x20: s4";
                  21: strdata <= "x21: s5";
                  22: strdata <= "x22: s6";
                  23: strdata <= "x23: s7";
                  24: strdata <= "x24: s8";
                  25: strdata <= "x25: s9";
                  26: strdata <= "x26:s10";
                  27: strdata <= "x27:s11";
                  28: strdata <= "x28: t3";
                  29: strdata <= "x29: t4";
                  30: strdata <= "x30: t5";
                  31: strdata <= "x31: t6";
			       default: strdata <= "-------";
               endcase
//            end

			3'b001: case (current_display_reg_addr[4:0])
				// datapath debug signals, MUST be compatible with 'debug_data_signal' in 'datapath.v'
				0:  strdata <= "PC---IF";
				1:  strdata <= "INST-IF";
				2:  strdata <= "PC---IS";
				3:  strdata <= "INST-IS";
                
                4:  strdata <= "1-ALU-I";   //  FUS-ALU
				5:  strdata <= "B/D/WAR";
				6:  strdata <= "F/R/Q-j";
				7:  strdata <= "F/R/Q-k";

				8:  strdata <= "2-MEM-I";   //  FUS-MEM
				9:  strdata <= "B/D/WAR";
				10: strdata <= "F/R/Q-j";
				11: strdata <= "F/R/Q-k";

				12: strdata <= "3-MUL-I";   //  FUS-MUL
				13: strdata <= "B/D/WAR";
				14: strdata <= "F/R/Q-j";
				15: strdata <= "F/R/Q-k";

				16: strdata <= "4-DIV-I";   //  FUS-DIV
				17: strdata <= "B/D/WAR";
				18: strdata <= "F/R/Q-j";
				19: strdata <= "F/R/Q-k";

				20: strdata <= "5-JMP-I";   //  FUS-JUMP
				21: strdata <= "B/D/WAR";
				22: strdata <= "F/R/Q-j";
				23: strdata <= "F/R/Q-k";

                24: strdata <= "R/00-03";   //  RRS
				25: strdata <= "R/04-07";
				26: strdata <= "R/08-11";
				27: strdata <= "R/12-15";

				28: strdata <= "R/16-19";   //  RRS
				29: strdata <= "R/20-23";
				30: strdata <= "R/24-27";
				31: strdata <= "R/28-31";



				default: strdata <= "RESERVE";
			endcase
			3'b010: strdata <= {MEMADDRSTR, num2str({SWO14 + current_display_reg_addr[5],current_display_reg_addr[4]}), num2str(current_display_reg_addr[3:0])};
			3'b011: strdata <= {MEMADDRSTR, num2str({SWO14 ,current_display_reg_addr[5]}+1'b1), num2str(current_display_reg_addr[3:0])};
//			3'b010: strdata <= {MEMADDRSTR, num2str({SWO14 + current_display_reg_addr[5],current_display_reg_addr[4]}), num2str(current_display_reg_addr[3:0])};

			default: strdata <= "RESERVE";
		endcase
end


FONT8_16 FONT_8X16 (                               //闂備礁鎲￠懝鎯归悜鑺ュ仺缂備焦顭囬埞宥嗐亜閺冨洤袚闁哄棭鍘奸埥澶愬箻鐠哄搫濡洪梺缁樼壄缂嶄礁鐣峰▎鎾冲耿婵°倕鍟幉濠氭⒑鐠恒劌娅愰柟鍑ゆ嫹??
	.clk(clk),
	.ascii_code(ascii_code[6:0]),
	.row(row_addr[3:0]),
	.col(col_addr[2:0]),
	.row_of_pixels(pixel)
);

	function [7:0] num2str;
		input [3:0] number;
		begin
			if (number < 10)
				num2str = "0" + number;
			else
				num2str = "A" - 10 + number;
		end
	endfunction


        vga     U12(.clk(clk25),
                    .rst(1'b0),
                    .Din(dout),
                    .PCol(PCol),
                    .PRow(PRow),
                    .R(Red),
                    .G(Green),
                    .B(Blue),
                    .VS(VSYNC),
                    .HS(HSYNC),
                    .rdn(),
                    .vgaclk()
                     );


endmodule
