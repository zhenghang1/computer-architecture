# <p align="center"> lab01 report</p>

<p align="right"> 郑航 520021911347</p>



[toc]



## <p align="center">1	实验目的</p>

+ 掌握 Xilinx 逻辑设计工具 Vivado的基本操作
+ 掌握使用 Verilog HDL进行简单的逻辑设计

+ 掌握功能仿真
+ 使用 1/0 Planing 添加管脚约束
+ 生成 Bitstream 文件
+ 上板验证 

其中下载验证部分暂时不做



## <p align="center">2	实验原理</p>

实现 LED 流水灯，其功能是每间隔一段时间点亮下一个 LED 灯并且熄灭当前的 LED 灯

+ 使用8位的reg类型变量light_reg 表示八个LED灯，第 i 位为 0 说明第 i 个 LED 灯未被点亮；第 i 位为 1 说明第 i 个 LED 灯被点亮。
+ 使用一个reg类型的计数器cnt_reg来记录已经走过的时间周期

由于8位light_reg表示八盏灯的亮暗情况，每个时间都只会有一盏灯亮（一位为1，其他都为0），因此我们可以使用左移1位的操作，使得为1的位周期性左移（左移到最高位后我们就将其重新设置到最低位），如此即可保证灯的周期性亮和灭



## <p align="center">3	实验过程</p>

+ reset：我们的模块需要支持reset功能，当进行reset时，将cnt_reg恢复为0，并将light_reg置为1（第一盏灯）
+ 每次时钟下降沿处，我们检查reset，若reset不为1，则将cnt_reg递增，并更新light_reg（若已经最高位为1，则恢复为最低位为1，否则直接左移一位），我们将对cnt_reg和light_reg的处理分别放在两个always块中，分别进行操作，可以使得代码更加整洁
+ 由于初始设定当cnt_reg达到24‘hffffff时进行light_reg的更新，但这个时间持续时间过长使得还未完整模拟完8盏灯而波形已经提前结束，因此我们修改cnt_reg为2位，当其达到2’b11时即进行light_reg更新

完整代码如下：

~~~verilog
module flowing_light(
    input clock,
    input reset,
    output [7 : 0] led
    );
    
    reg [1 : 0] cnt_reg;
    reg [7 : 0] light_reg;
    
    always @ (posedge clock)
        begin
            if (reset)
                cnt_reg <= 0;
            else
                cnt_reg <= cnt_reg + 1;
        end
    
    always @ (posedge clock)
        begin
            if (reset)
                light_reg <= 8'h01;
            else if (cnt_reg == 2'b11)
                begin
                    if (light_reg == 8'h80)
                        light_reg <= 8'h01;
                    else 
                        light_reg <= light_reg << 1;
                end
        end
    
    assign led = light_reg;
endmodule
~~~

## <p align="center">4	实验结果</p>

实验的仿真结果如图：

![figure1](D:\A 上交\大二下\计算机系统结构\计算机系统结构实验\lab01\figure1.png)



![figure2](D:\A 上交\大二下\计算机系统结构\计算机系统结构实验\lab01\figure2.png)

![figure3](D:\A 上交\大二下\计算机系统结构\计算机系统结构实验\lab01\figure3.png)

![figure4](D:\A 上交\大二下\计算机系统结构\计算机系统结构实验\lab01\figure4.png)

## <p align="center">5	反思总结</p>

​		本实验实现了 FPGA 实验中 LED 流水灯这一基础部件的设计与仿真。基本的代码框架在实验指导书上边已经给出，所以所需要做的就是先自学一些基础的Verilog语法，并根据代码框架对其加以理解，最终实现可以自主进行代码修改以达成所需功能的目的。此外，我还通过本实验，学会了如何进行实验仿真，也通过tb文件理解了仿真的含义，并通过灵活调整界面，设置仿真时长等方式获得较好的仿真效果

​		总之，这是一个学习Verilog很好的开端，也为我后续实验的顺利开展奠定了基础



