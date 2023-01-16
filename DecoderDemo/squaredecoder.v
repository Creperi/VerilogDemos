module squaredecoder(D, A);
input [3:0] A; 
/* A = A[3]
   B = A[2]
   C = A[1]
   D = A[0]
*/
output [7:0] D;
wire [3:0] N;
not na(N[0], A[0]);//D'
not nb(N[1], A[1]);//C'
not nc(N[2], A[2]);//B'
not nd(N[3], A[3]);//A'
assign D[0] = A[0];//D0 = D
assign D[1] = 0;//D1 = 0
and and1(D[2], A[1], N[0]);//D2 = CD'
xor xor1(x1, A[1], A[2]);//B'C+BC'
and and2(D[3], A[0], x1);//D3 = D(B'C+BC')
xor xor2(x2, A[3], A[2]);//(AB'+A'B)
and and3(a1, x2, A[0]);//(AB'+A'B)D
and and4(a2, A[2], N[1], N[0]);//BC'D'
or or1(D[4], a1, a2);//D4 = (AB'+A'B)D + BC'D'
and and5(a3, x2, A[1]);//(AB'+A'B)C
and and6(a4, A[3], A[2], A[0]);//ABD
or or2(D[5], a3, a4);//D5 = (A'B + A'B)C + ABD
or or3(o1, N[2], A[1]);//(B' + C)
and and7(D[6], o1, A[3]);//D6 = A(B' + C)
and and8(D[7], A[3], A[2]);//D7 = AB
endmodule

module Squaretesting;
    reg [3:0] in;
    wire [7:0] out;
    //four inputs and eight outputs
    squaredecoder Sq(out, in);
    initial
    begin
        in = 4'd0; //4 digits
    end
    always
        #10 in = in + 1'b1; //100ps delay
endmodule