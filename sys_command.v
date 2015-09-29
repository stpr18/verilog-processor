module sys_command(input [47:0] cmd, input cl_size, input [15:0] o, r0, r1, r2, r3, r4, r5, r6, r7, flag, input en);
	always @(posedge en) begin
		case (cmd[39:36])
			`CMD_TYPE_DFIN : begin
				$finish();
			end
			`CMD_TYPE_DDIS1, `CMD_TYPE_DDIS2 : begin
				case (cmd[35:32])
					`CMDARG_DIS_C : begin
						if (cl_size)
							$write("%C", o);
						else
							$write("%C", o[7:0]);
					end
					`CMDARG_DIS_B : begin
						if (cl_size)
							$write("%b", o);
						else
							$write("%b", o[7:0]);
					end
					`CMDARG_DIS_O : begin
						if (cl_size)
							$write("%o", o);
						else
							$write("%o", o[7:0]);
					end
					`CMDARG_DIS_D : begin
						if (cl_size)
							$write("%h", $signed(o));
						else
							$write("%h", $signed(o[7:0]));
					end
					`CMDARG_DIS_H : begin
						if (cl_size)
							$write("%h", o);
						else
							$write("%h", o[7:0]);
					end
					`CMDARG_DIS_U : begin
						if (cl_size)
							$write("%d", o);
						else
							$write("%d", o[7:0]);
					end
				endcase
			end
			`CMD_TYPE_DMPR : begin
				$display("[Register]");
				$display("R0:%h R1:%h R2:%h R3:%h R4:%h R5:%h R6:%h R7:%h", r0, r1, r2, r3, r4, r5, r6, r7);
				$display("ZF:%b SF:%b CF:%b OF:%b", flag[`ALUF_ZF], flag[`ALUF_SF], flag[`ALUF_CF], flag[`ALUF_OF]);
			end
		endcase
	end
endmodule