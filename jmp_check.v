module jmp_check(input [15:0] addr, pc_i, output [15:0] pc_o, input [3:0] type, input [15:0] flag, input [15:0] cr, input en);
	reg con;
	
	always @(posedge en) begin
		case (type)
			`JMP_FORCE : con <= 1;
			`JMP_E : con <= (flag[`ALUF_ZF] == 1'b1);
			`JMP_NE : con <= (flag[`ALUF_ZF] == 1'b0);
			`JMP_A : con <= (flag[`ALUF_CF] == 1'b0 && flag[`ALUF_ZF] == 1'b0);
			`JMP_AE : con <= (flag[`ALUF_CF] == 1'b0);
			`JMP_B : con <= (flag[`ALUF_CF] == 1'b1);
			`JMP_BE : con <= (flag[`ALUF_CF] == 1'b1 || flag[`ALUF_ZF] == 1'b1);
			`JMP_G : con <= (flag[`ALUF_ZF] == 1'b0 && flag[`ALUF_SF] == flag[`ALUF_OF]);
			`JMP_GE : con <= (flag[`ALUF_SF] == flag[`ALUF_OF]);
			`JMP_L : con <= (flag[`ALUF_SF] != flag[`ALUF_OF]);
			`JMP_LE : con <= (flag[`ALUF_ZF] == 1'b1 || flag[`ALUF_SF] != flag[`ALUF_OF]);
			`JMP_S : con <= (flag[`ALUF_SF] == 1'b1);
			`JMP_NS : con <= (flag[`ALUF_SF] == 1'b0);
			`JMP_O : con <= (flag[`ALUF_OF] == 1'b1);
			`JMP_NO : con <= (flag[`ALUF_OF] == 1'b0);
			`JMP_CRZ : con <= (cr == 16'd0);
			default : begin
				$display("unknown type:%b", type);
				$finish();
			end
		endcase
	end
	
	assign pc_o = (en) ? ((con) ? addr : pc_i) : 16'bz;
endmodule