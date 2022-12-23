module test_bench;
    reg clk, reset;//clock and reset as registers
    wire [3:0] q;//3 wires
    fourbitripplecounter f1(q, 1'b1, clk, reset);//the t is always 1
    initial 
    begin//It begins with 0 clock digit and 1 reset digit which in 1000ps and 1500ps is disabled and enabled in 1800ps, 
        clk = 1'b0;
        reset = 1'b1;
        #145 reset = 1'b0;
        #130 reset = 1'b1;
        #10 reset = 1'b0;
    end

    always #5 clk = ~clk;//Reset disabled for 50ps
endmodule

