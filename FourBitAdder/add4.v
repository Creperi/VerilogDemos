module add4(Cout, S, A, B, C);
output wire [3:0] S;
output Cout;
input [3:0] A, B;
input C;

//Four instances are created
FAStructural F1(Cout1, S[0], A[0], B[0], C);
FAStructural F2(Cout2, S[1], A[1], B[1], Cout1);
FAStructural F3(Cout3, S[2], A[2], B[2], Cout2);
FAStructural F4(Cout, S[3], A[3], B[3], Cout3);
endmodule