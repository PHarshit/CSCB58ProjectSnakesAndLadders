//*********************************************************************
// HEX Module to show the result on HEX Display // 

// start of HEX_seg module //
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
// End of HEX_seg module