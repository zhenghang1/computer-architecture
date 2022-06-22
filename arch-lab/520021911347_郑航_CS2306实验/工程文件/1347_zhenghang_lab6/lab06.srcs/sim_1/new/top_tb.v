`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/25 15:32:47
// Design Name: 
// Module Name: top_tb
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


module top_tb(

    );
    reg clk;
    reg reset;
        
    Top top(.clk(clk), .reset(reset));
    
    initial begin
        $readmemb("C:/Archlabs/lab06/mem_inst.txt", top.inst_memory.instFile);
        $readmemh("C:/Archlabs/lab06/mem_data.txt", top.data_memory.memFile);         
        reset = 1;
        clk = 0;
    end
    
    always #10 clk = ~clk;
    
    initial begin
        #10 reset = 0;
    end
endmodule
