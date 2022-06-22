`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2022/04/11 15:34:05
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


module Top(
           input clk,
           input reset
       );

// IF
reg [31 : 0] PC;
wire [31 : 0] IF_INST;

InstMemory inst_memory(.address(PC), .inst(IF_INST));

// Segment Registers IF_ID
wire [31 : 0] IF_ID_INST;
wire [31 : 0] IF_ID_PC;
wire [12 : 0] ID_CTR;
wire [3 : 0] ID_CTR_SIGNAL_ALUOP;
wire BRANCH;
wire STALL;
IFID_REG ifid(.clock(clk),.reset(reset),.stall(STALL),.branch(BRANCH),.ctr_signals_In(ID_CTR[12:11]),
              .pcIn(PC),.instIn(IF_INST),.pcOut(IF_ID_PC),.instOut(IF_ID_INST));

// ID
Ctr main_controller(.opCode(IF_ID_INST[31 : 26]), .funct(IF_ID_INST[5 : 0]), .nop(IF_ID_INST == 0),
                    .jump(ID_CTR[12]), .jrSign(ID_CTR[11]), .extSign(ID_CTR[10]),
                    .regDst(ID_CTR[9]), .jalSign(ID_CTR[8]), .aluOp(ID_CTR_SIGNAL_ALUOP),
                    .aluSrc(ID_CTR[7]), .luiSign(ID_CTR[6]), .beqSign(ID_CTR[5]),
                    .bneSign(ID_CTR[4]), .memWrite(ID_CTR[3]), .memRead(ID_CTR[2]),
                    .memToReg(ID_CTR[1]), .regWrite(ID_CTR[0]));

wire [31 : 0] ID_REG_READ_DATA_1;
wire [31 : 0] ID_REG_READ_DATA_2;
wire [4 : 0] WB_WRITE_REG;
wire [31 : 0] WB_REG_WRITE_DATA;
wire WB_CTR_SIGNAL_REG_WRITE;
Registers registers(.readReg1(IF_ID_INST[25 : 21]), .readReg2(IF_ID_INST[20 : 16]),
                    .writeReg(WB_WRITE_REG), .writeData(WB_REG_WRITE_DATA),
                    .regWrite(WB_CTR_SIGNAL_REG_WRITE), .clk(clk), .reset(reset),
                    .jalSign(ID_CTR[8]), .jalDest(IF_ID_PC + 4),
                    .readData1(ID_REG_READ_DATA_1), .readData2(ID_REG_READ_DATA_2));

wire [31 : 0] ID_EXT_RES;
signext SignExt(.extSign(ID_CTR[10]), .inst(IF_ID_INST[15 : 0]), .data(ID_EXT_RES));

wire [4 : 0] ID_REG_DEST;
RegMux rt_rd_mux(.select(ID_CTR[9]),
                 .input0(IF_ID_INST[15 : 11]),
                 .input1(IF_ID_INST[20 : 16]),
                 .out(ID_REG_DEST));

// Segment Registers ID_EX
wire [31 : 0] ID_EX_PC;
wire [31 : 0] ID_EX_REG_READ_DATA_1;
wire [31 : 0] ID_EX_REG_READ_DATA_2;
wire [31 : 0] ID_EX_EXT_RES;
wire [3 : 0] ID_EX_CTR_SIGNAL_ALUOP;
wire [7 : 0] ID_EX_CTR;
wire [4 : 0] ID_EX_REG_DEST;
wire [4 : 0] ID_EX_INST_RT;
wire [4 : 0] ID_EX_INST_RS;
wire [5 : 0] ID_EX_INST_FUNCT;
wire [4 : 0] ID_EX_INST_SHAMT;
IDEX_REG idex(.clock(clk),.reset(reset),.stall(STALL),.branch(BRANCH),.pcIn(IF_ID_PC),.instIn(IF_ID_INST),
              .dataIn1(ID_REG_READ_DATA_1),.dataIn2(ID_REG_READ_DATA_2),.extendIn(ID_EXT_RES),
              .rdIn(ID_REG_DEST),.aluop_in(ID_CTR_SIGNAL_ALUOP),.ctr_signal_in(ID_CTR),.pcOut(ID_EX_PC),
              .dataOut1(ID_EX_REG_READ_DATA_1),.dataOut2(ID_EX_REG_READ_DATA_2),
              .extendOut(ID_EX_EXT_RES),.aluop_out(ID_EX_CTR_SIGNAL_ALUOP),
              .ctr_signal_out(ID_EX_CTR),.rdOut(ID_EX_REG_DEST),
              .inst16_20Out(ID_EX_INST_RT),.inst21_25Out(ID_EX_INST_RS),
              .inst0_5Out(ID_EX_INST_FUNCT),.inst6_10Out(ID_EX_INST_SHAMT)
             );

// stall
assign STALL = ((ID_EX_INST_RT == IF_ID_INST [25 : 21]) | (ID_EX_INST_RT == IF_ID_INST [20 : 16])) & ID_EX_CTR[2] ;

// Ex
wire [3 : 0] EX_ALU_CTR_OUT;
wire EX_SHAMT_SIGNAL;
ALUCtr alu_controller(.aluOp(ID_EX_CTR_SIGNAL_ALUOP), .funct(ID_EX_INST_FUNCT),
                      .aluCtrOut(EX_ALU_CTR_OUT), .shamtSign(EX_SHAMT_SIGNAL));

//Forwarding wires
wire [31 : 0] EX_ALU_INPUT_1_FORWARDING;
wire [31 : 0] EX_ALU_INPUT_2_FORWARDING;

wire [31 : 0] EX_ALU_INPUT_1;
wire [31 : 0] EX_ALU_INPUT_1_TEMP;
wire [31 : 0] EX_ALU_INPUT_2;
Mux rs_forward_mux(.select(EX_SHAMT_SIGNAL),
                   .input0({27'b00000000000000000000000000, ID_EX_INST_SHAMT}),
                   .input1(EX_ALU_INPUT_1_FORWARDING),
                   .out(EX_ALU_INPUT_1_TEMP));

Mux rs_lui_mux(.select(ID_EX_CTR[6]),
               .input0(32'h00000010),
               .input1(EX_ALU_INPUT_1_TEMP),
               .out(EX_ALU_INPUT_1));

Mux rt_forward_mux(.select(ID_EX_CTR[7]),
                   .input0(ID_EX_EXT_RES),
                   .input1(EX_ALU_INPUT_2_FORWARDING),
                   .out(EX_ALU_INPUT_2));

wire EX_ZERO;
wire [31 : 0] EX_ALU_RES;
ALU alu(.inputA(EX_ALU_INPUT_1), .inputB(EX_ALU_INPUT_2),
        .aluCtrOut(EX_ALU_CTR_OUT), .zero(EX_ZERO),
        .aluRes(EX_ALU_RES));

wire [31 : 0] BRANCH_DEST = ID_EX_PC + 4 + (ID_EX_EXT_RES * 4);

// predict-not-taken
wire BRANCH_CON_1 = ID_EX_CTR[5] & EX_ZERO;
wire BRANCH_CON_2 = ID_EX_CTR[4] & (~ EX_ZERO);
assign BRANCH = BRANCH_CON_1 | BRANCH_CON_2;
wire [31 : 0] PC_NEW;
Jump_Ctr jump_ctr(.ctr_signals(ID_CTR[12:11]),.pc_jump_In(((IF_ID_PC + 4) & 32'hf0000000) + (IF_ID_INST [25 : 0] * 4)),
                  .pc_In(PC + 4),.data(ID_REG_READ_DATA_1),.beq_signal(BRANCH_CON_1),.bne_signal(BRANCH_CON_2),
                  .branch_dest(BRANCH_DEST),.pcOut(PC_NEW));

// Segment Registers EXMA
wire [3 : 0] EX_MA_CTR;
wire [31 : 0] EX_MA_ALU_RES;
wire [31 : 0] EX_MA_REG_READ_DATA_2;
wire [4 : 0] EX_MA_REG_DEST;
EXMA_REG exma(.clock(clk),.reset(reset),.aluResIn(EX_ALU_RES),.ctr_signals_In(ID_EX_CTR [3 : 0]),
              .readData2In(EX_ALU_INPUT_2_FORWARDING),.regdestIn(ID_EX_REG_DEST),
              .aluResOut(EX_MA_ALU_RES),.ctr_signals_Out(EX_MA_CTR),.readData2Out(EX_MA_REG_READ_DATA_2),
              .regdestOut(EX_MA_REG_DEST));

// MA
wire [31 : 0] MA_MEM_READ_DATA;
dataMemory data_memory(.clk(clk), .address(EX_MA_ALU_RES), .writeData(EX_MA_REG_READ_DATA_2),
                       .memWrite(EX_MA_CTR[3]), .memRead(EX_MA_CTR[2]),
                       .readData(MA_MEM_READ_DATA));

wire [31 : 0] MA_DATA;
Mux reg_mem_mux(.select(EX_MA_CTR[1]),
                .input0(MA_MEM_READ_DATA),
                .input1(EX_MA_ALU_RES),
                .out(MA_DATA));

// Segment Registers MA_WB
wire [31 : 0] MA_WB_DATA;
wire MA_WB_CTR;
wire [4 : 0] MA_WB_REG_DEST;
MAWB_REG mawb(.clock(clk),.reset(reset),.memDataIn(MA_DATA),.ctr_signals_In(EX_MA_CTR[0]),
              .regdestIn(EX_MA_REG_DEST),.memDataOut(MA_WB_DATA),
              .ctr_signals_Out(MA_WB_CTR),.regdestOut(MA_WB_REG_DEST));

// forwarding mux
Forward forward_1(.select1(MA_WB_CTR & (MA_WB_REG_DEST == ID_EX_INST_RS)),.select2(EX_MA_CTR[0] & (EX_MA_REG_DEST == ID_EX_INST_RS)),
                  .data1(MA_WB_DATA),.data2(ID_EX_REG_READ_DATA_1),.alures(EX_MA_ALU_RES),.out(EX_ALU_INPUT_1_FORWARDING));

Forward forward_2(.select1(MA_WB_CTR & (MA_WB_REG_DEST == ID_EX_INST_RT)),.select2(EX_MA_CTR[0] & (EX_MA_REG_DEST == ID_EX_INST_RT)),
                  .data1(MA_WB_DATA),.data2(ID_EX_REG_READ_DATA_2),.alures(EX_MA_ALU_RES),.out(EX_ALU_INPUT_2_FORWARDING));

// WB
assign WB_WRITE_REG = MA_WB_REG_DEST;
assign WB_REG_WRITE_DATA = MA_WB_DATA;
assign WB_CTR_SIGNAL_REG_WRITE = MA_WB_CTR;


always @(posedge clk) begin
    if (!STALL)
        PC <= PC_NEW;
end

initial
    PC = 0;
endmodule
