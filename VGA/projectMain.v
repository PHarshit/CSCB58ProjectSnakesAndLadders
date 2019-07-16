// Part 2 skeleton

module projectMain
	(
		CLOCK_50,						//	On Board 50 MHz
		// Your inputs and outputs here
        KEY,
		  HEX0,HEX3,HEX1,HEX4,HEX5,HEX6,HEX7,
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
	
	reg [3:0] i=4'd1;
	output [6:0] HEX0;
	output [6:0] HEX3;
	output [6:0] HEX1;
	output [6:0] HEX4;
	output [6:0] HEX5;
	output [6:0] HEX6;
	output [6:0] HEX7;
	
	wire resetn;
	assign resetn = KEY[2];
	
	// Create the colour, x, y and writeEn wires that are inputs to the controller.
	wire [2:0] colour;
	wire [8:0] x;
	wire [8:0] y;
	wire writeEn;
	
	// this is what I am adding
	//assign colour = SW[17:15];
	wire draw;
	assign draw = ~KEY[1];
	wire ld;
	assign ld = ~KEY[3];
	wire ld_x, ld_y, ld_c;
	
	
	

	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	vga_adapter VGA(
			.resetn(resetn),
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
	reg [6:0] position_P2=7'd0;
	wire [6:0] position_P1_previous;
	wire [6:0] position_P2_previous;
	wire [8:0] coordinate_x_P1;
	wire [8:0] coordinate_y_P1;
	wire [8:0] coordinate_x_P2;
	wire [8:0] coordinate_y_P2;
	
	task updatePosition;
		inout reg[6:0] position;
		begin
			case(position)
				//doing ladders
				//7'd1:position = 7'd38;
				7'd4:position = 7'd14;
				7'd8:position = 7'd30;
				7'd21:position = 7'd42;
				7'd28:position = 7'd76;
				7'd50:position = 7'd67;
				7'd71:position = 7'd92;
				7'd80:position = 7'd99;
				//doing snakes now
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
	reg [3:0] lastDiceNumber;
	reg [3:0] winner;
	reg positionChanged=1'b0;
	
	// this always block resets the P1 and P2 position if reset button SW[0] is 0 
	// KEY 3 press changes turns and also starts the game
//	always@(negedge SW[4])
//	begin
//		positionChanged<=1'b0;
//	end
	always@(posedge SW[4]) //& ~positionChanged)//lastDiceNumber)//SW[3])//negedge KEY[3])
	begin
		if (~SW[0])
		begin
			position_P1=7'd0;
			position_P2=7'd0;
			i=4'd1;
			winner=4'd0;
			
		end
		else if(SW[0])
		begin
			if(i==4'd1)
			begin
				position_P1 = position_P1 + diceNumber;
				if(position_P1>7'd100)
				begin
					position_P1=position_P1 - diceNumber;
				end
				updatePosition(position_P1);
				if(diceNumber != 3'b000)
				begin
					i = 4'd2;
				end
				if(position_P1==7'd100) //means player 1 won
				begin
				  winner <= 4'd1;
				end
				positionChanged <= 1'b1;
			end
			else if(i==4'd2)
			begin
				position_P2 = position_P2 + diceNumber;
				if(position_P2>7'd100)
				begin
					position_P2=position_P2 - diceNumber;
				end
				updatePosition(position_P2);
				if(diceNumber != 3'b000)
				begin
					i = 4'd1;
				end
				if(position_P2==7'd100) //means player 2 won
				begin
				  winner <= 4'd2;
				end
				positionChanged <= 1'b1;
			end
			
		end
	end
	
		// look up coordinates in the lut on clock
	lut_coordinates lookUpP1(.clock(CLOCK_50),.number(position_P1),.out_x(coordinate_x_P1),.out_y(coordinate_y_P1));
	lut_coordinates lookUpP2(.clock(CLOCK_50),.number(position_P2),.out_x(coordinate_x_P2),.out_y(coordinate_y_P2));
	
	
	// calling random num generator module
	
	//once the KEY[0] is pressed roll the dice and then store the value in diceNumber
	// I think in randomNumGernerator module in displayCounter module it should be always @(posedge clock & posedge roll)
	randomNumGernerator rng(.clock(CLOCK_50),.rollTheDice(KEY[0]),.Clear_rollTheDice(~SW[8]),.diceNumber(diceNumber),.lastDiceNumber(lastDiceNumber));
	
	HEX_seg HEX_0(.c0(diceNumber[0]),.c1(diceNumber[1]),.c2(diceNumber[2]),.c3(diceNumber[3]),.seg(HEX0));
	HEX_seg HEX_4(.c0(position_P1[0]),.c1(position_P1[1]),.c2(position_P1[2]),.c3(position_P1[3]),.seg(HEX4));
	HEX_seg HEX_5(.c0(position_P1[4]),.c1(position_P1[5]),.c2(position_P1[6]),.c3(1'b0),.seg(HEX5));
	
	HEX_seg HEX_6(.c0(position_P2[0]),.c1(position_P2[1]),.c2(position_P2[2]),.c3(position_P2[3]),.seg(HEX6));
	HEX_seg HEX_7(.c0(position_P2[4]),.c1(position_P2[5]),.c2(position_P2[6]),.c3(1'b0),.seg(HEX7));
	
//	always@(diceNumber)
//	begin
//		if(SW[0])
//		begin
//			if(i==1)
//			begin
//				position_P1 = position_P1 + {4'd0, 3'bdiceNumber};
//			end
//		end
//	end
	
	// always @(*) begin
		// repeat (16) begin
			// i <= i + 1;
		// end
	// end
	// Instansiate datapath
	// datapath d0(...);
//	datapath D0(
//        .clk(CLOCK_50),
//        .resetn(resetn),
//		.ld_x(ld_x),
//        .ld_y(ld_y),
//		.ld_c(ld_c),
//		.x(x),
//		.y(y),
//		.data_in(SW[8:0]),
//		.colour(colour),
//		.color_in(SW[17:15])
//    );
	
	
	
	
	datapath datapathP1(
        .clk(CLOCK_50),
        .resetn(resetn),
		.x(x),
		.y(y),
		.data_in_x({coordinate_x_P2,coordinate_x_P1}),
		.data_in_y({coordinate_y_P2+9'd15,coordinate_y_P1}),
		.colour(colour),
		.color_in(3'b001)
    );
	
	// datapath datapathP2(
        // .clk(CLOCK_50),
        // .resetn(resetn),
		// .x(x),
		// .y(y),
		// .data_in_x(coordinate_x_P2),
		// .data_in_y(coordinate_y_P2+9'd15),
		// .colour(colour),
		// .color_in(3'b011)
    // );

	// // Instansiate FSM control
    // // control c0(...);
	// control C0(
        // .clk(CLOCK_50),
        // .resetn(resetn),
		// .ld_x(ld_x),
        // .ld_y(ld_y),
		// .draw(draw),
		// .ld(ld),
		// .writeEn(writeEn),
		// .ld_c(ld_c)
    // );
	
	
	//HEX3 shows whose turn is it
	HEX_seg HEX_3(.c0(i[0]),.c1(i[1]),.c2(i[2]),.c3(i[3]),.seg(HEX3));
	
	// HEX5 shows the winner
	HEX_seg HEX_1(.c0(winner[0]),.c1(winner[1]),.c2(winner[2]),.c3(winner[3]),.seg(HEX1));
	
    
endmodule


module DisplayPlayerOne();
endmodule

module datapath(
    input clk,
    input resetn,
    input [17:0] data_in_x,
    input [17:0] data_in_y,
    input [2:0] color_in,
    output [2:0] colour,
	output [8:0] x,
	output [8:0] y
    );
    
	wire y_enable,isP2;
	reg [8:0] x_previous;
	reg [8:0] y_previous;
	reg [2:0] color;
    reg [8:0] x_counter, y_counter;
    // Registers x, y, color
    always@(posedge clk) begin
        if(!resetn) begin
            x_previous <= 8'b0;
			y_previous <= 8'b0;
			color <= 3'b0; // black color
        end
        else begin
			if(~isP2) begin
				x_previous <= data_in_x[8:0];
				y_previous <= data_in_y[8:0];
				color <= color_in;
			end
			else
			begin
				x_previous <= data_in_x[17:9];
				y_previous <= data_in_y[17:9];
				color <= color_in;
			end
        end
    end
	
	// counter to draw 3x3 pixel
    always @(posedge clk) begin
		if (!resetn)
			x_counter <= 2'b00;
		else begin
			if (x_counter == 2'b10)
				x_counter <= 2'b00;
			else
				x_counter <= x_counter + 1'b1;
		end
	end
	
	assign y_enable = (x_counter == 2'b10) ? 1 : 0;
	
    always @(posedge clk) begin
		if (!resetn)
			y_counter <= 2'b00;
		else if (y_enable) begin
			if (y_counter != 2'b10)
				y_counter <= y_counter + 1'b1;
			else 
				y_counter <= 2'b00;
		end
	end
	assign isP2 = (y_counter == 2'b10) ? ~isP2 : isP2;
	assign x = x_previous + x_counter;
	assign y = y_previous + y_counter;
	assign colour = color;
	
    
endmodule


// module datapath(
    // input clk,
    // input resetn,
    // input [8:0] data_in,
    // input ld_x, ld_y, ld_c,
	// input [2:0] color_in,
    // output [2:0] colour,
	// output [8:0] x,
	// output [8:0] y
    // );
    
	// wire y_enable;
	// reg [8:0] x_previous;
	// reg [8:0] y_previous;
	// reg [2:0] color;
    // reg [8:0] x_counter, y_counter;
    // // Registers x, y, color
    // always@(posedge clk) begin
        // if(!resetn) begin
            // x_previous <= 8'b0;
			// y_previous <= 8'b0;
			// color <= 3'b0; // black color
        // end
        // else begin
            // if(ld_x)
                // x_previous <= data_in;
            // if(ld_y)
                // y_previous <= data_in;
            // if(ld_c)
                // color <= color_in;
        // end
    // end
	
	// // counter to draw 3x3 pixel
    // always @(posedge clk) begin
		// if (!resetn)
			// x_counter <= 2'b00;
		// else begin
			// if (x_counter == 2'b10)
				// x_counter <= 2'b00;
			// else
				// x_counter <= x_counter + 1'b1;
		// end
	// end
	
	// assign y_enable = (x_counter == 2'b10) ? 1 : 0;

    // always @(posedge clk) begin
		// if (!resetn)
			// y_counter <= 2'b00;
		// else if (y_enable) begin
			// if (y_counter != 2'b10)
				// y_counter <= y_counter + 1'b1;
			// else 
				// y_counter <= 2'b00;
		// end
	// end
	
	// assign x = x_previous + x_counter;
	// assign y = y_previous + y_counter;
	// assign colour = color;
	
    
// endmodule

// module control(
    // input clk,
    // input resetn,
	 // output reg writeEn,
	// input ld,
    // input draw,
	// output reg  ld_x, ld_y, ld_c
    // );

    // reg [2:0] current_state, next_state; 
    
    // localparam  S_LOAD_x        = 3'd0,
                // S_LOAD_x_wait   = 3'd1,
                // S_LOAD_y        = 3'd2,
                // S_LOAD_y_wait   = 3'd3,
                // Drawing			= 3'd4;
    
    // // Next state logic aka our state table
    // always@(*)
    // begin: state_table 
            // case (current_state)
                // S_LOAD_x: next_state = ld ? S_LOAD_x_wait : S_LOAD_x;
				// S_LOAD_x_wait: next_state = ld ? S_LOAD_x_wait : S_LOAD_y;
				// S_LOAD_y: next_state = draw ? S_LOAD_y_wait : S_LOAD_y;
				// S_LOAD_y_wait: next_state = draw ? S_LOAD_y_wait : Drawing;
				// Drawing: next_state = ld ? S_LOAD_x : Drawing;
        // endcase
    // end // state_table
   

    // // Output logic aka all of our datapath control signals
    // always @(*)
    // begin: enable_signals
        // ld_x = 1'b0;
        // ld_y = 1'b0;
		// ld_c = 1'b0;
		// writeEn = 1'b0;
		
        // case (current_state)
            // S_LOAD_x: begin
                // ld_x=1'b1;
				// end
            // S_LOAD_x_wait: begin
                // ld_x=1'b1;
				// end
            // S_LOAD_y: begin
                // ld_y=1'b1;
				// ld_c = 1'b1;
                // end
            // S_LOAD_y_wait: begin
                // ld_y=1'b1;
				// ld_c = 1'b1;
                // end
            // Drawing: begin
				// writeEn = 1'b1;
			// end
		// endcase
    // end // enable_signals
   
    // // current_state registers
    // always@(posedge clk)
    // begin: state_FFs
        // if(!resetn) begin
            // current_state <= S_LOAD_x;
				
		// end
        // else
            // current_state <= next_state;
    // end // state_FFS
// endmodule


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
