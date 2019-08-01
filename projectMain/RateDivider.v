//*******************************//
// Rate Divider module
module RateDivider(rate, clock, Clear_b, roll, Enable);
	input clock, Clear_b, roll;
	input [1:0] rate;
	output Enable;
	reg [27:0] q;
	//wire [3:0] d;
	always @(posedge clock & roll)
	begin
		if (Clear_b == 1'b0)
			q <= 0; 
		else if(q == 0)
			case (rate[1:0])
				//2'b00: q <= 0; // original module had zero for full 50Hz speed
				2'b00: q <= 01_999_999; // for rolling the dice
				2'b01: q <= 00_299_999; // for drwaing the pieces
				2'b10: q <= 99_999_999;
				2'b11: q <= 199_999_999;
			endcase
		else
			q <= q - 1'b1;
	end
	assign Enable = (q == 0) ? 1 : 0;
endmodule 
//end of RateDivider