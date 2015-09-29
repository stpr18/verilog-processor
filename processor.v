`default_nettype none

`include "defines.v"
`include "clock.v"
`include "register.v"
`include "memory.v"
`include "bus_copy.v"
`include "alu.v"
`include "jmp_check.v"
`include "loop_check.v"
`include "sys_command.v"
`include "stage_decode.v"

module processor;
	wire [15:0] bus[0:1];
	wire [15:0] o[0:1];
	tri0 [7:0] bus_i_en[0:1];
	tri0 [7:0] bus_o_en[0:1];
	wire cl_size;
	
	bus_register bus0r(clk, bus[0], o[0]);
	bus_register bus1r(clk, bus[1], o[1]);
	
	wire clk;
	wire [3:0] state;
	
	clock clock(clk, state);
	
	wire [47:0] mem_r;
	wire [15:0] mem_addr;
	wire [1:0] mem_rw;
	
	memory memory(clk, {16'bx, o[0]}, mem_r, mem_addr, mem_rw);
	
	wire [15:0] pc_o;
	wire pc_rw;
	wire [1:0] pc_inc;
	program_counter pc(clk, o[0], pc_o, pc_rw, pc_inc);
	
	wire [47:0] cmd_o;
	wire cmd_rw;
	simple_register #(.SIZE(48)) cmd(clk, mem_r, cmd_o, cmd_rw);
	
	wire [15:0] gr_i[0:7];
	wire [15:0] gr_o[0:7];
	tri0 [1:0] gr_rw[0:7];
	
	register r0(clk, gr_i[0], gr_o[0], gr_rw[0]);
	register r1(clk, gr_i[1], gr_o[1], gr_rw[1]);
	register r2(clk, gr_i[2], gr_o[2], gr_rw[2]);
	register r3(clk, gr_i[3], gr_o[3], gr_rw[3]);
	register r4(clk, gr_i[4], gr_o[4], gr_rw[4]);
	register r5(clk, gr_i[5], gr_o[5], gr_rw[5]);
	register r6(clk, gr_i[6], gr_o[6], gr_rw[6]);
	register r7(clk, gr_i[7], gr_o[7], gr_rw[7]);
	
	wire [15:0] bus_1_copy_o;
	wire bus_1_copy_en;
	bus_copy bus_1_copy(o[1], bus_1_copy_o, bus_1_copy_en);
	
	wire [4:0] alu_func;
	wire [31:0] alu_i1, alu_i2;
	wire [15:0] alu_o1, alu_o2;
	wire [15:0] alu_flag_o;
	wire alu_en;
	alu alu(alu_i1, alu_i2, alu_o1, alu_o2, cl_size, alu_func, alu_flag_o, alu_en);
	
	wire [15:0] jmp_addr;
	wire jmp_en, loop_en;
	wire [15:0] loop_cnt_o;
	wire [15:0] cr;
	jmp_check jmp_check(o[0], pc_o, jmp_addr, cmd_o[41:38], alu_flag_o, cr, jmp_en);
	loop_check loop_check(o[0], pc_o, jmp_addr, cmd_o[39:38], alu_flag_o[`ALUF_ZF], cr, loop_cnt_o, loop_en);
	
	wire sys_en;
	sys_command sys_command(cmd_o, cl_size, o[0], gr_o[0], gr_o[1], gr_o[2], gr_o[3], gr_o[4], gr_o[5], gr_o[6], gr_o[7], alu_flag_o, sys_en);
	
	wire [15:0] bus_i_en_decode[0:1];
	wire [15:0] bus_o_en_decode[0:1];
	wire [31:0] mem_addr_decode;
	wire fetch_en, decode_en, execute_en, write_en;
	
	wire [1:0] pc_inc_o;
	// wire [1:0] sp_rw;
	// tri0 [1:0] sp_rw_o;
	
	assign fetch_en = (state == `STATE_FETCH);
	assign mem_addr = (fetch_en) ? pc_o : (decode_en) ? mem_addr_decode[15:0] : (write_en) ? mem_addr_decode[31:16] : 16'bx;
	
	stage_decode stage_decode(decode_en, cmd_o, pc_inc_o, cl_size, mem_addr_decode, alu_func, bus_i_en_decode[0], bus_i_en_decode[1], bus_o_en_decode[0], bus_o_en_decode[1], gr_o[0], gr_o[1], gr_o[2], gr_o[3], gr_o[4], gr_o[5], gr_o[6], gr_o[7]);
	assign decode_en = (state == `STATE_DECODE);
	assign bus_i_en[0] = (decode_en) ? bus_i_en_decode[0][7:0] : 8'bz;
	assign bus_i_en[1] = (decode_en) ? bus_i_en_decode[1][7:0] : 8'bz;
	assign pc_inc = (decode_en) ? pc_inc_o : 0;
	// assign sp_rw = (decode_en) ? sp_rw_o : 2'b00;
	
	assign execute_en = (state == `STATE_EXECUTE);
	assign bus_i_en[0] = (execute_en) ? bus_i_en_decode[0][15:8] : 8'bz;
	assign bus_i_en[1] = (execute_en) ? bus_i_en_decode[1][15:8] : 8'bz;
	assign bus_o_en[0] = (execute_en) ? bus_o_en_decode[0][7:0] : 8'bz;
	assign bus_o_en[1] = (execute_en) ? bus_o_en_decode[1][7:0] : 8'bz;
	
	assign write_en = (state == `STATE_WRITE);
	assign bus_o_en[0] = (write_en) ? bus_o_en_decode[0][15:8] : 8'bz;
	assign bus_o_en[1] = (write_en) ? bus_o_en_decode[1][15:8] : 8'bz;
	
	assign cr = gr_o[2];
	
	assign cmd_rw = (state == `STATE_FETCH);
	
	assign mem_rw = (bus_o_en[0] == `BUS_MEMORY) ? ((cl_size) ? 2'b10 : 2'b01) : 2'b00 ;
	assign pc_rw = (bus_o_en[0] == `BUS_PC) ? 1'b1 : 1'b0 ;
	
	assign bus_1_copy_en = (bus_o_en[1] == `BUS_COPY);
	assign alu_en = (bus_o_en[0] == `BUS_ALU);
	assign jmp_en = (bus_o_en[0] == `BUS_JMP);
	assign loop_en = (bus_o_en[0] == `BUS_LOOP);
	assign sys_en = (bus_o_en[0] == `BUS_SYS);
	
	assign alu_i1 = (cmd_o[47:40] == `CMD_MULDIV_UPPER) ? {16'bx, o[0]} : {16'bx, o[0]};
	assign alu_i2 = (cmd_o[47:40] == `CMD_MULDIV_UPPER) ? {gr_o[1], gr_o[0]} : {16'bx, o[1]};
	
	assign bus[0] = (bus_i_en[0] == `BUS_COPY) ? bus_1_copy_o : 16'bz;
	assign bus[0] = (bus_i_en[0] == `BUS_ALU) ? alu_o1 : 16'bz;
	assign bus[1] = (bus_i_en[1] == `BUS_ALU) ? alu_o2 : 16'bz;
	assign bus[0] = (bus_i_en[0] == `BUS_JMP) ? jmp_addr : 16'bz;
	assign bus[0] = (bus_i_en[0] == `BUS_LOOP) ? jmp_addr : 16'bz;
	assign bus[1] = (bus_i_en[1] == `BUS_LOOP) ? loop_cnt_o : 16'bz;

	generate
		genvar i;
		for (i = 0; i < 2; i = i + 1) begin
			assign bus[i] = (bus_i_en[i] == `BUS_R0) ? gr_o[0] : (bus_i_en[i] == `BUS_RH0) ? {8'b00, gr_o[0][15:8]} : (bus_i_en[i] == `BUS_RL0) ? {8'b00, gr_o[0][7:0]} : 16'bz;
			assign bus[i] = (bus_i_en[i] == `BUS_R1) ? gr_o[1] : (bus_i_en[i] == `BUS_RH1) ? {8'b00, gr_o[1][15:8]} : (bus_i_en[i] == `BUS_RL1) ? {8'b00, gr_o[1][7:0]} : 16'bz;
			assign bus[i] = (bus_i_en[i] == `BUS_R2) ? gr_o[2] : (bus_i_en[i] == `BUS_RH2) ? {8'b00, gr_o[2][15:8]} : (bus_i_en[i] == `BUS_RL2) ? {8'b00, gr_o[2][7:0]} : 16'bz;
			assign bus[i] = (bus_i_en[i] == `BUS_R3) ? gr_o[3] : (bus_i_en[i] == `BUS_RH3) ? {8'b00, gr_o[3][15:8]} : (bus_i_en[i] == `BUS_RL3) ? {8'b00, gr_o[3][7:0]} : 16'bz;
			assign bus[i] = (bus_i_en[i] == `BUS_R4) ? gr_o[4] : 16'bz;
			assign bus[i] = (bus_i_en[i] == `BUS_R5) ? gr_o[5] : 16'bz;
			assign bus[i] = (bus_i_en[i] == `BUS_R6) ? gr_o[6] : 16'bz;
			assign bus[i] = (bus_i_en[i] == `BUS_R7) ? gr_o[7] : 16'bz;
			assign bus[i] = (bus_i_en[i] == `BUS_CMDARG_1) ? cmd_o[31:16] : 16'bz;
			assign bus[i] = (bus_i_en[i] == `BUS_CMDARG_2) ? cmd_o[15:0] : 16'bz;
			assign bus[i] = (bus_i_en[i] == `BUS_MEMORY) ? (cl_size) ? mem_r[47:32] : {8'b00, mem_r[47:40]} : 16'bz;
			
			assign gr_rw[0] = (bus_o_en[i] == `BUS_R0) ? 2'b11 : (bus_o_en[i] == `BUS_RH0) ? 2'b1z : (bus_o_en[i] == `BUS_RL0) ? 2'bz1 : 2'bzz ;
			assign gr_rw[1] = (bus_o_en[i] == `BUS_R1) ? 2'b11 : (bus_o_en[i] == `BUS_RH1) ? 2'b1z : (bus_o_en[i] == `BUS_RL1) ? 2'bz1 : 2'bzz ;
			assign gr_rw[2] = (bus_o_en[i] == `BUS_R2) ? 2'b11 : (bus_o_en[i] == `BUS_RH2) ? 2'b1z : (bus_o_en[i] == `BUS_RL2) ? 2'bz1 : 2'bzz ;
			assign gr_rw[3] = (bus_o_en[i] == `BUS_R3) ? 2'b11 : (bus_o_en[i] == `BUS_RH3) ? 2'b1z : (bus_o_en[i] == `BUS_RL3) ? 2'bz1 : 2'bzz ;
			
			assign gr_i[0] = (bus_o_en[i] == `BUS_R0) ? o[i] : (bus_o_en[i] == `BUS_RH0) ? {o[i][7:0], 8'bz} : (bus_o_en[i] == `BUS_RL0) ? {8'bz, o[i][7:0]} : 16'bz ;
			assign gr_i[1] = (bus_o_en[i] == `BUS_R1) ? o[i] : (bus_o_en[i] == `BUS_RH1) ? {o[i][7:0], 8'bz} : (bus_o_en[i] == `BUS_RL1) ? {8'bz, o[i][7:0]} : 16'bz ;
			assign gr_i[2] = (bus_o_en[i] == `BUS_R2) ? o[i] : (bus_o_en[i] == `BUS_RH2) ? {o[i][7:0], 8'bz} : (bus_o_en[i] == `BUS_RL2) ? {8'bz, o[i][7:0]} : 16'bz ;
			assign gr_i[3] = (bus_o_en[i] == `BUS_R3) ? o[i] : (bus_o_en[i] == `BUS_RH3) ? {o[i][7:0], 8'bz} : (bus_o_en[i] == `BUS_RL3) ? {8'bz, o[i][7:0]} : 16'bz ;
		end
	endgenerate
	
	assign gr_rw[4] = (bus_o_en[0] == `BUS_R4) ? 2'b11 : 2'bzz ;
	assign gr_rw[5] = (bus_o_en[0] == `BUS_R5) ? 2'b11 : 2'bzz ;
	assign gr_rw[6] = (bus_o_en[0] == `BUS_R6) ? 2'b11 : 2'bzz ;
	assign gr_rw[7] = (bus_o_en[0] == `BUS_R7) ? 2'b11 : 2'bzz ;
	// assign gr_rw[7] = (sp_rw == 2'b01 || sp_rw == 2'b11) ? 2'b11 : 2'bzz ;
	
	assign gr_i[4] = (bus_o_en[0] == `BUS_R4) ? o[0] : 16'bz ;
	assign gr_i[5] = (bus_o_en[0] == `BUS_R5) ? o[0] : 16'bz ;
	assign gr_i[6] = (bus_o_en[0] == `BUS_R6) ? o[0] : 16'bz ;
	assign gr_i[7] = (bus_o_en[0] == `BUS_R7) ? o[0] : 16'bz ;
	// assign gr_i[7] = (sp_rw == 2'b01) ? gr_o[7] - 2 : (sp_rw == 2'b11) ? gr_o[7] + 2 : 16'bz ;
	
	initial begin
		$dumpfile("processor.vcd");
		$dumpvars(0);
	end
endmodule

`default_nettype wire