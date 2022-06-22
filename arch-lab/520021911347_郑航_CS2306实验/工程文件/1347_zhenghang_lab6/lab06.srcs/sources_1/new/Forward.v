`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2022/04/20 09:59:02
// Design Name:
// Module Name: Forward
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


module Forward(
           input select1,
           input select2,
           input [31:0] data1,
           input [31:0] data2,
           input [31:0] alures,
           output wire [31:0] out
       );
wire [31:0] tmp;
begin
    assign tmp=select1?data1:data2;
    assign out=select2?alures:tmp;
end
endmodule
