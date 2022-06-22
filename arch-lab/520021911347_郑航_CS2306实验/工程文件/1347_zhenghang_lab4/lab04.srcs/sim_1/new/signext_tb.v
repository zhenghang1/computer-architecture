`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/29 15:16:17
// Design Name: 
// Module Name: signext_tb
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


module signext_tb(
    );
    
    reg [15 : 0] Inst;
    wire [31 : 0] Data;
    
    signext sign_ext(.inst(Inst), .data(Data));
    
    initial begin
        Inst = 0;
        
        #100;
        Inst = 1;
        
        #100;
        Inst = 16'hffff;
        
        #100;
        Inst = 2;
        
        #100;
        Inst = 16'hfffe;
        
        #100;
        Inst = 16'hf000;
        
        #100;
        Inst = 16'h0123;
    end
endmodule
