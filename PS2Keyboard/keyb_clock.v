module keyb_clock(seg5, seg4, seg3, seg2, seg1, seg0, clk, reset, keyb_clk, keyb_data);
output [6:0] seg5, seg4, seg3, seg2, seg1, seg0;
//reg[5:0] A, B;
input reset, clk;
input keyb_data;
input keyb_clk;//Input for the simulation only
reg [5:0] keyb_clock_samples, keyb_binary_reg;
//wire [6:0] segtest, segresult, segresult2;//For testing purposes
reg [10:0] keyb_data_reg;
wire [5:0] result, dec_in;
wire error;
wire [3:0] state, previous_state;
wire [5:0] binary;
wire [5:0] operand1, operand2;

//assign keyb_clk = (!keyb_data_reg[0] ? 1'b0 : 1'bz);

always @ (posedge clk or posedge reset)
begin
    if(reset)
        keyb_clock_samples <= 6'b000000;//0
    else
        keyb_clock_samples <= {keyb_clk, keyb_clock_samples[5:1]};
end

always @ (posedge clk or posedge reset)
begin
    if(reset)
        keyb_data_reg <= 11'b11111111111;//FF
    else if(!keyb_data_reg[0])
        keyb_data_reg <= 11'b11111111111;//FF
    else if(keyb_clock_samples == 6'b000111)//7 clock samples
        keyb_data_reg <= {keyb_data, keyb_data_reg[10:1]};
end

statemachine sm(seg5, seg4, seg3, seg2, seg1, seg0, result, operand1, operand2, sub, error, reset, clk, state, previous_state, keyb_data_reg[9:2], binary);

endmodule

//A module to obtain the value(in 6 bit binary form) of the 8 digits from keyb_data_reg 
module keybtobin(binary, packet);
    input [7:0] packet;
    output binary;
    reg[5:0] binary;
    always @(packet) begin
    case(packet)
    8'h45: begin
        binary <= 6'b000000;//0
    end
    8'h16: begin
        binary <= 6'b000001;//1
    end
    8'h1E: begin
        binary <= 6'b000010;//2
    end
    8'h26: begin
        binary <= 6'b000011;//3
    end
    8'h25: begin
        binary <= 6'b000100;//4
    end
    8'h2E: begin
        binary <= 6'b000101;//5
    end
    8'h36: begin
        binary <= 6'b000110;//6
    end
    8'h3D: begin
        binary <= 6'b000111;//7
    end
    8'h3E: begin
        binary <= 6'b001000;//8
    end
    8'h46: begin
        binary <= 6'b001001;//9
    end  
    default: begin
        binary <= 6'b111111;//no digit detected
    end
    endcase
    end
endmodule

//A module for converting keyb packet code to segment
module keybtoseg(seg, packet);
    input [7:0] packet;
    output reg[6:0] seg;
    always @(packet) begin
    case(packet)
    8'h45: begin
        seg <= 7'b1000000;//0
    end
    8'h16: begin
        seg <= 7'b1111001;//1
    end
    8'h1E: begin
        seg <= 7'b0100100;//2
    end
    8'h26: begin
        seg <= 7'b0110000;//3
    end
    8'h25: begin
        seg <= 7'b0011001;//4
    end
    8'h2E: begin
        seg <= 7'b0010010;//5
    end
    8'h36: begin
        seg <= 7'b0000010;//6
    end
    8'h3D: begin
        seg <= 7'b0000111;//7
    end
    8'h3E: begin
        seg <= 7'b0000000;//8
    end
    8'h46: begin
        seg <= 7'b0010000;//9
    end
    8'h7B: begin
        seg <= 7'b1000000;//-
    end
    8'h79: begin
        seg <= 7'b1001110;//+
    end
    8'h55: begin
        seg <= 7'b1010101;//=
    end 
    default: begin
        seg <= 7'b1111111;//no digit detected
    end
    endcase
    end
endmodule

module operator(A, B, result, sub);
    input sub;
    input [5:0] A, B;
    output wire [5:0] result;
    assign result = sub ? A + ~B + 2 : A + B;
endmodule

//A module for converting the result to segments within the [-9, 18] range
module bintoseg(seg1, seg, binary);
    input[5:0] binary;
    output reg[6:0] seg1, seg;
    always @(binary) begin
    case(binary)
    -4'd9: begin
        seg1 <= 7'b1000000;//-
        seg <= 7'b0010000;//9
    end
    -4'd8: begin
        seg1 <= 7'b1000000;//-
        seg <= 7'b0000000;//8
    end
    -4'd7: begin
        seg1 <= 7'b1000000;//-
        seg <= 7'b0000111;//7
    end
    -4'd6: begin
        seg1 <= 7'b1000000;//-
        seg <= 7'b0000010;//6
    end
    -4'd5: begin
        seg1 <= 7'b1000000;//-
        seg <= 7'b0010010;//5
    end
    -4'd4: begin
        seg1 <= 7'b1000000;//-
        seg <= 7'b0011001;//4
    end
    -4'd3: begin
        seg1 <= 7'b1000000;//-
        seg <= 7'b0110000;//3
    end
    -4'd2: begin
        seg1 <= 7'b1000000;//-
        seg <= 7'b0100100;//2
    end
    -4'd1: begin
        seg1 <= 7'b1000000;//-
        seg <= 7'b1111001;//1
    end
    5'd0: begin
        seg <= 7'b1000000;//0
    end
    5'd1: begin
        seg <= 7'b1111001;//1
    end
    5'd2: begin
        seg <= 7'b0100100;//2
    end
    5'd3: begin
        seg <= 7'b0110000;//3
    end
    5'd4: begin
        seg <= 7'b0011001;//4
    end
    5'd5: begin
        seg <= 7'b0010010;//5
    end
    5'd6: begin
        seg <= 7'b0000010;//6
    end
    5'd7: begin
        seg <= 7'b0000111;//7
    end
    5'd8: begin
        seg <= 7'b0000000;//8
    end
    5'd9: begin
        seg <= 7'b0010000;//9
    end
    5'd10: begin
        seg1 <= 7'b1111001;//1
        seg <= 7'b1000000;//0
    end
    5'd11: begin
        seg1 <= 7'b1111001;//1
        seg <= 7'b1111001;//1
    end
    5'd12: begin
        seg1 <= 7'b1111001;//1
        seg <= 7'b0100100;//2
    end
    5'd13: begin
        seg1 <= 7'b1111001;//1
        seg <= 7'b0110000;//3
    end
    5'd14: begin
        seg1 <= 7'b1111001;//1
        seg <= 7'b0011001;//4
    end
    5'd15: begin
        seg1 <= 7'b1111001;//1
        seg <= 7'b0010010;//5
    end
    5'd16: begin
        seg1 <= 7'b1111001;//1
        seg <= 7'b0000010;//6
    end
    5'd17: begin
        seg1 <= 7'b1111001;//1
        seg <= 7'b0000111;//7
    end
    5'd18: begin
        seg1 <= 7'b1111001;//1
        seg <= 7'b0000000;//8
    end
    default: begin
        seg <= 7'b1111001;//E
    end
    endcase
    end
endmodule

//A 6bit 2 in 1 mux module
module mux_2to1_6bit ( input sel, input [5:0] data1, input [5:0] data2, output reg [5:0] result);

always @ (data1 or data2 or sel) begin
  if (sel) begin
    result <= data2;
  end else begin
    result <= data1;
  end
end

endmodule


//A finite state machine that returns the six segments
module statemachine(seg5, seg4, seg3, seg2, seg1, seg0, result, operand1, operand2, sub, error, reset, clk, state, prev_state, packet, binary);
    output reg[3:0] prev_state, state;
    reg[3:0]next_state;
    input reset, clk;
    output reg[5:0] operand1, operand2;
    input[7:0] packet;
    reg[7:0] prev_packet;
    output reg sub;//A variable that indiates whether is subraction or not.
    output reg error;//an error reg that sets the states to default
    output wire[5:0] binary;
    output reg [6:0] seg5, seg4, seg3, seg2, seg1, seg0;//The outputs of module(six segment digits)
    wire [6:0] curr_seg, result_seg1, result_seg;
    reg [5:0] A, B;//Both represent digits
    output wire[5:0] result;
    parameter WAIT_OPERAND1 = 0, WAIT_OPERATOR = 1, WAIT_OPERAND2 =2 , WAIT_EQ = 3, WAIT_F0 = 4, AFTER_F0 = 5;//the states
    operator o(A, B, result, sub);//Excecutes the operation
    //The following instantiations convert the received packet into binary digits and 7bit segment
    keybtobin ktb(binary, packet);
    keybtoseg kts(curr_seg, packet);
    //It converts the result of the operation into two segments
    bintoseg brs(result_seg1, result_seg, result);
    
    always @(clk or posedge reset) begin
        if(reset) 
            begin
            error <= 1'b0;
            end
        else
            //prev_state <= state;
            state <= next_state;
    end
    //Main state machine. It receives the current state as previous.
    always@(*) begin
        begin
        if(packet[0])
        begin
        case(state)
        WAIT_OPERAND1: begin
            if(binary >= 4'd0 && binary <= 4'd9) begin
                operand1 <= binary;
                seg5 <= curr_seg;
                prev_packet = packet;
                prev_state = WAIT_OPERAND1;
                next_state = WAIT_F0;
            end
            else if(packet == 8'h55 || packet == 8'h79 || packet == 8'h7B)
                begin
                
                error <= 1'b1;
                seg5 <= 7'b1111001;
                prev_packet = packet;
                prev_state = WAIT_OPERAND1;
                next_state = WAIT_F0;
                end            
        end
        WAIT_OPERATOR: begin
            if(packet == 8'h7B)//Addition
                begin
                sub <= 1'b0;
                seg4 <= curr_seg;
                prev_packet <= packet;
                prev_state = WAIT_OPERATOR;
                next_state = WAIT_F0;
                end
            else if(packet == 8'h79)//Subtraction
                begin
                sub <= 1'b1;
                seg4 <= curr_seg;
                prev_packet <= packet;
                prev_state = WAIT_OPERATOR;
                next_state = WAIT_F0;
                end
            else
                begin
                error <= 1'b1;
                seg4 <= 7'b1111001;
                prev_packet <= packet;
                prev_state = WAIT_OPERATOR;
                next_state = WAIT_F0;
                end
        end
        WAIT_OPERAND2: begin
            if(binary >= 4'd0 && binary <= 4'd9) 
            begin
                operand2 <= binary;
                seg3 <= curr_seg;
                prev_packet <= packet;
                prev_state = WAIT_OPERAND2;
                next_state = WAIT_F0;
            end
            else begin
                error <= 1'b1;
                seg3 <= 7'b1111001;
                prev_packet <= packet;
                prev_state = WAIT_OPERAND2;
                next_state = WAIT_F0;
            end
        end
        WAIT_EQ: begin
            if(packet == 8'h55) 
                begin
                prev_packet <= packet;
                seg2 <= curr_seg;
                seg1 <= result_seg1;
                seg0 <= result_seg;
                end
            else
                begin
                    prev_packet <= packet;
                    error <= 1'b1;
                    seg2 <= 7'b1111001;
                    prev_state = WAIT_EQ;
                    next_state = WAIT_F0;
                end
        end
        WAIT_F0: begin//Is activated if it receives the specific F0 packet
            if(packet == 8'hF0)
                next_state = AFTER_F0;
        end
        AFTER_F0: begin//Depending on previous state, it drives to coresponding state
            if (prev_state == WAIT_OPERAND1)
                begin
                A <= operand1;
                next_state = WAIT_OPERATOR;
                end
            else if(prev_state == WAIT_OPERATOR)
                begin
                B <= operand2;
                next_state = WAIT_OPERAND2;
                end
            else if(prev_state == WAIT_OPERAND2)
                next_state = WAIT_EQ;
            else if (prev_state == WAIT_OPERAND1 && error == 1'b1) begin
                error <= 1'b0;
                next_state = WAIT_OPERAND1;
            end
            else if(prev_state == WAIT_OPERATOR && error == 1'b1) begin
                error <= 1'b0;
                next_state = WAIT_OPERATOR;
            end
            else if(prev_state == WAIT_OPERAND2 && error == 1'b1) begin
                error <= 1'b0;
                next_state = WAIT_OPERAND2;
            end
        end
        default:
            begin
            next_state = WAIT_OPERAND1;
            end
        endcase
        end
        end
    end
endmodule

module testbench;
    reg reset, clk;
    reg keyb_data;
    reg [10:0] data, data2, data3, data4, data5, data6, data7;
    reg keyb_clk;
    wire [6:0] seg5, seg4, seg3, seg2, seg1, seg0;
    integer i;
    //wire[7:0] data;
    keyb_clock kb(seg5, seg4, seg3, seg2, seg1, seg0, clk, reset, keyb_clk, keyb_data);
    //reg Tclk;    
    //assign keyb_clk = Tclk ? 1'b1 : 1'b0;
    initial begin
        i = 0;
        keyb_data <= 1'b0;
        keyb_clk <= 1'b0;
        clk <= 1'b0;
        reset <= 1'b1;
        #1 reset <= 1'b0;
        data <= {1'b0, 1'b1, 8'h36, 1'b1};//6
        data2 <= {1'b0, 1'b1, 8'hf0, 1'b1};//F0
        data3 <= {1'b0, 1'b1, 8'h79, 1'b1};//+
        data4 <= {1'b0, 1'b1, 8'hf0, 1'b1};//F0
        data5 <= {1'b0, 1'b1, 8'h26, 1'b1};//2
        data6 <= {1'b0, 1'b1, 8'h26, 1'b1};//F0
        data7 <= {1'b0, 1'b1, 8'h55, 1'b1};//=
    end
    initial begin
        for(i = 0; i < 11; i = i + 1)
            #200 keyb_data <= data[i];
        for(i = 0; i < 11; i = i + 1)
            #200 keyb_data <= data2[i];
        for(i = 0; i < 11; i = i + 1)
            #200 keyb_data <= data3[i];
        for(i = 0; i < 11; i = i + 1)
            #200 keyb_data <= data4[i];
        for(i = 0; i < 11; i = i + 1)
            #200 keyb_data <= data5[i];
        for(i = 0; i < 11; i = i + 1)
            #200 keyb_data <= data6[i];
        for(i = 0; i < 11; i = i + 1)
            #200 keyb_data <= data7[i];
    end
    always 
    #5 clk <= ~clk;//5 * 2 = 10 = Tclk
    always
    #100 keyb_clk <= ~keyb_clk;
    always @(negedge keyb_clk or posedge reset)
    if(reset)
        begin
        i = 0;
        reset <= 1'b0;
        end
    always
    #2200 reset <= 1'b1;
    // always @(posedge keyb_clk)
    // #200 keyb_data <= 8'hf0;
endmodule