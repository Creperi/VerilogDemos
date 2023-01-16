//A 2-4 decoder 
module twobitdecoder(D, A, enabler);
    output [3:0]D;
    input [1:0]A;
    input enabler;
    wire [1:0]N;
    not n1(N[0], A[0]);
    not n2(N[1], A[1]);
    and and1(D[0], N[1], N[0], enabler);
    and and2(D[1], N[1], A[0], enabler);
    and and3(D[2], N[0], A[1], enabler);
    and and4(D[3], A[1], A[0], enabler);
endmodule

//A 4-16 decoder that consists of five 2-4 decoder modules
module fourbitdecoder(out, in);
    input [3:0]in;
    output [15:0]out;
    wire [3:0] en;
    twobitdecoder t1(en[3:0], in[3:2], 1);//It uses enabler wires as outputs so they can be to the next modules each one
    //Every module has four output positions
    twobitdecoder t2(out[3:0], in[1:0], en[0]);
    twobitdecoder t3(out[7:4], in[1:0], en[1]);
    twobitdecoder t4(out[11:8], in[1:0], en[2]);
    twobitdecoder t5(out[15:12], in[1:0], en[3]);
endmodule

module testbench;
    reg [3:0] in;
    wire [15:0] out;
    //four inputs and eight outputs
    fourbitdecoder fourb(out, in);
    initial
    begin
        in = 4'd0; //4 digits
    end
    always
        #10 in = in + 1'b1; //100ps delay
endmodule