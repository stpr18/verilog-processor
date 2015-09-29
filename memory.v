module memory(input clk, input [31:0] idata, output [47:0] odata, input [15:0] addr, input [1:0] rw);
	reg [7:0] data [0:2**16-1];
	
	initial $readmemb("mem_init.txt", data);
	
	always @(clk) begin
		case (rw)
			2'b01 : begin
				data[addr] <= idata;
			end
			2'b10 : begin
				{data[addr], data[addr + 1] } <= idata;
			end
			2'b11 : begin
				{data[addr], data[addr + 1], data[addr + 2], data[addr + 3] } <= idata;
			end
		endcase
	end
	
	assign odata = {data[addr], data[addr + 1], data[addr + 2], data[addr + 3], data[addr + 4], data[addr + 5] };
endmodule

module memory_test;
	reg clk;
	reg [1:0] rw;
	reg [15:0] addr;
	wire line;
	reg [31:0] wline;
	wire [47:0] rline;
	
	memory memory(clk, wline, rline, addr, rw);

	initial begin
		$monitor("%t: rw = %b, addr = %x, wline = %x, rline = %x", $time, rw, addr, wline, rline);
		
		clk <= 0;
		#10
		rw <= 2'b11;
		addr <= 0;
		wline <= 48'h123456789ABC;
		#10
		rw <= 2'b00;
		addr <= 0;
		#10
		rw <= 2'b10;
		addr <= 1;
		wline <= 48'hDEF012345678;
		#10
		rw <= 2'b00;
		addr <= 0;
		#10
		rw <= 2'b11;
		addr <= 3;
		wline <= 48'h9ABCDEF12345;
		#10
		rw <= 2'b00;
		addr <= 0;
		#10
		rw <= 2'b00;
		addr <= 2;
		#10 $finish;
	end
	
	always #10 begin
		clk <= ~clk;
	end
endmodule
