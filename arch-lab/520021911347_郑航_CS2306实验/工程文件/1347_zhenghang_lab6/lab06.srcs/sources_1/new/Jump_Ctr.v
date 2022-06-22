`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2022/04/20 10:25:15
// Design Name:
// Module Name: Jump_Ctr
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


module Jump_Ctr(
           input [1:0] ctr_signals,
           input [31:0] pc_jump_In,
           input [31:0] pc_In,
           input [31:0] data,
           input beq_signal,
           input bne_signal,
           input [31:0] branch_dest,
           output wire [31:0] pcOut
       );
wire [31:0] tmp1;
wire [31:0] tmp2;
wire [31:0] tmp3;

begin
    assign tmp1=ctr_signals[1]?pc_jump_In:pc_In;
    assign tmp2=ctr_signals[0]?data:tmp1;
    assign tmp3=beq_signal?branch_dest:tmp2;
    assign pcOut=bne_signal?branch_dest:tmp3;
end

endmodule
