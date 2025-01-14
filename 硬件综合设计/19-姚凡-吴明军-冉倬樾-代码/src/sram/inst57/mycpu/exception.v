`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/01/05 16:08:22
// Design Name: 
// Module Name: exception
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

module exception(
    input wire rst,
    input wire ades,adel,
    input wire [7:0] except,
    input wire [31:0] cp0_status,cp0_cause,
    output reg [31:0] excepttype
    );

    always @(*) begin
        if(rst) begin
            excepttype <= 32'b0;
        end
        else begin
            excepttype <= 32'b0;
            if (((cp0_cause[15:8] & cp0_status[15:8]) != 8'h00) && (cp0_status[1] == 1'b0 ) && (cp0_status[0]==1'b1) ) begin    // ����ж�
                excepttype <= 32'h0000_0001;
            end
            else if(except[7]==1'b1 || adel) begin
                excepttype <= 32'h0000_0004;    //ȡָ��ȡ���ݵ�ַ��,adel
            end
            else if(ades) begin//Data address error
                excepttype <= 32'h0000_0005;    //д���ݵ�ַ��ades
            end
            else if(except[6]==1'b1) begin
                excepttype <= 32'h0000_0008;    //ϵͳ����,syscall
            end
            else if (except[5]==1'b1) begin
                excepttype <= 32'h0000_0009;    //�ϵ�,break
            end
            else if (except[4]==1'b1) begin
                excepttype <= 32'h0000_000e;    //eret
            end
            else if (except[3]==1'b1) begin
                excepttype <= 32'h0000_000a;    //����ָ��,invalid
            end
            else if (except[2]==1'b1) begin
                excepttype <= 32'h0000_000c;    //�������,overflow
            end
        end
    end
endmodule
