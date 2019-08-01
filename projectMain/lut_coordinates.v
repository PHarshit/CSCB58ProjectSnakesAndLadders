module lut_coordinates(clock, number, out_x, out_y);
	input [6:0] number;
	input clock;
	output reg [8:0] out_x;
	output reg [8:0] out_y;
	always @(negedge clock)
		begin
			case(number)
			7'd0:
			  begin
				 out_x <= 9'd5;
				 out_y <= 9'd210;
			  end
			7'd1:
			  begin
				 out_x <= 9'd14;
				 out_y <= 9'd210;
			  end
			7'd2:
			  begin
				 out_x <= 9'd44;
				 out_y <= 9'd210;
			  end
			7'd3:
			  begin
				 out_x <= 9'd74;
				 out_y <= 9'd210;
			  end
			7'd4:
			  begin
				 out_x <= 9'd104;
				 out_y <= 9'd210;
			  end
			7'd5:
			  begin
				 out_x <= 9'd134;
				 out_y <= 9'd210;
			  end
			7'd6:
			  begin
				 out_x <= 9'd164;
				 out_y <= 9'd210;
			  end
			7'd7:
			  begin
				 out_x <= 9'd194;
				 out_y <= 9'd210;
			  end
			7'd8:
			  begin
				 out_x <= 9'd224;
				 out_y <= 9'd210;
			  end
			7'd9:
			  begin
				 out_x <= 9'd254;
				 out_y <= 9'd210;
			  end
			7'd10:
			  begin
				 out_x <= 9'd284;
				 out_y <= 9'd210;
			  end
			7'd11:
			  begin
				 out_x <= 9'd284;
				 out_y <= 9'd188;
			  end
			7'd12:
			  begin
				 out_x <= 9'd254;
				 out_y <= 9'd188;
			  end
			7'd13:
			  begin
				 out_x <= 9'd224;
				 out_y <= 9'd188;
			  end
			7'd14:
			  begin
				 out_x <= 9'd194;
				 out_y <= 9'd188;
			  end
			7'd15:
			  begin
				 out_x <= 9'd164;
				 out_y <= 9'd188;
			  end
			7'd16:
			  begin
				 out_x <= 9'd134;
				 out_y <= 9'd188;
			  end
			7'd17:
			  begin
				 out_x <= 9'd104;
				 out_y <= 9'd188;
			  end
			7'd18:
			  begin
				 out_x <= 9'd74;
				 out_y <= 9'd188;
			  end
			7'd19:
			  begin
				 out_x <= 9'd44;
				 out_y <= 9'd188;
			  end
			7'd20:
			  begin
				 out_x <= 9'd14;
				 out_y <= 9'd188;
			  end
			7'd21:
			  begin
				 out_x <= 9'd14;
				 out_y <= 9'd166;
			  end
			7'd22:
			  begin
				 out_x <= 9'd44;
				 out_y <= 9'd166;
			  end
			7'd23:
			  begin
				 out_x <= 9'd74;
				 out_y <= 9'd166;
			  end
			7'd24:
			  begin
				 out_x <= 9'd104;
				 out_y <= 9'd166;
			  end
			7'd25:
			  begin
				 out_x <= 9'd134;
				 out_y <= 9'd166;
			  end
			7'd26:
			  begin
				 out_x <= 9'd164;
				 out_y <= 9'd166;
			  end
			7'd27:
			  begin
				 out_x <= 9'd194;
				 out_y <= 9'd166;
			  end
			7'd28:
			  begin
				 out_x <= 9'd224;
				 out_y <= 9'd166;
			  end
			7'd29:
			  begin
				 out_x <= 9'd254;
				 out_y <= 9'd166;
			  end
			7'd30:
			  begin
				 out_x <= 9'd284;
				 out_y <= 9'd166;
			  end
			7'd31:
			  begin
				 out_x <= 9'd284;
				 out_y <= 9'd144;
			  end
			7'd32:
			  begin
				 out_x <= 9'd254;
				 out_y <= 9'd144;
			  end
			7'd33:
			  begin
				 out_x <= 9'd224;
				 out_y <= 9'd144;
			  end
			7'd34:
			  begin
				 out_x <= 9'd194;
				 out_y <= 9'd144;
			  end
			7'd35:
			  begin
				 out_x <= 9'd164;
				 out_y <= 9'd144;
			  end
			7'd36:
			  begin
				 out_x <= 9'd134;
				 out_y <= 9'd144;
			  end
			7'd37:
			  begin
				 out_x <= 9'd104;
				 out_y <= 9'd144;
			  end
			7'd38:
			  begin
				 out_x <= 9'd74;
				 out_y <= 9'd144;
			  end
			7'd39:
			  begin
				 out_x <= 9'd44;
				 out_y <= 9'd144;
			  end
			7'd40:
			  begin
				 out_x <= 9'd14;
				 out_y <= 9'd144;
			  end
			7'd41:
			  begin
				 out_x <= 9'd14;
				 out_y <= 9'd122;
			  end
			7'd42:
			  begin
				 out_x <= 9'd44;
				 out_y <= 9'd122;
			  end
			7'd43:
			  begin
				 out_x <= 9'd74;
				 out_y <= 9'd122;
			  end
			7'd44:
			  begin
				 out_x <= 9'd104;
				 out_y <= 9'd122;
			  end
			7'd45:
			  begin
				 out_x <= 9'd134;
				 out_y <= 9'd122;
			  end
			7'd46:
			  begin
				 out_x <= 9'd164;
				 out_y <= 9'd122;
			  end
			7'd47:
			  begin
				 out_x <= 9'd194;
				 out_y <= 9'd122;
			  end
			7'd48:
			  begin
				 out_x <= 9'd224;
				 out_y <= 9'd122;
			  end
			7'd49:
			  begin
				 out_x <= 9'd254;
				 out_y <= 9'd122;
			  end
			7'd50:
			  begin
				 out_x <= 9'd284;
				 out_y <= 9'd122;
			  end
			7'd51:
			  begin
				 out_x <= 9'd284;
				 out_y <= 9'd100;
			  end
			7'd52:
			  begin
				 out_x <= 9'd254;
				 out_y <= 9'd100;
			  end
			7'd53:
			  begin
				 out_x <= 9'd224;
				 out_y <= 9'd100;
			  end
			7'd54:
			  begin
				 out_x <= 9'd194;
				 out_y <= 9'd100;
			  end
			7'd55:
			  begin
				 out_x <= 9'd164;
				 out_y <= 9'd100;
			  end
			7'd56:
			  begin
				 out_x <= 9'd134;
				 out_y <= 9'd100;
			  end
			7'd57:
			  begin
				 out_x <= 9'd104;
				 out_y <= 9'd100;
			  end
			7'd58:
			  begin
				 out_x <= 9'd74;
				 out_y <= 9'd100;
			  end
			7'd59:
			  begin
				 out_x <= 9'd44;
				 out_y <= 9'd100;
			  end
			7'd60:
			  begin
				 out_x <= 9'd14;
				 out_y <= 9'd100;
			  end
			7'd61:
			  begin
				 out_x <= 9'd14;
				 out_y <= 9'd78;
			  end
			7'd62:
			  begin
				 out_x <= 9'd44;
				 out_y <= 9'd78;
			  end
			7'd63:
			  begin
				 out_x <= 9'd74;
				 out_y <= 9'd78;
			  end
			7'd64:
			  begin
				 out_x <= 9'd104;
				 out_y <= 9'd78;
			  end
			7'd65:
			  begin
				 out_x <= 9'd134;
				 out_y <= 9'd78;
			  end
			7'd66:
			  begin
				 out_x <= 9'd164;
				 out_y <= 9'd78;
			  end
			7'd67:
			  begin
				 out_x <= 9'd194;
				 out_y <= 9'd78;
			  end
			7'd68:
			  begin
				 out_x <= 9'd224;
				 out_y <= 9'd78;
			  end
			7'd69:
			  begin
				 out_x <= 9'd254;
				 out_y <= 9'd78;
			  end
			7'd70:
			  begin
				 out_x <= 9'd284;
				 out_y <= 9'd78;
			  end
			7'd71:
			  begin
				 out_x <= 9'd284;
				 out_y <= 9'd56;
			  end
			7'd72:
			  begin
				 out_x <= 9'd254;
				 out_y <= 9'd56;
			  end
			7'd73:
			  begin
				 out_x <= 9'd224;
				 out_y <= 9'd56;
			  end
			7'd74:
			  begin
				 out_x <= 9'd194;
				 out_y <= 9'd56;
			  end
			7'd75:
			  begin
				 out_x <= 9'd164;
				 out_y <= 9'd56;
			  end
			7'd76:
			  begin
				 out_x <= 9'd134;
				 out_y <= 9'd56;
			  end
			7'd77:
			  begin
				 out_x <= 9'd104;
				 out_y <= 9'd56;
			  end
			7'd78:
			  begin
				 out_x <= 9'd74;
				 out_y <= 9'd56;
			  end
			7'd79:
			  begin
				 out_x <= 9'd44;
				 out_y <= 9'd56;
			  end
			7'd80:
			  begin
				 out_x <= 9'd14;
				 out_y <= 9'd56;
			  end
			7'd81:
			  begin
				 out_x <= 9'd14;
				 out_y <= 9'd34;
			  end
			7'd82:
			  begin
				 out_x <= 9'd44;
				 out_y <= 9'd34;
			  end
			7'd83:
			  begin
				 out_x <= 9'd74;
				 out_y <= 9'd34;
			  end
			7'd84:
			  begin
				 out_x <= 9'd104;
				 out_y <= 9'd34;
			  end
			7'd85:
			  begin
				 out_x <= 9'd134;
				 out_y <= 9'd34;
			  end
			7'd86:
			  begin
				 out_x <= 9'd164;
				 out_y <= 9'd34;
			  end
			7'd87:
			  begin
				 out_x <= 9'd194;
				 out_y <= 9'd34;
			  end
			7'd88:
			  begin
				 out_x <= 9'd224;
				 out_y <= 9'd34;
			  end
			7'd89:
			  begin
				 out_x <= 9'd254;
				 out_y <= 9'd34;
			  end
			7'd90:
			  begin
				 out_x <= 9'd284;
				 out_y <= 9'd34;
			  end
			7'd91:
			  begin

				 out_x <= 9'd284;
				 out_y <= 9'd12;
			  end
			7'd92:
			  begin
				 out_x <= 9'd254;
				 out_y <= 9'd12;
			  end
			7'd93:
			  begin
				 out_x <= 9'd224;
				 out_y <= 9'd12;
			  end
			7'd94:
			  begin
				 out_x <= 9'd194;
				 out_y <= 9'd12;
			  end
			7'd95:
			  begin
				 out_x <= 9'd164;
				 out_y <= 9'd12;
			  end
			7'd96:
			  begin
				 out_x <= 9'd134;
				 out_y <= 9'd12;
			  end
			7'd97:
			  begin
				 out_x <= 9'd104;
				 out_y <= 9'd12;
			  end
			7'd98:
			  begin
				 out_x <= 9'd74;
				 out_y <= 9'd12;
			  end
			7'd99:
			  begin
				 out_x <= 9'd44;
				 out_y <= 9'd12;
			  end
			7'd100:
			  begin
				 out_x <= 9'd14;
				 out_y <= 9'd12;
			  end
		endcase
	end
endmodule
