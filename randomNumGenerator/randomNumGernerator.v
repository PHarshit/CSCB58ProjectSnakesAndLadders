//*********************************************************************

//module to generate random numbers between 1 and 6 inclusive on a roll key input rollTheDice
module randomNumGernerator(clock,rollTheDice,Clear_rollTheDice,diceNumber);
 
	// Inputs
	input clock,rollTheDice,Clear_rollTheDice;
	// input rollTheDice; // On click generate number
	// input KEY[3]; // Reset
	// Clear_rollTheDice is Clear_b to clear the displayed number

	// Outputs
	output [3:0] diceNumber;
	
	wire [3:0] rnd;
	wire Enable;
	
	RateDivider one(.rate('b00),.clock(clock),.Clear_b(Clear_rollTheDice),.roll(~rollTheDice), .Enable(Enable));
	DisplayCounter one1(.clock(clock),.Clear_b(Clear_rollTheDice),.roll(~rollTheDice),.Enable(Enable),.out(rnd));

	// Instantiate the Unit Under Test (UUT)
	//randomNumberGenerator instOfRandomNumberGenerator (.clock(clock),.reset(~KEY[3]),.rnd(rnd));

	//show the random number on HEX0 i.e result[3:0]
	//HEX_seg HEX_0(.c0(rnd[0]),.c1(rnd[1]),.c2(rnd[2]),.c3(rnd[3]),.seg(HEX0));
    assign diceNumber[3] = rnd[3]; 
    assign diceNumber[2] = rnd[2]; 
    assign diceNumber[1] = rnd[1]; 
    assign diceNumber[0] = rnd[0]; 
endmodule

//*********************************************************************
// module DisplayCounter(clock,Clear_b,ParLoad,Enable,load_val);
module DisplayCounter(clock,Clear_b,roll,Enable,out);
	input clock,Clear_b,roll,Enable;
	output [3:0] out;
	// input [3:0] load_val;
	reg [3:0] q;
	// wire [3:0] d;
	
	always @(posedge clock & roll)
	begin
		if(Clear_b == 1'b0)
			q <= 4'b0000;
		// else if(ParLoad == 1'b1)
			// // q <= d;
			// q <= load_val;
		else if(q == 4'b0111) // if the counter q reaches 7 then change q to 1
			q <= 4'b0001;
		else if(Enable == 1'b1)
			q <= q + 1'b1;
	end
	
	assign out[3:0] = q[3:0];
endmodule // end of DisplayCounter

//*********************************************************************
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
				2'b00: q <= 0_099_999; // speed of 2 Hz
				2'b01: q <= 49_999_999;
				2'b10: q <= 99_999_999;
				2'b11: q <= 199_999_999;
			endcase
		else
			q <= q - 1'b1;
	end
	assign Enable = (q == 0) ? 1 : 0;
endmodule //end of RateDivider

//*********************************************************************
// HEX Module to show the result on HEX0
module HEX_seg(c0, c1, c2, c3, seg); // c0 is lowest bit // c3 is highest bit
    input c0; 
    input c1; 
    input c2; 
    input c3; 
    
	output [6:0] seg; 
	
    assign seg[0] = (~c3 & ~c2 & ~c1 & c0) | (~c3 & c2 & ~c1 & ~c0) | (c3 & c2 & ~c1 & c0) | (c3 & ~c2 & c1 & c0);
	assign seg[1] = (~c3 & c2 & ~c1 & c0) | (c2 & c1 & ~c0) | (c3 & c2 & ~c0) | (c3 & c1 & c0);
	assign seg[2] = (~c3 & ~c2 & c1 & ~c0) | (c3 & c2 & ~c0) | (c3 & c2 & c1);
	assign seg[3] = (~c3 & ~c2 & ~c1 & c0) | (~c3 & c2 & ~c1 & ~c0) | (c2 & c1 & c0) | (c3 & ~c2 & c1 & ~c0);
	assign seg[4] = (~c3 & c0) | (~c3 & c2 & ~c1) | (~c2 & ~c1 & c0);
	assign seg[5] = (~c3 & ~c2 & c0) | (~c3 & ~c2 & c1) | (~c3 & c1 & c0) | (c3 & c2 & ~c1 & c0);
	assign seg[6] = (~c3 & ~c2 & ~c1) | (~c3 & c2 & c1 & c0) | (c3 & c2 & ~c1 & ~c0);

endmodule
