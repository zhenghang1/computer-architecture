`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/20 19:02:02
// Design Name: 
// Module Name: EXMA_REG
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


module EXMA_REG(
    input clock,
	input reset,
	input [31:0] aluResIn,
	input [3:0] ctr_signals_In,
	input [31:0] readData2In,
	input [4:0] regdestIn,
	output reg [31:0] aluResOut,
	output reg [3:0] ctr_signals_Out,
	output reg [31:0] readData2Out,
	output reg [4:0] regdestOut
    );
    
	initial begin
		aluResOut <= 0;
		ctr_signals_Out=0;
		readData2Out<=0;
		regdestOut <= 0;
	end
	
	always@ (reset)
	begin
	   if(reset)
	   begin
        aluResOut <= 0;
		ctr_signals_Out=0;
		readData2Out<=0;
		regdestOut <= 0;
	    end
    end
	
	always @ (posedge clock)
	begin
        aluResOut <= aluResIn;
		ctr_signals_Out=ctr_signals_In;
		readData2Out<=readData2In;
		regdestOut <= regdestIn;
	end
endmodule
