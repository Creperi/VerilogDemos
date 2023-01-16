module RippleCarryAdder;
reg[3:0] A, B; //[7:0] for 8bit adder
wire[4:0] Res; //[8:0] for 8bit adder
add4 insta (Res[4], Res[3:0], A, B, 1'b0);
//add8 insta (Res[8], Res[7:0], A, B, 1'b0);
initial
    begin
    A = 4'd0;//4-bit binary number
    B = 4'd0;//4-bit binary number
    end
always
    #10 B = B + 1'b1;//100ps delay 

always
    #160 A = A + 1'b1;//2560ps delay 

endmodule