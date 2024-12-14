`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/30 15:23:37
// Design Name: 
// Module Name: fsm_1011
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
/*1101���м��������������һ��8λ01����ÿ���ֶ�����һλ��������1101����ʱ���ɹ�
����ģ�飺��ť������ж�������˲����ӳ�30ms�ķ��������Ч����
��ת��ģ�飺�������8λ�����λ�����Ȼ���������ơ�ѭ���ò�������
���ģ�飺5��״̬ת�ƣ����1101
*/

module fsm_1011(
    input clk,          //ϵͳʱ���ź�
    input bot_clk,      //����ǰ�İ�ť�����źţ���ʾ����һλ
    input set,          //�����ʹ���ź�
    input [7:0] data,   //���������8λ����
    input rst,          //��λ�ź�
    output z,           //��ǰ�����������������1101��
    output now          //��ǰ�������ź�
    );
wire temp_clk;          //������İ�ť�ź�
wire x;                 //����״̬��ģ�����õ�������X

debkey ux(.clk(clk), .reset(rst), .key(bot_clk), .debkey(temp_clk));

par2ser uxx(.data(data), .clk(temp_clk), .rst(rst), .set(set), .out(x), .now(now));

fsm uxxx(.x(x), .clk(temp_clk), .rst(rst), .data_out(z));

endmodule


// par to ser
module par2ser(data,clk,rst,set,out,now);
    input [7:0]data;        //8λ���������ź�
    input clk,set,rst;      //��clk��ϵͳʱ�ӣ�����������İ�ť�����ź�
    output reg out;
    output now;             //��ת����1λ�ź�
    reg [7:0] load;         //��ʱ�Ĵ������洢data����ֹ����ʱdata���ı�
    always@(posedge clk or posedge rst) begin
        if (set) load <= data;              //set���趨data��ʹ���ź�
        else if (rst) load <= 0;
        else load <= {load[6:0],1'b0};      //Ҳ����д��load <= load<<1;
    end

    always@(*) begin
        out <= load[7];
    end
    
    assign now = out;
endmodule

// main fsm block(����״̬��)
module fsm(x, clk, rst, data_out);
    input clk, rst;              //�˴�clkΪ������İ����ź�
    input x;                     //����X
    output reg data_out;

parameter   s0 = 5'b00001,      //5��״̬
             s1 = 5'b00010,
             s2 = 5'b00100, 
             s3 = 5'b01000, 
             s4 = 5'b10000;

// reg delare
reg [4:0] current_state, next_state;    //��̬���̬

always @(negedge clk or posedge rst) begin  //negedge clk��ʾ�ɿ���ť�󴥷�
    if (rst) current_state <= s0;
    else current_state <= next_state;
end

always @(*) begin
    case (current_state)
        s0 : begin
            if (x) next_state <= s1;
            else next_state <= s0;
        end
        s1 : begin
            if (x) next_state <= s2;
            else next_state <= s0;
        end
        s2 : begin
            if (x) next_state <= s2;
            else next_state <= s3;
        end
        s3 : begin
            if (x) next_state <= s4;
            else next_state <= s0;
        end
        s4 : begin
            if (x) next_state <= s2;
            else next_state <= s0;
        end
        default: next_state <= s0;
    endcase
end

always @(*) begin
    if (current_state == s4) data_out <= 1;
    else data_out <= 0;
end
endmodule


// ����ģ��
module debkey(clk,reset,key,debkey);
parameter width = 1;
parameter T100Hz = 499999;

	input clk;
	input reset;
	input [width-1:0]key;
	output [width-1:0]debkey;

    reg [width-1:0]key_rrr,key_rr,key_r;

	integer cnt_100Hz;
	reg clk_100Hz;
	always @(posedge clk or posedge reset)
		if(reset)
			cnt_100Hz <= 32'b0;
		else
			begin
				cnt_100Hz <= cnt_100Hz + 1'b1;
				if(cnt_100Hz == T100Hz)
					begin
						cnt_100Hz <= 32'b0;
						clk_100Hz <= ~clk_100Hz;
					end
			end

	always @(posedge clk_100Hz or posedge reset)
		if(reset)
			begin
				key_rrr <= 1'b1;
				key_rr <= 1'b1;
				key_r <= 1'b1;
			end
		else
			begin
				key_rrr <= key_rr;
				key_rr <= key_r;
				key_r <= key;
			end

	assign debkey = key_rrr & key_rr & key_r;
	
endmodule