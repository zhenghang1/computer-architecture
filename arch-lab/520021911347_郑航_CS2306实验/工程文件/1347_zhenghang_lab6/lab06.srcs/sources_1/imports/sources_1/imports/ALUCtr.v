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
           input [3 : 0] aluOp,
           input [5 : 0] funct,
           output [3 : 0] aluCtrOut,
           output shamtSign
       );
reg [3 : 0] ALUCtrOut;
reg ShamtSign;

always @ (aluOp or funct) begin
    if (aluOp == 4'b1101 || aluOp == 4'b1110) begin
        case (funct)
            6'b100000:      // add
                ALUCtrOut = 4'b0000;
            6'b100001:      // addu
                ALUCtrOut = 4'b0001;
            6'b100010:      // sub
                ALUCtrOut = 4'b0010;
            6'b100011:      // subu
                ALUCtrOut = 4'b0011;
            6'b100100:      // and
                ALUCtrOut = 4'b0100;
            6'b100101:      // or
                ALUCtrOut = 4'b0101;
            6'b100110:      // xor
                ALUCtrOut = 4'b0110;
            6'b100111:      // nor
                ALUCtrOut = 4'b0111;
            6'b101010:      // slt
                ALUCtrOut = 4'b1000;
            6'b101011:      // sltu
                ALUCtrOut = 4'b1001;
            6'b000000:      // sll
                ALUCtrOut = 4'b1010;
            6'b000010:      // srl
                ALUCtrOut = 4'b1011;
            6'b000011:      // sra
                ALUCtrOut = 4'b1100;
            6'b000100:      // sllv
                ALUCtrOut = 4'b1010;
            6'b000110:      // srlv
                ALUCtrOut = 4'b1011;
            6'b000111:      // srav
                ALUCtrOut = 4'b1100;
            6'b001000:      // jr
                ALUCtrOut = 4'b1111;
            default:
                ALUCtrOut = 4'b1111;
        endcase

        if (funct == 6'b000000 || funct == 6'b000010 || funct == 6'b000011)
            ShamtSign = 1;
        else
            ShamtSign = 0;
    end
    else begin
        ALUCtrOut = aluOp;
        ShamtSign = 0;
    end
end

assign aluCtrOut = ALUCtrOut;
assign shamtSign=ShamtSign;

endmodule
