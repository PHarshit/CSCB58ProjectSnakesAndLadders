//*********************************************************************

//module to generate random numbers between 1 and 6 inclusive on a roll key input rollTheDice
module randomNumGernerator(clock,rollTheDice,Clear_rollTheDice,diceNumber, winner);
 
	// Inputs
	input clock,rollTheDice,Clear_rollTheDice;
	input [3:0] winner;
	// input rollTheDice; // On click generate number
	// input KEY[3]; // Reset
	// Clear_rollTheDice is Clear_b to clear the displayed number

	// Outputs
	output [3:0] diceNumber;
	
	wire [3:0] rnd;
	wire Enable;
	
	RateDivider one(.rate('b00),.clock(clock),.Clear_b(Clear_rollTheDice),.roll(~rollTheDice), .Enable(Enable));
	DisplayCounter one1(.clock(clock),.Clear_b(Clear_rollTheDice),.roll(~rollTheDice),.Enable(Enable),.out(rnd),.winner(winner));

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
module DisplayCounter(clock,Clear_b,roll,Enable,out, winner);
	input clock,Clear_b,roll,Enable;
	input [3:0] winner;
	output [3:0] out;
	// input [3:0] load_val;
	reg [3:0] q;
	// wire [3:0] d;
	always @(posedge clock && roll)
	
	begin
		if(Clear_b == 1'b0 || winner != 3'd0)
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




