`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/20 16:04:03
// Design Name: 
// Module Name: IDEX_REG
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


module IDEX_REG(
    input clock,
	input reset,
	input stall,
	input branch,
	input [31:0] pcIn,
	input [31:0] instIn,
	input [31:0] dataIn1,
	input [31:0] dataIn2,
	input [31:0] extendIn,
	input [4 : 0] rdIn,
	input [3 : 0] aluop_in,
	input [7 : 0] ctr_signal_in,
	output reg [31:0] pcOut,
	output reg [31:0] dataOut1,
	output reg [31:0] dataOut2,
	output reg [31:0] extendOut,
	output reg [3 : 0] aluop_out,
	output reg [7 : 0] ctr_signal_out,
	output reg [4:0] rdOut,
	output reg [4:0] inst16_20Out,
	output reg [4:0] inst21_25Out,
	output reg [5:0] inst0_5Out,
	output reg [4:0] inst6_10Out
    );
	
	initial begin
		pcOut <= 0;
		dataOut1 <= 0;
		dataOut2 <= 0;
		extendOut <= 0;
		aluop_out <= 0;
		ctr_signal_out <= 0;
		rdOut <=0;
		inst16_20Out <= 0;
		inst21_25Out <= 0;
		inst0_5Out <= 0;
		inst6_10Out <= 0;
	end
	
	always@ (reset)
	begin
	   if(reset)
	   begin
	       pcOut <= pcIn;
	       dataOut1 <= 0;
	       dataOut2 <= 0;
	       extendOut <= 0;
	       aluop_out <= 0;
	       ctr_signal_out <= 0;
	       rdOut <=0;
	       inst16_20Out <= 0;
	       inst21_25Out <= 0;
	       inst0_5Out <= 0;
	       inst6_10Out <= 0;
	    end
    end
    
	always @ (posedge clock)
	begin
	   if(stall||branch)
	   begin
	       pcOut <= pcIn;
	       dataOut1 <= 0;
	       dataOut2 <= 0;
	       extendOut <= 0;
	       aluop_out <= 4'hf;
	       ctr_signal_out <= 0;
	       rdOut <=0;
	       inst16_20Out <= 0;
	       inst21_25Out <= 0;
	       inst0_5Out <= 0;
	       inst6_10Out <= 0;
	   end else
	   begin
		pcOut = pcIn;
		dataOut1 <= dataIn1;
		dataOut2 <= dataIn2;
		extendOut <= extendIn;
		aluop_out <= aluop_in;
		ctr_signal_out <= ctr_signal_in;
		rdOut <= rdIn;
		inst16_20Out <= instIn[20:16];
		inst21_25Out <= instIn[25:21];
		inst0_5Out <= instIn[5:0];
		inst6_10Out <= instIn[10:6];
		end
	end
endmodule
