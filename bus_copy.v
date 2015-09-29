module bus_copy(input [15:0] i, output [15:0] o, input en);
	assign o = (en) ? i : 16'bz;
endmodule