module loop_check(input [15:0] addr, pc_i, output [15:0] pc_o, input [1:0] type, input zf, input [15:0] counter_i, output [15:0] counter_o, input en);
	reg con;
	
	always @(posedge en) begin
		case (type)
			`LOOP_NORMAL : con <= (counter_i != 16'd1);
			`LOOP_E : con <= (counter_i != 16'd1 && zf == 1'b1);
			`LOOP_NE : con <= (counter_i != 16'd1 && zf == 1'b0);
			default : begin
				$display("unknown type:%b", type);
				$finish();
			end
		endcase
	end
	
	assign pc_o = (en) ? ((con) ? addr : pc_i) : 16'bz;
	assign counter_o = (en) ? counter_i - 16'd1 : 16'bz;
endmodule