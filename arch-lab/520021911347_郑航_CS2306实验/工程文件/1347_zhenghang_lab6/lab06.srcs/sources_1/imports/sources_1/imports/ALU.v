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

always @ (inputA or inputB or aluCtrOut) begin
    casex (aluCtrOut)
        4'b000x:        // add
            ALURes = inputA + inputB;
        4'b001x:        // sub
            ALURes = inputA - inputB;
        4'b0100:        // and
            ALURes = inputA & inputB;
        4'b0101:        // or
            ALURes = inputA | inputB;
        4'b0110:        // xor
            ALURes = inputA ^ inputB;
        4'b0111:        // nor
            ALURes = ~(inputA | inputB);
        4'b1000:        // slt
            ALURes = ($signed(inputA) < $signed(inputB));
        4'b1001:        // slt (unsigned)
            ALURes = (inputA < inputB);
        4'b1010:        // left-shift
            ALURes = (inputB << inputA);
        4'b1011:        // right-shift
            ALURes = (inputB >> inputA);
        4'b1100:        // right-shift (arithmetic)
            ALURes = ($signed(inputB) >>> inputA);
        default:        // default
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
