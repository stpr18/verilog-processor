module clock(output clk, output [3:0] state);
	reg clk = 0;
	reg state = `STATE_INIT;
	
	always #10 begin
		clk <= ~clk;
	end
	
	always @(clk) begin
		case (state)
			`STATE_FETCH : state <= `STATE_DECODE;
			`STATE_DECODE : state<= `STATE_EXECUTE;
			`STATE_EXECUTE : state <= `STATE_WRITE;
			`STATE_WRITE : state <= `STATE_FETCH; // `STATE_TEST for test // not work
			
			default : state <= `STATE_FETCH;
		endcase
	end
endmodule