module T_FF (q, t, clk, reset);
    output q;//It both works as output and reg
    input t, clk, reset;
    reg q;
    always @ (posedge reset or negedge clk)//The reset must be 1 or clock 0
    if (reset)
        #1 q <= 1'b0;//The q is set to 0 by default
    else if (t == 1)//If the timer is 1, the q assigns its opposite value in 20ps
        #2 q <= ~q;
endmodule

//A 4-bit ripple counter that consists of 4 T_ff units
module fourbitripplecounter(q, d, clk, reset);
    output [3:0] q;
    input clk, reset, d;
    T_FF tff0(q[0], d, clk, reset);
    T_FF tff1(q[1], d, q[0], reset);
    T_FF tff2(q[2], d, q[1], reset);
    T_FF tff3(q[3], d, q[2], reset);
endmodule

//The model of 4bit sychronized counter
module sychronizedcounter(q, clk, reset);
    output wire[3:0]q;
    input clk, reset;
    assign t1 = q[0];
    and and1(t2, t1, q[1]);
    and and2(t3, t2, q[2]);
    T_FF tff0(q[0], 1'b1, clk, reset);
    T_FF tff1(q[1], t1, clk, reset);
    T_FF tff2(q[2], t2, clk, reset);
    T_FF tff3(q[3], t3, clk, reset);
endmodule