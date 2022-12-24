module add8(S, A, B, C);
output [7:0] S;
wire Cout;
input [7:0] A, B;
input C;

//Eight instances are created
FABehavioral F1(Cout1, S[0], A[0], B[0], C);
FABehavioral F2(Cout2, S[1], A[1], B[1], Cout1);
FABehavioral F3(Cout3, S[2], A[2], B[2], Cout2);
FABehavioral F4(Cout4, S[3], A[3], B[3], Cout3);
FABehavioral F5(Cout5, S[4], A[4], B[4], Cout4);
FABehavioral F6(Cout6, S[5], A[5], B[5], Cout5);
FABehavioral F7(Cout7, S[6], A[6], B[6], Cout6);
FABehavioral F8(Cout, S[7], A[7], B[7], Cout7);
endmodule