`include "defines.v"

module stage_decode(input en, input [47:0] cmd_o, output reg [1:0] pc_inc, output reg cl_size, output [31:0] mem_addr, output reg [4:0] alu_func, output [15:0] bus_i_en_0, bus_i_en_1, bus_o_en_0, bus_o_en_1, input [15:0] r0, r1, r2, r3, r4, r5, r6, r7);
	reg [7:0] bus_i_en_d[0:1], bus_i_en_e[0:1], bus_o_en_e[0:1], bus_o_en_w[0:1];
	reg [15:0] mem_addr_d, mem_addr_w;
	reg diff_mem;
	
	assign bus_i_en_0 = {bus_i_en_e[0], bus_i_en_d[0]};
	assign bus_i_en_1 = {bus_i_en_e[1], bus_i_en_d[1]};
	assign bus_o_en_0 = {bus_o_en_w[0], bus_o_en_e[0]};
	assign bus_o_en_1 = {bus_o_en_w[1], bus_o_en_e[1]};
	assign mem_addr = (diff_mem) ? {mem_addr_w, mem_addr_d} : {mem_addr_d, mem_addr_d};
	
	initial begin
		bus_i_en_d[0] <= 0;
		bus_i_en_d[1] <= 0;
		bus_i_en_e[0] <= 0;
		bus_i_en_e[1] <= 0;
		bus_o_en_e[0] <= 0;
		bus_o_en_e[1] <= 0;
		bus_o_en_w[0] <= 0;
		bus_o_en_w[1] <= 0;
		diff_mem <= 0;
		// sp_rw <= 2'b00;
	end
	
	function regsize(input [3:0] r);
		case (r)
			`REG_R0, `REG_R1, `REG_R2, `REG_R3, `REG_R4, `REG_R5, `REG_R6, `REG_R7 : regsize = 1'b1;
			`REG_RH0, `REG_RL0, `REG_RH1, `REG_RL1, `REG_RH2, `REG_RL2, `REG_RH3, `REG_RL3 : regsize = 1'b0;
			default : regsize = 1'bx;
		endcase
	endfunction
	
	function [15:0] memaddrcalc(input [3:0] mode, input [15:0] addr);
		case (mode)
			0 : memaddrcalc = r0 + addr;
			1 : memaddrcalc = r1 + addr;
			2 : memaddrcalc = r2 + addr;
			3 : memaddrcalc = r3 + addr;
			4 : memaddrcalc = r4 + addr;
			5 : memaddrcalc = r5 + addr;
			6 : memaddrcalc = r6 + addr;
			7 : memaddrcalc = r7 + addr;
			8 : memaddrcalc = r3 + r6 + addr;
			9 : memaddrcalc = r3 + r7 + addr;
			10 : memaddrcalc = r4 + r6 + addr;
			11 : memaddrcalc = r4 + r7 + addr;
			12 : memaddrcalc = r5 + r6 + addr;
			13 : memaddrcalc = r5 + r7 + addr;
			15 : memaddrcalc = addr;
			default : memaddrcalc = 16'bx;
		endcase
	endfunction
	
	always @(posedge en) begin
		bus_i_en_d[0] <= 0;
		bus_i_en_d[1] <= 0;
		bus_i_en_e[0] <= 0;
		bus_i_en_e[1] <= 0;
		bus_o_en_e[0] <= 0;
		bus_o_en_e[1] <= 0;
		bus_o_en_w[0] <= 0;
		bus_o_en_w[1] <= 0;
		diff_mem <= 0;
		// sp_rw <= 2'b00;
		
		/* --- Arg 1 --- */
		if (cmd_o[47:46] != 2'b11) begin 
			case (cmd_o[42:40])
				`CMDARG_1_RR : begin
					cl_size = regsize(cmd_o[39:36]);
					bus_i_en_d[0] <= `REG2BUS(cmd_o[39:36]);
					bus_i_en_d[1] <= `REG2BUS(cmd_o[35:32]);
					if (cmd_o[47] == 1'b0) begin
						bus_o_en_w[0] <= `REG2BUS(cmd_o[39:36]);
					end
					pc_inc <= 1;
				end
				`CMDARG_1_RM : begin
					mem_addr_d <= memaddrcalc(cmd_o[35:32], cmd_o[31:16]);
					cl_size = regsize(cmd_o[39:36]);
					bus_i_en_d[0] <= `REG2BUS(cmd_o[39:36]);
					bus_i_en_d[1] <= `BUS_MEMORY;
					if (cmd_o[47] == 1'b0) begin
						bus_o_en_w[0] <= `REG2BUS(cmd_o[39:36]);
					end
					pc_inc <= 2;
				end
				`CMDARG_1_RI : begin
					cl_size = regsize(cmd_o[39:36]);
					bus_i_en_d[0] <= `REG2BUS(cmd_o[39:36]);
					bus_i_en_d[1] <= `BUS_CMDARG_1;
					if (cmd_o[47] == 1'b0) begin
						bus_o_en_w[0] <= `REG2BUS(cmd_o[39:36]);
					end
					pc_inc <= 2;
				end
				`CMDARG_1_MR : begin
					mem_addr_d <= memaddrcalc(cmd_o[39:36], cmd_o[31:16]);
					cl_size = regsize(cmd_o[35:32]);
					bus_i_en_d[0] <= `BUS_MEMORY;
					bus_i_en_d[1] <= `REG2BUS(cmd_o[35:32]);
					if (cmd_o[47] == 1'b0) begin
						bus_o_en_w[0] <= `BUS_MEMORY;
					end
					pc_inc <= 2;
				end
				`CMDARG_1_MI : begin
					mem_addr_d <= memaddrcalc(cmd_o[39:36], cmd_o[31:16]);
					cl_size = cmd_o[32];
					bus_i_en_d[0] <= `BUS_MEMORY;
					bus_i_en_d[1] <= `BUS_CMDARG_2;
					if (cmd_o[47] == 1'b0) begin
						bus_o_en_w[0] <= `BUS_MEMORY;
					end
					pc_inc <= 3;
				end
				default : begin
					$display("Unknown arg : %x", cmd_o);
					$finish();
				end
			endcase
			
			if (cmd_o[47:43] == `CMD_MOV) begin
				bus_o_en_e[1] <= `BUS_COPY;
				bus_i_en_e[0] <= `BUS_COPY;
			end else begin
				bus_o_en_e[0] <= `BUS_ALU;
				bus_i_en_e[0] <= `BUS_ALU;
				
				case (cmd_o[47:43])
					`CMD_ADD : alu_func <= `ALU_ADD;
					`CMD_SUB : alu_func <= `ALU_SUB;
					`CMD_AND : alu_func <= `ALU_AND;
					`CMD_OR : alu_func <= `ALU_OR;
					`CMD_XOR : alu_func <= `ALU_XOR;
					`CMD_SAL : alu_func <= `ALU_SAL;
					`CMD_SAR : alu_func <= `ALU_SAR;
					`CMD_SHR : alu_func <= `ALU_SHR;
					`CMD_RCL : alu_func <= `ALU_RCL;
					`CMD_RCR : alu_func <= `ALU_RCR;
					`CMD_ROL : alu_func <= `ALU_ROL;
					`CMD_ROR : alu_func <= `ALU_ROR;
					`CMD_TEST : alu_func <= `ALU_AND;
					`CMD_CMP : alu_func <= `ALU_SUB;
					default : begin
						$display("Unknown arg : %x", cmd_o);
						$finish();
					end
				endcase
			end
		/* --- Arg 2 --- */
		end else if (cmd_o[47:45] == 3'b110) begin
			case (cmd_o[37:36])
				`CMDARG_2_R : begin
					cl_size = regsize(cmd_o[35:32]);
					bus_i_en_d[0] <= `REG2BUS(cmd_o[35:32]);
					pc_inc <= 1;
				end
				`CMDARG_2_M1, `CMDARG_2_M2 : begin
					mem_addr_d <= memaddrcalc(cmd_o[35:32], cmd_o[31:16]);
					cl_size = cmd_o[37];
					bus_i_en_d[0] <= `BUS_MEMORY;
					pc_inc <= 2;
				end
				`CMDARG_2_I : begin
					cl_size = cmd_o[32];
					bus_i_en_d[0] <= `BUS_CMDARG_1;
					pc_inc <= 2;
				end
			endcase
			
			case (cmd_o[47:42])
				`CMD_ALU_UPPER : begin
					bus_o_en_e[0] <= `BUS_ALU;
					bus_o_en_e[1] <= `BUS_ALU;
					bus_i_en_e[0] <= `BUS_ALU;
					bus_i_en_e[1] <= `BUS_ALU;
					
					case (cmd_o[41:38])
						`CMD_MUL_LOWER : alu_func <= `ALU_MUL;
						`CMD_IMUL_LOWER : alu_func <= `ALU_IMUL;
						`CMD_DIV_LOWER : alu_func <= `ALU_DIV;
						`CMD_IDIV_LOWER : alu_func <= `ALU_IDIV;
						`CMD_NOT_LOWER : alu_func <= `ALU_NOT;
						`CMD_NEG_LOWER : alu_func <= `ALU_NEG;
						`CMD_INC_LOWER : alu_func <= `ALU_INC;
						`CMD_DEC_LOWER : alu_func <= `ALU_DEC;
						default : begin
							$display("Unknown arg : %x", cmd_o);
							$finish();
						end
					endcase
					
					case (cmd_o[41:38])
						`CMD_MUL_LOWER, `CMD_IMUL_LOWER, `CMD_DIV_LOWER, `CMD_IDIV_LOWER : begin
							bus_o_en_w[0] <= (cl_size) ? `BUS_R0 : `BUS_RL0 ;
							bus_o_en_w[1] <= (cl_size) ? `BUS_R1 : `BUS_RH0 ;
						end
						`CMD_NOT_LOWER, `CMD_NEG_LOWER, `CMD_INC_LOWER, `CMD_DEC_LOWER : begin
							case (cmd_o[37:36])
								`CMDARG_2_R : begin
									bus_o_en_w[0] <= `REG2BUS(cmd_o[35:32]);
								end
								`CMDARG_2_M1, `CMDARG_2_M2 : begin
									// mem_addr <= memaddrcalc(cmd_o[35:32], cmd_o[31:16]);
									bus_o_en_w[0] <= `BUS_MEMORY;
								end
								default : begin
									$display("Unknown arg : %x", cmd_o);
									$finish();
								end
							endcase
						end
						default : begin
							$display("Unknown arg : %x", cmd_o);
							$finish();
						end
					endcase
				end
				`CMD_JMP_UPPER : begin
					bus_o_en_e[0] <= `BUS_JMP;
					bus_i_en_e[0] <= `BUS_JMP;
					bus_o_en_w[0] <= `BUS_PC;
				end
				`CMD_LOOP_UPPER : begin
					bus_o_en_e[0] <= `BUS_LOOP;
					bus_i_en_e[0] <= `BUS_LOOP;
					bus_i_en_e[1] <= `BUS_LOOP;
					bus_o_en_w[0] <= `BUS_PC;
					bus_o_en_w[1] <= `BUS_R2;
				end
				/*`CMD_STACK_UPPER : begin
					case (cmd_o[41:38])
						`CMD_PUSH_LOWER : begin
							sp_rw <= 2'b01;
						end
						`CMD_POP_LOWER : begin
							sp_rw <= 2'b11;
						end
						default : begin
							$display("Unknown arg : %x", cmd_o);
							$finish();
						end
					endcase
				end*/
			endcase
		/* --- Arg 4 --- */
		end else if (cmd_o[47:40] == `CMD_SYS) begin
			bus_o_en_e[0] <= `BUS_SYS;
			
			case (cmd_o[39:36])
				`CMD_TYPE_DFIN : begin
					pc_inc <= 1;
				end
				`CMD_TYPE_DDIS1, `CMD_TYPE_DDIS2 : begin
					mem_addr_d <= cmd_o[31:16];
					cl_size = cmd_o[37];
					bus_i_en_d[0] <= `BUS_MEMORY;
					pc_inc <= 2;
				end
				`CMD_TYPE_DMPR : begin
					pc_inc <= 1;
				end
				default : begin
					$display("Unknown arg : %x", cmd_o);
					$finish();
				end
			endcase
		/* --- Arg error --- */
		end else begin
			$display("Unknown cmd : %x", cmd_o);
			$finish();
		end
	end
endmodule