`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/18 09:45:00
// Design Name: 
// Module Name: digit_clock
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
/*  �������������[1:0]��ʾ�룬[3:2]��ʾ�֣�LED[4:0]��ʾСʱ
    ��100MHzϵͳʱ���Է�Ƶ��400Hzʵ�ַ�ʱ���ã���������ÿ���һ����2**18=262144��2**27=134217728�����
clk_cnt[17:0]==250000ʱ����λ�仯һ�Σ�clk_cnt[26:0]==100_00_0000ʱ������һ��
    ���һ��rst��λ�����Խ�ʱ������
*/

module digit_clock(clk,rst,a_to_g,an,dp,led);
    input clk;              //clk��ϵͳĬ��ʱ���źţ�Ƶ��Ϊ100MHz
    input  rst;             //��λ��
    output reg [6:0]a_to_g; //��
    output reg [3:0]an;     //λ
    output reg dp;          //С����
    output [4:0]led;        //led�ƣ���ʾСʱ(0~15)
    
    wire [1:0] s;           //��ʱ��������ʾ400HzƵ��ɨ��ķ����룬4��ֵ�������Ӧan��4��ѡ��
    reg [3:0] digit;        //��ʱ��������¼��
    reg [26:0] clk_cnt=0;   //������������¼clk�仯����
    reg [6:0] second;       //�룬[6:4]��¼���ʮλ��[3:0]��¼��ĸ�λ
    reg [6:0] minute;       //��
    reg [4:0] hour=0;       //ʱ
    assign s=clk_cnt[19:18];
    assign led=hour;

    always@(*)              //ȷ��λ
    case(s)
        2'b00: begin digit=second[3:0];  dp=1;   end  //��ĸ�λ
        2'b01: begin digit=second[6:4];  dp=1;   end  //���ʮλ
        2'b10: begin digit=minute[3:0];  dp=0;   end  //�ֵĸ�λ
        2'b11: begin digit=minute[6:4];  dp=1;   end  //�ֵ�ʮλ
        default:digit=second[3:0];
    endcase
    always@(*)              //ȷ����
    case(digit)
        4'h0:a_to_g=7'b0000001;
        4'h1:a_to_g=7'b1001111;
        4'h2:a_to_g=7'b0010010;
        4'h3:a_to_g=7'b0000110;
        4'h4:a_to_g=7'b1001100;
        4'h5:a_to_g=7'b0100100;
        4'h6:a_to_g=7'b0100000;
        4'h7:a_to_g=7'b0001111;
        4'h8:a_to_g=7'b0000000;
        4'h9:a_to_g=7'b0000100;
        default:a_to_g=7'b0000001;
    endcase
    
    always@(*)              //�ı�λ
    begin
        an=4'b1111;
        an[s]=0;
    end
    
//    always@(rst)begin         //����always����к���һ��always����ͻ������źŴ���clk_cnt=0��second��minute��hour
//        if(rst==1)begin
//            clk_cnt=0;
//            second=0;
//            minute=0;
//            hour=0;
//        end
//        else;               //�����else������������������
//    end
    
    always@(posedge clk or posedge rst)
    begin
        if(rst==1)begin
            clk_cnt=0;
            second=0;
            minute=0;
            hour=0;
        end
        else if(clk_cnt==10000_0000)begin
            if(second[3:0]==9)begin
                if(second[6:4]==5)begin
                    if(minute[3:0]==9)begin
                        if(minute[6:4]==5)begin
                            hour=hour+1;
                            minute[6:4]=0;
                        end
                        else    minute[6:4]=minute[6:4]+1;
                        minute[3:0]=0;
                    end
                    else   minute[3:0]=minute[3:0]+1; 
                    second[6:4]=0;
                end
                else    second[6:4]=second[6:4]+1;
                second[3:0]=0;
            end
            else    second[3:0]=second[3:0]+1;
            clk_cnt=0;
        end
        else    clk_cnt=clk_cnt+1;
    end

endmodule
