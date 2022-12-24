module fibmodule(seg0, seg1, seg2, clk, reset);
    output[6:0] seg0, seg1, seg2;//The led output of three digits
    reg[7:0] previous, current;
    wire[7:0] next;
    input clk, reset;
    add8 adder(next, previous, current, 1'b0);
    //From the 3rd exercise(If the reset or enable is on, it delays for 25 msec, else the delay counter inceases by 1)
	 decoder d(seg0, seg1, seg2, previous);
	 reg [24:0] delay_counter;
	wire enable;
	assign enable = (delay_counter == 25'd24999999) ? 1'b1 : 1'b0;
	always @ (negedge clk or posedge reset)
	if (reset)
		delay_counter <= 25'd0;
	else if (enable)
		delay_counter <= 25'd0;
	else delay_counter <= delay_counter + 1'b1;
	//
    always@(posedge clk or posedge reset)//Ιf the reset or clk flag is high
    if(reset)
    begin
        previous <= 8'd0;
        current <= 8'd1;
		  
    end
    else if (enable)
    begin
        previous <= current;//The previous enters the current value
        current <= next;//Current register enters the sum of previous and former current values
    end
endmodule