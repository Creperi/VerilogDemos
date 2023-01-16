//Structural Description
module FAStructural(Cout, S, A, B, Cin);

output Cout, S;
input A, B, Cin;
wire w1, w2, w3;

and a1(w1, A, B);
and a2(w2, B, Cin);
and a3(w3, A, Cin);
xor xor1(S, A, B, Cin);
or or1(Cout, w1, w2, w3);
endmodule

module test_bench;
reg [2:0] in;//Array variable for the inputs of 3-bit binary numbers
wire S, Cout;
FAStructural FAS (Cout, S, in[0], in[1], in[2]); //Replace module name "FA" with your own module’s name
 //Also, use the correct port order
initial
in = 3'b000;//3-bit binary number
always
#10 in = in + 1;//100ps delay 
endmodule
