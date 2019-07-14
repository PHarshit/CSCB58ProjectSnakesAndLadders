// Part 2 skeleton

module projectMain
	(
		CLOCK_50,						//	On Board 50 MHz
		// Your inputs and outputs here
        KEY,
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

	input			CLOCK_50;				//	50 MHz
	input   [9:0]   SW;
	input   [3:0]   KEY;

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
	
	wire resetn;
	assign resetn = KEY[0];
	
	// Create the colour, x, y and writeEn wires that are inputs to the controller.
	wire [2:0] colour;
	wire [7:0] x;
	wire [6:0] y;
	wire writeEn;
	reg i;
	
	// this is what I am adding
	//assign colour = SW[9:7];
	wire draw;
	assign draw = ~KEY[1];
	wire ld;
	assign ld = ~KEY[3];
	wire ld_x, ld_y, ld_c;
	
	reg [9:0] h_count;      // line position
   reg [9:0] v_count;      // screen position
	
	

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
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "image.colour.mif";
			
	// Put your code here. Your code should produce signals x,y,colour and writeEn/plot
	// for the VGA controller, in addition to any other functionality your design may require.
//    always @(*)
//	begin
//		if(!resetn) begin
//			for(VCount=0;VCount<=480;VCount++) begin
//			  for(HCount=0;HCount<=640;HCount++) begin
//				x = 7'dHCount;
//				y = 6'dVCount;
//				colour = 3'b0;
//				end
//			end
//		end
//	end

   always @(*) begin
		repeat (16) begin
			i <= i + 1;
		end
	end
	// Instansiate datapath
	// datapath d0(...);
	datapath D0(
        .clk(CLOCK_50),
        .resetn(resetn),
		.ld_x(ld_x),
        .ld_y(ld_y),
		.ld_c(ld_c),
		.x(x),
		.y(y),
		.data_in(SW[6:0]),
		.colour(colour),
		.color_in(SW[9:7])
    );
	
	// Instansiate FSM control
    // control c0(...);
	control C0(
        .clk(CLOCK_50),
        .resetn(resetn),
		.ld_x(ld_x),
        .ld_y(ld_y),
		.draw(draw),
		.ld(ld),
		.writeEn(writeEn),
		.ld_c(ld_c)
    );
    
endmodule

module datapath(
    input clk,
    input resetn,
    input [6:0] data_in,
    input ld_x, ld_y, ld_c,
	input [2:0] color_in,
    output [2:0] colour,
	output [7:0] x,
	output [6:0] y
    );
    
	wire y_enable;
	reg [7:0] x_previous;
	reg [6:0] y_previous;
	reg [2:0] color;
    reg [7:0] x_counter, y_counter;
    // Registers x, y, color
    always@(posedge clk) begin
        if(!resetn) begin
            x_previous <= 8'b0;
			y_previous <= 7'b0;
			color <= 3'b0; // black color
        end
        else begin
            if(ld_x)
                x_previous <= {1'b0, data_in};
            if(ld_y)
                y_previous <= data_in;
            if(ld_c)
                color <= color_in;
        end
    end
	
 
    always @(posedge clk) begin
		if (!resetn)
			x_counter <= 2'b00;
		else begin
			if (x_counter == 2'b11)
				x_counter <= 2'b00;
			else
				x_counter <= x_counter + 1'b1;
		end
	end
	
	assign y_enable = (x_counter == 2'b11) ? 1 : 0;

    always @(posedge clk) begin
		if (!resetn)
			y_counter <= 2'b00;
		else if (y_enable) begin
			if (y_counter != 2'b11)
				y_counter <= y_counter + 1'b1;
			else 
				y_counter <= 2'b00;
		end
	end
	
	assign x = x_previous + x_counter;
	assign y = y_previous + y_counter;
	assign colour = color;
    
endmodule

module control(
    input clk,
    input resetn,
	 output reg writeEn,
	input ld,
    input draw,
	output reg  ld_x, ld_y, ld_c
    );

    reg [2:0] current_state, next_state; 
    
    localparam  S_LOAD_x        = 3'd0,
                S_LOAD_x_wait   = 3'd1,
                S_LOAD_y        = 3'd2,
                S_LOAD_y_wait   = 3'd3,
                Drawing			= 3'd4;
    
    // Next state logic aka our state table
    always@(*)
    begin: state_table 
            case (current_state)
                S_LOAD_x: next_state = ld ? S_LOAD_x_wait : S_LOAD_x;
				S_LOAD_x_wait: next_state = ld ? S_LOAD_x_wait : S_LOAD_y;
				S_LOAD_y: next_state = draw ? S_LOAD_y_wait : S_LOAD_y;
				S_LOAD_y_wait: next_state = draw ? S_LOAD_y_wait : Drawing;
				Drawing: next_state = ld ? S_LOAD_x : Drawing;
        endcase
    end // state_table
   

    // Output logic aka all of our datapath control signals
    always @(*)
    begin: enable_signals
        ld_x = 1'b0;
        ld_y = 1'b0;
		ld_c = 1'b0;
		writeEn = 1'b0;
		
        case (current_state)
            S_LOAD_x: begin
                ld_x=1'b1;
				end
            S_LOAD_x_wait: begin
                ld_x=1'b1;
				end
            S_LOAD_y: begin
                ld_y=1'b1;
				ld_c = 1'b1;
                end
            S_LOAD_y_wait: begin
                ld_y=1'b1;
				ld_c = 1'b1;
                end
            Drawing: begin
				writeEn = 1'b1;
			end
		endcase
    end // enable_signals
   
    // current_state registers
    always@(posedge clk)
    begin: state_FFs
        if(!resetn) begin
            current_state <= S_LOAD_x;
				
		end
        else
            current_state <= next_state;
    end // state_FFS
endmodule
