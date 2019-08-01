// This is the Main File for the Snakes and Ladders Game //
// Game Rules: 	Two Player Game
//				P1 is on top, P2 is on bottom
//				P1 gets to roll the dice first
//				If any player rolls a 6 then they get another chance
//				In order to win the game a player has to reach exactly 100 and not over it.
//					Eg: If a player is at 97 then they need to roll a 3 to win. If the player rolls 
//						4 or 5 or 6 then the player remains at same position and
//						other player gets a chance if 6 was not rolled.

// Input: 		SW[0] starts the game
//		   		~KEY[0] roll the Dice  // unpressed Key has a value of 1
//				~SW[0] && ~KEY[0] resets the game

// Output:		HEX7 and HEX6  displays the position of Player 1 in decimal
//				HEX5 and HEX4  displays the position of Player 2 in decimal
//				HEX3 displays whose turn is it to roll the dice
//				HEX1 displays the winner 
//				HEX0 displays the dice rolling
//				LEDG[8] displays if a last dice roll took the player up the ladder_light
//				LEDR[11] displays is a last dice roll took the player down the snake
//				Once there is winner all the red LEDs start blinking in a pattern chosen in the led_blinking module


module projectMain
	(
		CLOCK_50,						//	On Board 50 MHz
		KEY,	
		HEX0,HEX3,HEX1,HEX4,HEX5,HEX6,HEX7,LEDR,LEDG,
        SW,
		// The ports below are for the VGA output.  Do not change.
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,						//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B   						//	VGA Blue[9:0]
	);

	input CLOCK_50;				//	50 MHz
	input [17:0] SW;
	input [3:0] KEY;
	output [17:0] LEDR;
	output [8:0] LEDG;
	
	// reg snake_light gets a value of 1 when player lands on a snake otherwise 0
	// reg ladder_light gets a value of 1 when player lands on a ladder otherwise 0
	reg snake_light, ladder_light;
	
	// Declare your inputs and outputs here
	// Do not change the following outputs
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;				//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;   				//	VGA Blue[9:0]
	
	reg [3:0] i=4'd1;	// register to store which players chance is it. 
						//Initial value of i is 1 means player 1 chance at start of game
	output [6:0] HEX0,HEX3,HEX1,HEX4,HEX5,HEX6,HEX7;
	
	
	// Create the colour, x, y and writeEn wires that are inputs to the controller.
	wire [2:0] colour;
	wire [8:0] x;
	wire [8:0] y;
	wire writeEn;
	
	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	vga_adapter VGA(
			.resetn(1),
			.clock(CLOCK_50),
			.colour(colour),
			.x(x),
			.y(y),
			.plot(writeEn),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
			
			
			
		defparam VGA.RESOLUTION = "320x240";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "board.mif";
			

	
	reg [6:0] position_P1=7'd0;
	reg [6:0] pre_position_P1=7'd0;
	reg [6:0] position_P2=7'd0;
	reg [6:0] pre_position_P2=7'd0;
	wire [8:0] coordinate_x_P1;
	wire [8:0] pre_coordinate_x_P1;
	wire [8:0] coordinate_y_P1;
	wire [8:0] pre_coordinate_y_P1;
	wire [8:0] coordinate_x_P2;
	wire [8:0] pre_coordinate_x_P2;
	wire [8:0] coordinate_y_P2;
	wire [8:0] pre_coordinate_y_P2;
	
	
	// 	this task checks and the changes the position of piece if player landed on
	//	a snake or a ladder
	task updatePosition;
		inout reg[6:0] position;
		begin
			case(position)
				//	ladders
				7'd4:position = 7'd14;
				7'd8:position = 7'd30;
				7'd21:position = 7'd42;
				7'd28:position = 7'd76;
				7'd50:position = 7'd67;
				7'd71:position = 7'd92;
				7'd80:position = 7'd99;
				//	snakes
				7'd36:position = 7'd6;
				7'd32:position = 7'd10;
				7'd62:position = 7'd18;
				7'd48:position = 7'd26;
				7'd88:position = 7'd24;
				7'd95:position = 7'd56;
				7'd97:position = 7'd78;
			endcase
		end
	endtask
	
	reg [3:0] diceNumber;	
	reg [3:0] winner;		// this register stores which player won a game
	

	
	//	This always block is triggerd once the dice is finished rolling
	//	This always block updates the position of the player by adding the dice Number
	always@(posedge KEY[0])
	begin
		
		if (~SW[0])	//	If reset
		begin
			pre_position_P1 = position_P1;	// Store previous position of player1
			pre_position_P2 = position_P2;	// Store previous position of player2
			position_P1=7'd0;				// Change position of player 1 to start
			position_P2=7'd0;				// Change position of player 2 to start
			i=4'd1;							// Change the turn to roll dice to player 1
			winner=4'd0;					// Change winner value to 0
			ladder_light = 0;				
			snake_light = 0;
			
		end		//	end of reset if statement
		
		else if(SW[0] && winner == 4'd0) 	//	if game is on and there is no winner
		begin
			if(i==4'd1)						// If player 1 chance to roll the dice
			begin
				pre_position_P1 = position_P1;			
				position_P1 = position_P1 + diceNumber;
				if(position_P1>7'd100)		// if the position of player1 goes above 100 then dont change player1 position
				begin
					position_P1=position_P1 - diceNumber;
				end
				updatePosition(position_P1);	//	Check if the player1 landed on a snake or ladder
				if((position_P1 > pre_position_P1 + diceNumber) )	// Check if player1 landed on a ladder
				begin
					ladder_light = 1;								// Turn on ladder light
					snake_light = 0;
				end
				else if((position_P1 < pre_position_P1))	// Check if player1 landed on a snake
				begin
					ladder_light = 0;
					snake_light = 1;						// Turn on snake light
				end
				else
				begin
					ladder_light = 0;
					snake_light = 0;
			end
				if(diceNumber != 3'd6) 			// if dice number is not 6
				begin
					i = 4'd2;					// change turn to player2
				end
				if(position_P1==7'd100) //means player 1 won
				begin
				  winner <= 4'd1;		// change winner value to player1
				  i = 4'd1;             // don't change turn if there is a winner
				end
				
			end
			else if(i==4'd2)				// If player 2 chance to roll the dice
			begin
				pre_position_P2 = position_P2;
				position_P2 = position_P2 + diceNumber;
				if(position_P2>7'd100)			// if the position of player2 goes above 100 then dont change player1 position
				begin
					position_P2=position_P2 - diceNumber;
				end
				updatePosition(position_P2);	//	Check if the player2 landed on a snake or ladder
				if((position_P2 > pre_position_P2 + diceNumber))	// Check if player2 landed on a ladder
				begin                                               
					ladder_light = 1;                               // Turn on ladder light
					snake_light = 0;
				end
				else if((position_P2 < pre_position_P2))	// Check if player2 landed on a snake
				begin                                       
					ladder_light = 0;                       
					snake_light = 1;                        // Turn on snake light
				end
				else
				begin
					ladder_light = 0;
					snake_light = 0;
			end
				if(diceNumber != 3'd6)		// if dice number is not 6
				begin                       
					i = 4'd1;               // change turn to player1
				end
				if(position_P2==7'd100) //means player 2 won
				begin
				  winner <= 4'd2;		// change winner value to player2
				  i = 4'd2;				// don't change turn if there is a winner
				end
				
			end
			
			
		end
	end
	
	// look up coordinates in the lut on CLOCK_50 for Player 1
	lut_coordinates lookUpP1(.clock(CLOCK_50),.number(position_P1),.out_x(coordinate_x_P1),.out_y(coordinate_y_P1));
	// look up coordinates in the lut on CLOCK_50 for Player 2
	lut_coordinates lookUpP2(.clock(CLOCK_50),.number(position_P2),.out_x(coordinate_x_P2),.out_y(coordinate_y_P2));
	
	// look up coordinatesin the lut on CLOCK_50 for Player 1 previous position
	lut_coordinates pre_lookUpP1(.clock(CLOCK_50),.number(pre_position_P1),.out_x(pre_coordinate_x_P1),.out_y(pre_coordinate_y_P1));
	// look up coordinatesin the lut on CLOCK_50 for Player 1 previous position
	lut_coordinates pre_lookUpP2(.clock(CLOCK_50),.number(pre_position_P2),.out_x(pre_coordinate_x_P2),.out_y(pre_coordinate_y_P2));
	
	// variable to store 1 if previous position of player1 was odd. 
	wire isOddP1 = pre_position_P1[0]; // used to determine whether to draw white color or red color on previous position of player1
	wire isOddP2 = pre_position_P2[0];
	
	
	// calling random num generator module
	
	//once the KEY[0] is pressed roll the dice and then store the value in diceNumber
	randomNumGernerator rng(.clock(CLOCK_50),.rollTheDice(KEY[0]),.Clear_rollTheDice(~SW[8]),.diceNumber(diceNumber),.winner(winner));
	
	//	reg below are to store the decimals of player position
	reg [3:0] position_P1_BCD_Tens;
	reg [3:0] position_P2_BCD_Tens;
	reg [3:0] position_P1_BCD_Ones;
	reg [3:0] position_P2_BCD_Ones;
	
	//	converting position of player 1 in decimals from binary
	BCD BCD_P1(.binary(position_P1),.Tens(position_P1_BCD_Tens),.Ones(position_P1_BCD_Ones));
	//	converting position of player 2 in decimals from binary
	BCD BCD_P2(.binary(position_P2),.Tens(position_P2_BCD_Tens),.Ones(position_P2_BCD_Ones));
	
	//	display dice number in HEX0
	HEX_seg HEX_0(.c0(diceNumber[0]),.c1(diceNumber[1]),.c2(diceNumber[2]),.c3(diceNumber[3]),.seg(HEX0));
	
	//	display Player 1 position in HEX7 and HEX6 in decimals
	HEX_seg HEX_6(.c0(position_P1_BCD_Ones[0]),.c1(position_P1_BCD_Ones[1]),.c2(position_P1_BCD_Ones[2]),.c3(position_P1_BCD_Ones[3]),.seg(HEX6));
	HEX_seg HEX_7(.c0(position_P1_BCD_Tens[0]),.c1(position_P1_BCD_Tens[1]),.c2(position_P1_BCD_Tens[2]),.c3(position_P1_BCD_Tens[3]),.seg(HEX7));
	
	//	display Player 2 position in HEX7 and HEX6 in decimals
	HEX_seg HEX_4(.c0(position_P2_BCD_Ones[0]),.c1(position_P2_BCD_Ones[1]),.c2(position_P2_BCD_Ones[2]),.c3(position_P2_BCD_Ones[3]),.seg(HEX4));
	HEX_seg HEX_5(.c0(position_P2_BCD_Tens[0]),.c1(position_P2_BCD_Tens[1]),.c2(position_P2_BCD_Tens[2]),.c3(position_P2_BCD_Tens[3]),.seg(HEX5));
	

	//	EnableDrawClock is the clock for datapath to slow down the drawing of pixels
	wire EnableDrawClock;
	//	Calling RateDivider module to change the speed of drawing clock
	RateDivider one(.rate('b01),.clock(CLOCK_50),.Clear_b(1'b1),.roll(1'b1), .Enable(EnableDrawClock));
	
	//	Callling datapath module to decide what pixel to draw on the screen
	datapath datapathP1(
        .clk(EnableDrawClock),
        .x(x),		// output used by VGA module to draw x coordinate
		.y(y),		// output used by VGA module to draw y coordinate
		.writeEn(writeEn),		// output used by VGA module to enable drawing on screen
		.data_in_x({coordinate_x_P2,coordinate_x_P1}),		// most significant bits for P2 // least significant bit for P1 x coordinate
		.pre_data_in_x({pre_coordinate_x_P2,pre_coordinate_x_P1}),
		.data_in_y({coordinate_y_P2+9'd15,coordinate_y_P1}),	// adding 15 to y coordinate of P2 because P2 is 15 pixels below P1
		.pre_data_in_y({pre_coordinate_y_P2+9'd15,pre_coordinate_y_P1}),	
		.isOddP1(isOddP1),.isOddP2(isOddP2),
		.colour(colour),
		.color_in(3'b011)	// this value not used in the module // kept it for future 
    );
	
	//	calling the led_blinking module to blink red led lights in a pattern
	led_blinking ShowingWinner(CLOCK_50,winner,LEDR[0],LEDR[1],LEDR[2],LEDR[3],LEDR[4],
		LEDR[5],LEDR[6],LEDR[7],LEDR[8],LEDR[9],LEDR[10],LEDR[12],LEDR[13],
		LEDR[14],LEDR[15],LEDR[16],LEDR[17],);

	
	assign LEDG[8] = ladder_light;	// green light for ladder
	assign LEDR[11] = snake_light;	// red light for a snake
	
	//HEX3 shows whose turn is it
	HEX_seg HEX_3(.c0(i[0]),.c1(i[1]),.c2(i[2]),.c3(i[3]),.seg(HEX3));
	
	// HEX5 shows the winner
	HEX_seg HEX_1(.c0(winner[0]),.c1(winner[1]),.c2(winner[2]),.c3(winner[3]),.seg(HEX1));
	
endmodule	// end of projectMain module

// ****************************************************** //

// start of datapath module 
// This module decide what pixel to draw on screen
// whether to draw P1, previous position of P1, P2 or previous position of P2
module datapath(
    input clk,
    input [17:0] data_in_x,			// 9 highest significant bits have x coordinate of P2 // 9 lowest significant bits have P1 x-coordinate
    input [17:0] pre_data_in_x,
    input [17:0] data_in_y,
    input [17:0] pre_data_in_y,
    input [2:0] color_in,
	input isOddP1, input isOddP2,
	
	output reg [2:0] colour,
	output reg writeEn,
	output reg [8:0] x,
	output reg [8:0] y
    );
    
	reg y_enable;	// once 3 pixels are drawn in a row, the value of y_enable goes 1 to inform y_counter to increase by 1 // to draw another row
	reg isP2;		// if it has 1 means its player2 chance otherwise player1 chance
	reg [8:0] x_pos;
	reg [8:0] pre_x_pos;
	reg [8:0] x_posP2;
	reg [8:0] pre_x_posP2;
	reg [8:0] y_pos;
	reg [8:0] pre_y_pos;
	reg [8:0] y_posP2;
	reg [8:0] pre_y_posP2;
	reg [2:0] x_counter = 2'b00, y_counter  = 2'b00;		// counter to draw 3x3 box
	reg [2:0] countingForChangingCurrentTOPre = 3'b000;		// counter to decide wheter to draw previous position or current position of players
    
	always@(posedge clk) begin
		writeEn = 1;
		
		// If condition true then draw current position of players
		if(countingForChangingCurrentTOPre == 2'b10 || countingForChangingCurrentTOPre == 2'b11)begin
			
			// storing input values of the module of appropriate registers
			x_pos <= data_in_x[8:0];
			pre_x_pos <= pre_data_in_x[8:0];
			y_pos <= data_in_y[8:0];
			pre_y_pos <= pre_data_in_y[8:0];
			x_posP2 <= data_in_x[17:9];
			pre_x_posP2 <= pre_data_in_x[17:9];
			y_posP2 <= data_in_y[17:9];
			pre_y_posP2 <= pre_data_in_y[17:9];
			
			// counter to draw 3x3 pixel
			if (x_counter == 2'b11)
				x_counter <= 2'b00;
			else
				x_counter <= x_counter + 1'b1;
			
			y_enable = (x_counter == 2'b11) ? 1 : 0;	// change value of y_enable to 1 if one row of pixels are drawn
			
			if (y_enable) begin
				if (y_counter == 2'b11)
					y_counter <= 2'b00;
				else 
					y_counter <= y_counter + 1'b1;
			end
			
			x = (isP2==0) ? (x_pos + x_counter) : (x_posP2 + x_counter);	// decide wheter to draw current position of player1 or player2
			y = (isP2==0) ? (y_pos + y_counter) : (y_posP2 + y_counter);
			
			colour = (isP2==0) ? (3'b001) : (3'b011);		// decide which color to use depending on which player's turn it is
			
			isP2 = (x_counter == 2'b11 && y_counter == 2'b11) ? ~isP2 : isP2;	// if player1's piece is drawn then draw player2's piece
			
			if(x_counter == 2'b11 && y_counter == 2'b11) begin	
				countingForChangingCurrentTOPre = countingForChangingCurrentTOPre + 1'b1;
				if(countingForChangingCurrentTOPre == 3'b100)	// if both player's current pieces are drawn then go to remove their previous positions
					countingForChangingCurrentTOPre = 2'b00;
			end
		end
		
		// If condition true then draw over previous position of players
		else if(countingForChangingCurrentTOPre == 2'b00 || countingForChangingCurrentTOPre == 2'b01)begin
			
			// storing input values of the module of appropriate registers
			x_pos <= data_in_x[8:0];
			pre_x_pos <= pre_data_in_x[8:0];
			y_pos <= data_in_y[8:0];
			pre_y_pos <= pre_data_in_y[8:0];
			x_posP2 <= data_in_x[17:9];
			pre_x_posP2 <= pre_data_in_x[17:9];
			y_posP2 <= data_in_y[17:9];
			pre_y_posP2 <= pre_data_in_y[17:9];
			
			// counter to draw 3x3 pixel
			if (x_counter == 2'b11)
				x_counter <= 2'b00;
			else
				x_counter <= x_counter + 1'b1;
			
			y_enable = (x_counter == 2'b11) ? 1 : 0;
			
			if (y_enable) begin		// change value of y_enable to 1 if one row of pixels are drawn
				if (y_counter == 2'b11)
					y_counter <= 2'b00;
				else 
					y_counter <= y_counter + 1'b1;
			end
			
			x = (isP2==0) ? (pre_x_pos + x_counter) : (pre_x_posP2 + x_counter);	// decide wheter to draw over previous position of player1 or player2
			y = (isP2==0) ? (pre_y_pos + y_counter) : (pre_y_posP2 + y_counter);
			
			// decide which color to use depending on which player's turn it is was and whether player was on red box or white box
			colour = (isP2==0) ? (isOddP1 ? 3'b100 : 3'b111) : (isOddP2 ? 3'b100 : 3'b111);
			
			// if player1's piece is drawn then draw player2's piece
			isP2 = (x_counter == 2'b11 && y_counter == 2'b11) ? ~isP2 : isP2;
			
			if(x_counter == 2'b11 && y_counter == 2'b11) begin
				countingForChangingCurrentTOPre = countingForChangingCurrentTOPre + 1'b1;
				if(countingForChangingCurrentTOPre == 3'b100)	// if both player's previous positons have been covered then then go to draw their current positions
					countingForChangingCurrentTOPre = 2'b00;
			end
		end
	end
	
endmodule
// end of datapath module