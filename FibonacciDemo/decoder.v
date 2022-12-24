module decoder(seg0, seg1, seg2, previous);
input [7:0] previous;
reg[6:0] seg2, seg1, seg0;
output[6:0] seg2, seg1, seg0;
always @ (*)
case(previous)
8'd0: begin
  seg2 <= 7'b1111111;//0
  seg1 <= 7'b1111111;//0
  seg0 <= 7'b1000000;//0
end
8'd1: begin
  seg2 <= 7'b1111111;//0
  seg1 <= 7'b1111111;//0
  seg0 <= 7'b1111001;//1
end
8'd2: begin
  seg2 <= 7'b1111111;//0
  seg1 <= 7'b1111111;//0
  seg0 <= 7'b0100100;//2
end
8'd3: begin
  seg2 <= 7'b1111111;//0
  seg1 <= 7'b1111111;//0
  seg0 <= 7'b0110000;//3
end
8'd5: begin
  seg2 <= 7'b1111111;//0
  seg1 <= 7'b1111111;//0
  seg0 <= 7'b0010010;//5
end
8'd8: begin
  seg2 <= 7'b1111111;//0
  seg1 <= 7'b1111111;//0
  seg0 <= 7'b0000000;//8
end
8'd13: begin
  seg2 <= 7'b1111111;//0
  seg1 <= 7'b1111001;//1
  seg0 <= 7'b0110000;//3
end
8'd21: begin
  seg2 <= 7'b1111111;//0
  seg1 <= 7'b0100100;//2
  seg0 <= 7'b1111001;//1
end
8'd34: begin
  seg2 <= 7'b1111111;//0
  seg1 <= 7'b0110000;//3
  seg0 <= 7'b0011001;//4
end
8'd55: begin
  seg2 <= 7'b1111111;//0
  seg1 <= 7'b0010010;//5
  seg0 <= 7'b0010010;//5
end
8'd89: begin
  seg2 <= 7'b1111111;//0
	  seg1 <= 7'b0000000;//8
	  seg0 <= 7'b0010000;//9
 end
 8'd144: begin 
	  seg2 <= 7'b1111001;//1
	  seg1 <= 7'b0011001;//4
	  seg0 <= 7'b0011001;//4
 end
 8'd233: begin
	  seg2 <= 7'b0100100;//2
	  seg1 <= 7'b0110000;//3
	  seg0 <= 7'b0110000;//3
 end
 default: begin
		seg2 <= 7'b0000110;//E
		seg1 <= 7'b0101111;//r
		seg0 <= 7'b0101111;//r
 end
 endcase
endmodule