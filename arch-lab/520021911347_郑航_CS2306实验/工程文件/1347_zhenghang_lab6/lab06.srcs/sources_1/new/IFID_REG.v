`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/20 15:34:14
// Design Name: 
// Module Name: IFID_REG
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


module IFID_REG(
    input clock,
	input reset,
	input stall,
	input branch,
	input [1:0] ctr_signals_In,
	input [31:0] pcIn,
	input [31:0] instIn,
	output reg [31:0] pcOut,
	output reg [31:0] instOut
    );
	initial begin
		pcOut = 0;
		instOut = 0;
	end
	always@ (reset)
	begin
	   if(reset)
	   begin
           pcOut=0;
	       instOut=0;
	    end
    end
	always @ (posedge clock)
	begin
		if(branch || ctr_signals_In[1] ||ctr_signals_In[0])
		begin
		  pcOut<=0;
		  instOut<=0;
	    end else if(!stall)
		begin
		  instOut=instIn;
		  pcOut = pcIn;
	    end
	end
endmodule
