// ******************************************************//
// This module is display dancing(blinking) LEDR
// start of led_blinking module //

module led_blinking(
    input clock,
    input [3:0] winner,
	
    output led0, led1,led2, led3, led4, led5, led6, led7,
	output led8, led9,led10,led12,led13,led14,led15,led16,led17
    );
 
	reg [26:0] x;  // counter register 
	 
	always@ (posedge clock)
	 begin
	  if (winner == 4'd0)
	   x <= 0;  
	  else
	   x <= x + 1;  
	  end
	   
	assign led0 = x[26];   
	assign led1 = x[25];   
	assign led2 = x[24];
	assign led3 = x[23];
	assign led4 = x[26];
	assign led5 = x[25];
	assign led6 = x[24];
	assign led7 = x[23];
	assign led8 = x[26];
	assign led9 = x[25];
	assign led10 =x[24];
	//assign led11 =x[23];
	assign led12 = x[26];
	assign led13 = x[25];
	assign led14 = x[24];
	assign led15 = x[23];
	assign led16 = x[26];
	assign led17 = x[25];
endmodule
// end of led_blinking module //