module test_bench;
    reg clk, reset;//clock and reset as registers
    wire[7:0] previous;
    fibmodule fb(previous, clk, reset);
    initial 
    begin//It begins with 0 clock digit and 1 reset digit which in 1000ps and 1500ps is disabled and enabled in 1800ps, 
        clk = 1'b0;
        reset = 1'b1;
        #15 reset = 1'b0;
        #180 reset = 1'b1;
        #10 reset = 1'b0;
    end

    always #5 clk = ~clk;//Reset disabled for 50ps
endmodule

