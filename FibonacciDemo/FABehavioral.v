//Structural Description
module FABehavioral(Cout, S, A, B, Cin);

output Cout, S;
input A, B, Cin;
wire w1, w2, w3;

assign w1 = A & B;
assign w2 = B & Cin;
assign w3 = A & Cin;
assign S = A ^ B ^ Cin;
assign Cout = w1 | w2 | w3;
endmodule

// module test_bench;
// reg [2:0] in;//Array variable for the inputs of 3-bit binary numbers
// wire S, Cout;
// FABehavioral FAB (Cout, S, in[0], in[1], in[2]); //Replace module name "FA" with your own module’s name
//  //Also, use the correct port order
// initial
// in = 3'b000;//3-bit binary number
// always
// #10 in = in + 1;//100ps delay 
// endmodule