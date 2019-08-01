//  *******************
//  ** projectMain.v ** is the main file for the Snakes and Ladders Game //
//  *******************

//  In Quartus open the projectMain.qpf file to open the project. 

// supporting file are:
//	board.mif (background picture for the game)
//	BCD.v
//	randomNumGenerator.v
//	lut_coordinates.v
//	RateDivider.v
//	led_blinking.v
//	Hex_seg.v
	
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
