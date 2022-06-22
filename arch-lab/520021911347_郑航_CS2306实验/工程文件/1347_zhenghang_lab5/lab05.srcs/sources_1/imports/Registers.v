`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/28 21:15:27
// Design Name: 
// Module Name: Registers
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


module Registers(
    input [4 : 0] readReg1,
    input [4 : 0] readReg2,
    input [4 : 0] writeReg,
    input [31 : 0] writeData,
    input regWrite,
    input reset,
    input clk,
    output reg [31 : 0] readData1,
    output reg [31 : 0] readData2
    );
    
    reg [31 : 0] regFile [31 : 0];
    integer i;
    
    always @ (readReg1 or readReg2)
    begin
        readData1 = regFile[readReg1];
        readData2 = regFile[readReg2];
    end
    
    always @ (negedge clk or reset)
    begin
        if(reset)
        begin
            for(i=0;i<32;i=i+1)
                regFile[i] = 0;
        end
        else begin
            if(regWrite)
                regFile[writeReg] = writeData; 
        end
    end
endmodule
