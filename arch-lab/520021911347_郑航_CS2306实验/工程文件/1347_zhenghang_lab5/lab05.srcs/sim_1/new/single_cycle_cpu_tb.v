`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/29 18:53:55
// Design Name: 
// Module Name: single_cycle_cpu_tb
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

    top TOP(
        .clk(clk),
        .reset(reset)
    );

    initial begin
        reset = 1;
        clk = 0;
        $readmemb("C:/Archlabs/lab05/mem_inst.txt",TOP.inst_memory.instFile);
        $readmemh("C:/Archlabs/lab05/mem_data.txt",TOP.memory.memFile);
        
        #10 reset = 0;
    end

    always #20 clk = ~clk;
endmodule
