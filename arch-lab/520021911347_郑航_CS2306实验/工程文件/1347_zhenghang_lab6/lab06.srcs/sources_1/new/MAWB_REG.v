`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/20 19:40:28
// Design Name: 
// Module Name: MAWB_REG
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


module MAWB_REG(
    input clock,
	input reset,
	input [31:0] memDataIn,
	input ctr_signals_In,
	input [4:0] regdestIn,
	output reg [31:0] memDataOut,
	output reg ctr_signals_Out,
	output reg [4:0] regdestOut
    );

	initial begin
		memDataOut <= 0;
		ctr_signals_Out <= 0;
		regdestOut <= 0;
	end
	
	always@ (reset)
	begin
	   if(reset)
	   begin
	   memDataOut <= 0;
	   ctr_signals_Out <= 0;
	   regdestOut <= 0;
	   end
    end
	always @ (posedge clock)
	begin
        memDataOut <= memDataIn;
        ctr_signals_Out <= ctr_signals_In;
        regdestOut <= regdestIn;
	end
endmodule
