`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2022/03/28 20:22:05
// Design Name:
// Module Name: Ctr
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


module Ctr(
           input [5 : 0] opCode,
           input [5 : 0] funct,
           input nop,
           output regDst,
           output aluSrc,
           output regWrite,
           output memToReg,
           output memRead,
           output memWrite,
           output beqSign,
           output bneSign,
           output luiSign,
           output extSign,
           output jalSign,
           output jrSign,
           output [3 : 0] aluOp,
           output jump
       );
reg RegDst;
reg ALUSrc;
reg MemToReg;
reg RegWrite;
reg MemRead;
reg MemWrite;
reg Branch;
reg [3:0] ALUOp;
reg Jump;
reg ExtSign;
reg JalSign;
reg BeqSign;
reg BneSign;
reg LuiSign;
reg JrSign;

always @(opCode or funct or nop) begin
    if (nop) begin
        RegDst = 0;
        ALUSrc = 0;
        RegWrite = 0;
        MemToReg = 0;
        MemRead = 0;
        MemWrite = 0;
        BeqSign = 0;
        BneSign = 0;
        LuiSign = 0;
        ExtSign = 0;
        JalSign = 0;
        JrSign = 0;
        ALUOp = 4'b1111;
        Jump = 0;
    end
    else begin
        case(opCode)
            6'b000000:      // R Type
            begin
                if (funct == 6'b001000) begin    // jr
                    RegDst = 0;
                    RegWrite = 0;
                    JrSign = 1;
                    ALUOp = 4'b1111;
                end
                else begin
                    RegDst = 1;
                    RegWrite = 1;
                    JrSign = 0;
                    ALUOp = 4'b1101;
                end
                ALUSrc = 0;
                MemToReg = 0;
                MemRead = 0;
                MemWrite = 0;
                BeqSign = 0;
                BneSign = 0;
                LuiSign = 0;
                ExtSign = 0;
                JalSign = 0;
                Jump = 0;
            end
            6'b001000:      // addi
            begin
                RegDst = 0;
                ALUSrc = 1;
                RegWrite = 1;
                MemToReg = 0;
                MemRead = 0;
                MemWrite = 0;
                BeqSign = 0;
                BneSign = 0;
                LuiSign = 0;
                ExtSign = 1;
                JalSign = 0;
                JrSign = 0;
                ALUOp = 4'b0000;
                Jump = 0;
            end
            6'b001001:      // addiu
            begin
                RegDst = 0;
                ALUSrc = 1;
                RegWrite = 1;
                MemToReg = 0;
                MemRead = 0;
                MemWrite = 0;
                BeqSign = 0;
                BneSign = 0;
                LuiSign = 0;
                ExtSign = 0;
                JalSign = 0;
                JrSign = 0;
                ALUOp = 4'b0001;
                Jump = 0;
            end
            6'b001100:      // andi
            begin
                RegDst = 0;
                ALUSrc = 1;
                RegWrite = 1;
                MemToReg = 0;
                MemRead = 0;
                MemWrite = 0;
                BeqSign = 0;
                BneSign = 0;
                LuiSign = 0;
                ExtSign = 0;
                JalSign = 0;
                JrSign = 0;
                ALUOp = 4'b0100;
                Jump = 0;
            end
            6'b001101:      // ori
            begin
                RegDst = 0;
                ALUSrc = 1;
                RegWrite = 1;
                MemToReg = 0;
                MemRead = 0;
                MemWrite = 0;
                BeqSign = 0;
                BneSign = 0;
                LuiSign = 0;
                ExtSign = 0;
                JalSign = 0;
                JrSign = 0;
                ALUOp = 4'b0101;
                Jump = 0;
            end
            6'b001110:      // xori
            begin
                RegDst = 0;
                ALUSrc = 1;
                RegWrite = 1;
                MemToReg = 0;
                MemRead = 0;
                MemWrite = 0;
                BeqSign = 0;
                BneSign = 0;
                LuiSign = 0;
                ExtSign = 0;
                JalSign = 0;
                JrSign = 0;
                ALUOp = 4'b0110;
                Jump = 0;
            end
            6'b001111:      // lui
            begin
                RegDst = 0;
                ALUSrc = 1;
                RegWrite = 1;
                MemToReg = 0;
                MemRead = 0;
                MemWrite = 0;
                BeqSign = 0;
                BneSign = 0;
                LuiSign = 1;
                ExtSign = 0;
                JalSign = 0;
                JrSign = 0;
                ALUOp = 4'b1010;
                Jump = 0;
            end
            6'b100011:      // lw
            begin
                RegDst = 0;
                ALUSrc = 1;
                RegWrite = 1;
                MemToReg = 1;
                MemRead = 1;
                MemWrite = 0;
                BeqSign = 0;
                BneSign = 0;
                LuiSign = 0;
                ExtSign = 1;
                JalSign = 0;
                JrSign = 0;
                ALUOp = 4'b0001;
                Jump = 0;
            end
            6'b101011:      // sw
            begin
                RegDst = 0;
                ALUSrc = 1;
                RegWrite = 0;
                MemToReg = 0;
                MemRead = 0;
                MemWrite = 1;
                BeqSign = 0;
                BneSign = 0;
                LuiSign = 0;
                ExtSign = 1;
                JalSign = 0;
                JrSign = 0;
                ALUOp = 4'b0001;
                Jump = 0;
            end
            6'b000100:      // beq
            begin
                RegDst = 0;
                ALUSrc = 0;
                RegWrite = 0;
                MemToReg = 0;
                MemRead = 0;
                MemWrite = 0;
                BeqSign = 1;
                BneSign = 0;
                LuiSign = 0;
                ExtSign = 1;
                JalSign = 0;
                JrSign = 0;
                ALUOp = 4'b0011;
                Jump = 0;
            end
            6'b000101:      // bne
            begin
                RegDst = 0;
                ALUSrc = 0;
                RegWrite = 0;
                MemToReg = 0;
                MemRead = 0;
                MemWrite = 0;
                BeqSign = 0;
                BneSign = 1;
                LuiSign = 0;
                ExtSign = 1;
                JalSign = 0;
                JrSign = 0;
                ALUOp = 4'b0011;
                Jump = 0;
            end
            6'b001010:      // slti
            begin
                RegDst = 0;
                ALUSrc = 1;
                RegWrite = 1;
                MemToReg = 0;
                MemRead = 0;
                MemWrite = 0;
                BeqSign = 0;
                BneSign = 0;
                LuiSign = 0;
                ExtSign = 1;
                JalSign = 0;
                JrSign = 0;
                ALUOp = 4'b1000;
                Jump = 0;
            end
            6'b001011:      // sltiu
            begin
                RegDst = 0;
                ALUSrc = 1;
                RegWrite = 1;
                MemToReg = 0;
                MemRead = 0;
                MemWrite = 0;
                BeqSign = 0;
                BneSign = 0;
                LuiSign = 0;
                ExtSign = 0;
                JalSign = 0;
                JrSign = 0;
                ALUOp = 4'b1001;
                Jump = 0;
            end
            6'b000010:      // Jump
            begin
                RegDst = 0;
                ALUSrc = 0;
                RegWrite = 0;
                MemToReg = 0;
                MemRead = 0;
                MemWrite = 0;
                BeqSign = 0;
                BneSign = 0;
                LuiSign = 0;
                ExtSign = 0;
                JalSign = 0;
                JrSign = 0;
                ALUOp = 4'b1111;
                Jump = 1;
            end
            6'b000011:      // jal
            begin
                RegDst = 0;
                ALUSrc = 0;
                RegWrite = 0;
                MemToReg = 0;
                MemRead = 0;
                MemWrite = 0;
                BeqSign = 0;
                BneSign = 0;
                LuiSign = 0;
                ExtSign = 0;
                JalSign = 1;
                JrSign = 0;
                ALUOp = 4'b1111;
                Jump = 1;
            end
            default: begin
                RegDst = 0;
                ALUSrc = 0;
                RegWrite = 0;
                MemToReg = 0;
                MemRead = 0;
                MemWrite = 0;
                BeqSign = 0;
                BneSign = 0;
                LuiSign = 0;
                ExtSign = 0;
                JalSign = 0;
                JrSign = 0;
                ALUOp = 4'b1111;
                Jump = 0;
            end
        endcase
    end
end

    assign regDst = RegDst;
    assign aluSrc = ALUSrc;
    assign memToReg = MemToReg;
    assign regWrite = RegWrite;
    assign memRead = MemRead;
    assign memWrite = MemWrite;
    assign aluOp = ALUOp;
    assign jump = Jump;
    assign extSign=ExtSign;
    assign jalSign=JalSign;
    assign bneSign=BneSign;
    assign beqSign=BeqSign;
    assign jrSign=JrSign;
    assign luiSign=LuiSign;

endmodule
