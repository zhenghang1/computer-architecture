`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/28 20:47:39
// Design Name: 
// Module Name: ALU
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


module ALU(
    input [31 : 0] inputA,
    input [31 : 0] inputB,
    input [3 : 0] aluCtrOut,
    output zero,
    output [31 : 0] aluRes
    );
    
    reg Zero;
    reg [31 : 0] ALURes;
    
    always @ (inputA or inputB or aluCtrOut)
    begin
        case (aluCtrOut)
            4'b0000:    // and
                ALURes = inputA & inputB;
            4'b0001:    // or
                ALURes = inputA | inputB;
            4'b0010:    // add
                ALURes = inputA + inputB;
            4'b0110:    // sub
                ALURes = inputA - inputB;
            4'b0111:    // set on less than
                ALURes = ($signed(inputA) < $signed(inputB));
            4'b1100:    // nor
                ALURes = ~(inputA | inputB);
            4'b0011:    // left-shift
                ALURes = inputB << inputA;
            4'b0100:    // right-shift
                ALURes = inputB >> inputA;
            4'b0101:    // not change
                ALURes = inputA;
            default:
                ALURes = 0;
        endcase
        if (ALURes == 0)
            Zero = 1;
        else 
            Zero = 0;
    end
    
    assign zero = Zero;
    assign aluRes = ALURes;
endmodule
