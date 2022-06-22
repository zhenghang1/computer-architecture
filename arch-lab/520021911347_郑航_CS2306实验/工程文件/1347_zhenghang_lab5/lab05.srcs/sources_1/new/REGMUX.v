`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/29 16:30:01
// Design Name: 
// Module Name: RegMux
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


module RegMux(
    input select,
    input [4:0] input0,
    input [4:0] input1,
    output [4:0] out
    );
    assign out = select?input0:input1;
endmodule