`include "defines.v"

module alu (input [31:0] a, b, output [15:0] o1, o2, input size, input [4:0] func, output [15:0] flag_o, input en);
	reg [15:0] flag;
	wire [15:0] alu8_flag, alu16_flag;
	wire alu8_en, alu16_en;
	
	always @(alu8_flag) begin
		flag <= alu8_flag;
	end
	always @(alu16_flag) begin
		flag <= alu16_flag;
	end
	
	alu_impl #(.SIZE(8), .LOG2(3)) alu8(a[15:0], b[15:0], o1[7:0], o2[7:0], func, flag, alu8_flag, alu8_en);
	alu_impl #(.SIZE(16), .LOG2(4)) alu16(a, b, o1, o2, func, flag, alu16_flag, alu16_en);
	
	assign alu8_en = (en && !size);
	assign alu16_en = (en && size);
	
	assign flag_o = flag;
endmodule

module alu_impl #(parameter SIZE = 16, parameter LOG2 = 4) (input [SIZE*2-1:0] a, b, output [SIZE-1:0] o1, o2, input [4:0] func, input [15:0] flag_i, output [15:0] flag_o, input en);
	reg [SIZE-1:0] r1, r2;
	reg [15:0] flag;
	
	always @(posedge en) begin
		case (func)
			`ALU_ADD : begin
				{flag[`ALUF_CF], r1} = a[SIZE-1:0] + b[SIZE-1:0];
				flag[`ALUF_OF] = (a[SIZE-1] & b[SIZE-1] & ~r1[SIZE-1])|(~a[SIZE-1] & ~b[SIZE-1] & r1[SIZE-1]);
			end
			`ALU_SUB : begin
				{flag[`ALUF_CF], r1} = a[SIZE-1:0] - b[SIZE-1:0];
				flag[`ALUF_OF] = (a[SIZE-1] & ~b[SIZE-1] & ~r1[SIZE-1])|(~a[SIZE-1] & b[SIZE-1] & r1[SIZE-1]);
			end
			`ALU_AND : begin
				r1 = a[SIZE-1:0] & b[SIZE-1:0];
				flag[`ALUF_CF] = 0;
				flag[`ALUF_OF] = 0;
			end
			`ALU_OR : begin
				r1 = a[SIZE-1:0] & b[SIZE-1:0];
				flag[`ALUF_CF] = 0;
				flag[`ALUF_OF] = 0;
			end
			`ALU_OR : begin
				r1 = a[SIZE-1:0] | b[SIZE-1:0];
				flag[`ALUF_CF] = 0;
				flag[`ALUF_OF] = 0;
			end
			`ALU_XOR : begin
				r1 = a[SIZE-1:0] ^ b[SIZE-1:0];
				flag[`ALUF_CF] = 0;
				flag[`ALUF_OF] = 0;
			end
			`ALU_MUL : begin
				{r2, r1} = a[SIZE-1:0] * b[SIZE-1:0];
				flag[`ALUF_CF] = (r2 != 0);
				flag[`ALUF_OF] = (r2 != 0);
			end
			`ALU_DIV : begin
				r2 = b[SIZE*2-1:0] % a[SIZE-1:0];
				r1 = b[SIZE*2-1:0] / a[SIZE-1:0];
				// flag[`ALUF_CF] = (r2 != 0);
				// flag[`ALUF_OF] = (r2 != 0);
			end
			`ALU_IMUL : begin
				{r2, r1} = $signed(a[SIZE-1:0]) * $signed(b[SIZE-1:0]);
				flag[`ALUF_CF] = (r2 != 0);
				flag[`ALUF_OF] = (r2 != 0);
			end
			`ALU_IDIV : begin
				// todo a == 0
				r2 = $signed(b[SIZE*2-1:0]) % $signed(a[SIZE*2-1:0]);
				r1 = $signed(b[SIZE*2-1:0]) / $signed(a[SIZE*2-1:0]);
				// flag[`ALUF_CF] = (r2 != 0);
				// flag[`ALUF_OF] = (r2 != 0);
			end
			`ALU_NOT : begin
				r1 = ~a[SIZE-1:0];
			end
			`ALU_NEG : begin
				r1 = - a[SIZE-1:0];
				flag[`ALUF_CF] = (r1 == 0);
			end
			`ALU_INC : begin
				r1 = a[SIZE-1:0] + 16'd1;
			end
			`ALU_DEC : begin
				r1 = a[SIZE-1:0] - 16'd1;
			end
			`ALU_SAL : begin
				if (b[LOG2-1:0] != 0) begin
					{flag[`ALUF_CF], r1} = a[SIZE-1:0] << b[LOG2-1:0];
				end
			end
			`ALU_SAR : begin
				if (b[LOG2-1:0] != 0) begin
					r1 = $signed(a[SIZE-1:0]) >>> b[LOG2-1:0];
					flag[`ALUF_CF] = a[b[LOG2-1:0] - 1];
				end
			end
			`ALU_SHR : begin
				if (b[LOG2-1:0] != 0) begin
					r1 = a[SIZE-1:0] >> b[LOG2-1:0];
					flag[`ALUF_CF] = a[b[LOG2-1:0] - 1];
				end
			end
			`ALU_RCL : begin
				if (b[LOG2-1:0] != 0) begin
					{flag[`ALUF_CF], r1, r2} = {a[SIZE-1:0], flag[`ALUF_CF], a[SIZE-1:0]} << (b[LOG2-1:0] - 1);
				end
			end
			`ALU_RCR : begin
				if (b[LOG2-1:0] != 0) begin
					{flag[`ALUF_CF], r1} = {a[SIZE-1:0], flag[`ALUF_CF], a[SIZE-1:0]} >> b[LOG2-1:0];
				end
			end
			`ALU_ROL : begin
				if (b[LOG2-1:0] != 0) begin
					{r1, r2} = {a[SIZE-1:0], a[SIZE-1:0]} << b[LOG2-1:0];
					flag[`ALUF_CF] = r1[0];
				end
			end
			`ALU_ROR : begin
				if (b[LOG2-1:0] != 0) begin
					{r2, r1} = {a[SIZE-1:0], a[SIZE-1:0]} >> b[LOG2-1:0];
					flag[`ALUF_CF] = r1[SIZE-1];
				end
			end
		endcase
		flag[`ALUF_ZF] = (r1 == 0);
		flag[`ALUF_SF] = r1[SIZE-1];
	end
	
	assign o1 = (en) ? r1 : {SIZE{1'bz}};
	assign o2 = (en) ? r2 : {SIZE{1'bz}};
	assign flag_o = flag;
endmodule

module alu_test;
	reg [31:0] a, b;
	wire [15:0] r1, r2;
	reg [4:0] func;
	reg en;
	wire [15:0] flag;
	wire size;
	
	alu alu(a, b, r1, r2, size, func, flag, en);
	
	initial begin
		$monitor("%t: a = %x, b = %x, result = %x %x, flag = %b", $time, a, b, r2, r1, flag[3:0]);
		
		en = 1;
		a <= 32'h7FFF;
		b <= 32'h7FFF;
		func <= `ALU_ADD;
		#10
		func <= `ALU_SUB;
		#10
		a <= 32'hFFFF;
		b <= 32'hFFFF;
		func <= `ALU_ADD;
		#10
		func <= `ALU_SUB;
		#10
		a <= 32'hFFFF;
		b <= 32'hFFFF;
		func <= `ALU_MUL;
		#10 $finish();
	end
	
	always #5 begin
		en <= ~en;
	end
	assign size = 1;
endmodule