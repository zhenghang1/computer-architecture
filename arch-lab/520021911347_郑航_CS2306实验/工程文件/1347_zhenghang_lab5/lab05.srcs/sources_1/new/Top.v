`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/29 16:42:16
// Design Name: 
// Module Name: Top
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


module top(
        input clk,
        input reset
    );
    
    wire [31 : 0] INST;             
    wire REG_DST;                   
    wire ALU_SRC;                   
    wire MEM_TO_REG;                
    wire REG_WRITE;                 
    wire MEM_READ;                  
    wire MEM_WRITE;                 
    wire BRANCH;                    
    wire EXT_SIGN;                  
    wire JAL_SIGN;                  
    wire [2 : 0] ALU_OP;            
    wire JUMP;                      
    Ctr main_ctr (
        .opCode(INST[31 : 26]),
        .regDst(REG_DST),
        .aluSrc(ALU_SRC),
        .memToReg(MEM_TO_REG),
        .regWrite(REG_WRITE),
        .memRead(MEM_READ),
        .memWrite(MEM_WRITE),
        .branch(BRANCH),
        .aluOp(ALU_OP),
        .jump(JUMP),
        .extSign(EXT_SIGN),
        .jalSign(JAL_SIGN)
    );
    
    wire [3 : 0] ALU_CTR_OUT;       
    wire SHAMT_SIGN;                
    wire JR_SIGN;                  
    ALUCtr alu_controller (
        .aluOp(ALU_OP),
        .funct(INST[5 : 0]),
        .aluCtrOut(ALU_CTR_OUT),
        .shamtSign(SHAMT_SIGN),
        .jrSign(JR_SIGN)
    );
    
    wire [31 : 0] ALU_INPUT_A;      
    wire [31 : 0] ALU_INPUT_B;      
    wire ALU_OUT_ZERO;              
    wire [31 : 0] ALU_RES;          
    ALU alu (
        .inputA(ALU_INPUT_A),
        .inputB(ALU_INPUT_B),
        .aluCtrOut(ALU_CTR_OUT),
        .zero(ALU_OUT_ZERO),
        .aluRes(ALU_RES)
    );
    
    wire [4 : 0] WRITE_REG;         
    wire [31 : 0] REG_WRITE_DATA;  
    wire [31 : 0] REG_OUT1;         // REG OUTPUT 1 (rs)
    wire [31 : 0] REG_OUT2;         // REG OUTPUT 2 (rt)
    Registers registers (
        .readReg1(INST[25 : 21]),
        .readReg2(INST[20 : 16]),
        .writeReg(WRITE_REG),
        .writeData(REG_WRITE_DATA),
        .regWrite(REG_WRITE & (~JR_SIGN)),
        .clk(clk),
        .reset(reset),
        .readData1(REG_OUT1),
        .readData2(REG_OUT2)
    );

    wire [4 : 0] WRITE_REG_TEMP;    
    RegMux rt_rd_selector (           
        .select(REG_DST),
        .input0(INST[15 : 11]),
        .input1(INST[20 : 16]),
        .out(WRITE_REG_TEMP)
    );
    
    RegMux JAL_REG_selector ( 
        .select(JAL_SIGN),
        .input0(5'b11111),
        .input1(WRITE_REG_TEMP),
        .out(WRITE_REG)
    );
     
    wire [31 : 0] MEM_READ_DATA;    
    dataMemory memory (
        .clk(clk),
        .address(ALU_RES),
        .writeData(REG_OUT2),
        .memWrite(MEM_WRITE),
        .memRead(MEM_READ),
        .readData(MEM_READ_DATA)
    );

    wire [31 : 0] EXT_RES;          
    signext signExt (
        .extSign(EXT_SIGN),
        .inst(INST[15 : 0]),
        .data(EXT_RES)
    );

    wire [31 : 0] PC_IN;            
    wire [31 : 0] PC_OUT;          
    PC pc (
        .pcIn(PC_IN),
        .clk(clk),
        .reset(reset),
        .pcOut(PC_OUT)
    );

    InstMemory inst_memory (
        .address(PC_OUT),
        .inst(INST)
    );
  
    Mux rs_shamt_selector (           
        .select(SHAMT_SIGN),
        .input0({27'b00000000000000000000000000, INST[10 : 6]}),
        .input1(REG_OUT1),
        .out(ALU_INPUT_A)
    );
    
    
    Mux rt_ext_selector (              
        .select(ALU_SRC),
        .input0(EXT_RES),
        .input1(REG_OUT2),
        .out(ALU_INPUT_B)
    );

    wire [31 : 0] REG_WRITE_DATA_TEMP; 
    Mux mem_alu_selector (              
        .select(MEM_TO_REG),
        .input0(MEM_READ_DATA),
        .input1(ALU_RES),
        .out(REG_WRITE_DATA_TEMP)
    );
    
    Mux jal_selector (                 
        .select(JAL_SIGN),
        .input0(PC_OUT + 4),
        .input1(REG_WRITE_DATA_TEMP),
        .out(REG_WRITE_DATA)
    );

    wire [31 : 0] PC_SELECT1;         
    wire [31 : 0] PC_SELECT2;         
    Mux branch_selector (              
        .select(BRANCH & ALU_OUT_ZERO),
        .input0(PC_OUT + 4 + (EXT_RES << 2)),
        .input1(PC_OUT + 4),
        .out(PC_SELECT1)
    );
    
    Mux jump_selector (
        .select(JUMP),
        .input0(((PC_OUT + 4) & 32'hf0000000) + (INST[25 : 0] << 2)),
        .input1(PC_SELECT1),
        .out(PC_SELECT2)
    );
    
    Mux jr_selector (
        .select(JR_SIGN),
        .input0(REG_OUT1),
        .input1(PC_SELECT2),
        .out(PC_IN)

    );
endmodule
