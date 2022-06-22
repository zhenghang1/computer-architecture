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
    input [2 : 0] aluOp,
    input [5 : 0] funct,
    output [3 : 0] aluCtrOut,
    output shamtSign,
    output jrSign
    );
    
    reg [3 : 0] ALUCtrOut;
    reg ShamtSign;
    reg JrSign;
    
    always @ (aluOp or funct)
    begin
        ShamtSign=0;
        JrSign=0;
        casex ({aluOp, funct})
            9'b000xxxxxx:  // lw or sw: actually add
                ALUCtrOut = 4'b0010;
            9'b001xxxxxx:  // beq: actually sub
                ALUCtrOut = 4'b0110;
            9'b010xxxxxx:  // addi: actually add
                ALUCtrOut = 4'b0010;
            9'b011xxxxxx:  // andi: acutally and
                ALUCtrOut = 4'b0000;
            9'b100xxxxxx:  // ori: acutally or
                ALUCtrOut = 4'b0001;
            9'b101000000:  // sll: actually left-shift
            begin
                ALUCtrOut = 4'b0011;
                ShamtSign = 1;
            end
            9'b101000010:  // srl: actuall right-shift
            begin
                ALUCtrOut = 4'b0100;
                ShamtSign = 1;
            end
            9'b101001000:  // jr: actually not change
            begin
                ALUCtrOut = 4'b0101;
                JrSign=1;
            end
            9'b101100000:  // add: actually add
                ALUCtrOut = 4'b0010;
            9'b101100010:  // sub: actually sub
                ALUCtrOut = 4'b0110;
            9'b101100100:  // and: actually and
                ALUCtrOut = 4'b0000;
            9'b101100101:  // or: actually or
                ALUCtrOut = 4'b0001;
            9'b101101010:  // slt: actually set on less than
                ALUCtrOut = 4'b0111;
            9'b110xxxxxx:  // jump / jal: actually not change
                ALUCtrOut = 4'b0101;
        endcase
    end
    
    assign aluCtrOut = ALUCtrOut;
    assign shamtSign=ShamtSign;
    assign jrSign=JrSign;
    
endmodule
