`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/12/01 12:45:57
// Design Name: 
// Module Name: FIFO2
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
/*��ʵ����Ƶ�FIFO�洢���п�����16��8λ2������
�洢ԭ����Ϊ�洢�������󲻱�ɾ��Ԫ�أ���˽��洢��reg [7:0]mem[15:0]��Ϊ���ζ��У�����дָ���ڶ�������δ��ʱ�ﵽ15�����
*/

module FIFO2(clk,data_in,wr_en,rd_en,rst,data_out,empty,full);
    input clk;                  //ʱ���ź�(ԭ����ϵͳʱ���źţ���Ƶ�������⣬��Ϊ�ֶ�����ʱ���ź�)
    input [7:0]data_in;         //��������
    input wr_en;                //дʹ��
    input rd_en;                //��ʹ��
    input rst;                  //�����ź�
    output reg[7:0]data_out;   //�������
    output empty;               //��
    output full;                //��
    
    reg [3:0]counter=0;         //��������������Ԫ�ظ���
    reg [7:0]mem[15:0];         //�洢������
    reg [3:0]wr_ptr=0;          //��ָ�루�����˳�ֵ��
    reg [3:0]rd_ptr=0;          //дָ��
    
    assign empty=(counter==0)?1:0;  //�ɼ������ж϶��е������
    assign full=(counter==15)?1:0;
    
    always @(posedge clk)
    begin
        if(rst)                 //rst=1ʱ���������ź�
        begin
            counter<=0;
            data_out<=0;
            wr_ptr<=0;
            rd_ptr<=0;
        end
        else
        begin
            case({wr_en,rd_en}) //�ж϶���д�Ĳ���
                2'b00:counter<=counter;                 //��д������������
                2'b01:          //������
                begin
                    if(!empty)begin
                        data_out<=mem[rd_ptr];
                        counter<=counter-1;                 //������-1
                        rd_ptr<=(rd_ptr==15)?0:rd_ptr+1;    //ѭ��ʹ��
                    end
                    else data_out<=8'bz;
                end
                2'b10:          //д����
                begin
                    if(!full)begin
                        mem[wr_ptr]<=data_in;
                        counter<=counter+1;                 //������+1
                        wr_ptr<=(wr_ptr==15)?0:wr_ptr+1;
                    end
                    else data_out<=data_out;
                end
                2'b11:          //ͬʱ��д
                begin                                   //��д����ʹ���Լ���ָ�룬������
                    if(!empty)begin
                        data_out<=mem[rd_ptr];
                        rd_ptr<=(rd_ptr==15)?0:rd_ptr+1;
                        mem[wr_ptr]<=data_in;           //�ն���һ��!full
                        wr_ptr<=(wr_ptr==15)?0:wr_ptr+1;
                    end
                    else if(!full)begin                 //����Ϊ�գ��ж��Ƿ�д
                        mem[wr_ptr]<=data_in;
                        wr_ptr<=(wr_ptr==15)?0:wr_ptr+1;
                        counter<=counter+1;
                    end
                    else    data_out<=8'bz;             //����Ϊ�����z
                    
//                    if(!full)begin                    //��������ͬһ������ֵ����
//                        mem[wr_ptr][7:0]<=data_in;
//                        wr_ptr<=(wr_ptr==15)?0:wr_ptr+1;
//                        counter<=counter+1;
//                    end
                end
                default:counter<=counter;
            endcase
        end
    end
endmodule
