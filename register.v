module register #(parameter SIZE = 16, parameter DEF = {SIZE{1'bx}}) (input clk, input [SIZE-1:0] i, output reg [SIZE-1:0] o, input [1:0] rw);
	initial o <= DEF;
	
	always @(clk) begin
		case (rw)
			2'b01 : begin
				o[SIZE/2-1 : 0] <= i[SIZE/2-1 : 0];
			end
			2'b10 : begin
				o[SIZE-1 : SIZE/2] <= i[SIZE-1 : SIZE/2];
			end
			2'b11 : begin
				o <= i;
			end
		endcase
	end
endmodule

module bus_register #(parameter SIZE = 16) (input clk, input [SIZE-1:0] i, output reg [SIZE-1:0] o);
	always @(clk) begin
		o <= i;
	end
endmodule

module program_counter #(parameter SIZE = 16) (input clk, input [SIZE-1:0] i, output reg [SIZE-1:0] o, input rw, input [1:0] inc);
	initial o <= 0;
	
	always @(clk) begin
		case (inc)
			2'b00 : begin
				if (rw)
					o <= i;
			end
			2'b01 : o <= o + 2;
			2'b10 : o <= o + 4;
			2'b11 : o <= o + 6;
		endcase
		
	end
endmodule

module simple_register #(parameter SIZE = 16) (input clk, input [SIZE-1:0] i, output reg [SIZE-1:0] o, input rw);
	always @(clk) begin
		if (rw) begin
			o <= i;
		end
	end
endmodule

module register_test;
	reg clk;
	reg [1:0] rw;
	wire [15:0] oline;
	reg [15:0] iline;
	
	register register(clk, iline, oline, rw);

	initial begin
		$monitor("%t: rw = %b, o = %x, i = %x", $time, rw, oline, iline);
		
		clk <= 0;
		#10
		rw <= 2'b11;
		iline <= 16'h1234;
		#10
		rw <= 2'b00;
		iline <= 16'hz;
		#10
		rw <= 2'b11;
		iline <= 16'h4567;
		#10
		rw <= 2'b00;
		iline <= 16'hz;
		#10
		rw <= 2'b01;
		iline <= 16'h89AB;
		#10
		rw <= 2'b00;
		iline <= 16'hz;
		#10
		rw <= 2'b10;
		iline <= 16'hCDEF;
		#10
		rw <= 2'b00;
		iline <= 16'hz;
		#10 $finish;
	end
	
	always #10 begin
		clk <= ~clk;
	end
endmodule
