`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/28 20:36:59
// Design Name: 
// Module Name: ALUCtr
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

module ALUCtr(
    input [1 : 0] aluOp,
    input [5 : 0] funct,
    output [3 : 0] aluCtrOut
    );
    
    reg [3 : 0] ALUCtrOut;
    
    always @ (aluOp or funct)
    begin
        casex ({aluOp, funct})
            8'b00xxxxxx:                //lw sw j
                ALUCtrOut = 4'b0010;
            8'b01xxxxxx:                //beq
                ALUCtrOut = 4'b0110;
            8'b10100000:                //add
                ALUCtrOut = 4'b0010;
            8'b10100010:                //sub
                ALUCtrOut = 4'b0110;
            8'b10100100:                //and
                ALUCtrOut = 4'b0000;
            8'b10100101:                //or
                ALUCtrOut = 4'b0001;
            8'b10101010:                //slt
                ALUCtrOut = 4'b0111;
        endcase
    end
    
    assign aluCtrOut = ALUCtrOut;
endmodule
