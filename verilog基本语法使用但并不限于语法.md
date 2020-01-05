# Verilog 语法但并不限于语法

==<font  color = "blue" size = 5 face = "kaiti">写在前面的话, 上次写verilog是在2017年年初，2017年3月到2019年3月学习了两年C++，由于某些原因，离开了原来的团队，现在要继续做verilog，目前做芯片FPGA原型验证，转回verilog，写本文的目的有两点,1、重新捡起来verilog，2、在芯片设计中，有些语句的用法和在xilinx中的用法是不同的，特此记录！</font>==

## 1、verilog中数组的用法

<font size = 5 face = "kaiti">在verilog中，常用的类型有wire类型和reg类型，其中wire类型一般用于assign语句中，我曾经的写法是端口全部声明成wire类型，模块内部使用用reg类型和端口用assgin连接上，把数据送出去。在verilog中，还支持数组定义，<font size = 5 face = "kaiti" color = "red">数组类型源于reg类型，相当于用一群寄存器实现一个ram或者rom，最简单的理解就是看成一堆寄存器堆叠</font> </font>

```verilog
// 二维数组的声明
reg [width - 1 : 0] name [num - 1 : 0];
// 前面的 [width - 1 : 0] 表示每一行的寄存器的位宽，后面的 [num - 1 : 0] 表示有num个位宽为[width - 1 : 0]的寄存器
// 举例
reg [7:0] regsiter [3:0];// 表示有4组个寄存器，每一组寄存器的位宽是8bit，其中regsiter[0],regsiter[1],regsiter[2],regsiter[3]表示四组8bit位宽寄存器，而且他们是连续的
//二位寄存器在fpga中和在ic设计中初始化的方式不同
//在fpga中初始化可以使用initial语句和readmemb or readmemh两个函数并配合一个数据文件，具体用法如下
initial begin
    $readmemh("data.txt", regsiter);	
end
// 在ic设计中，只能用代码去描述数组初始化，有两种方式
// first:单独给每一组赋值
always @ (posedge i_sys_clk) begin
    if(!i_rst_n) begin 
        // 第一种复位二维数组的方式
                regsiter[0] <= 0; 
                regsiter[1] <= 1;
                regsiter[2] <= 2;
                regsiter[3] <= 3;
               
    end
end
//second : 在generate模块中赋值
genvar i;
generate for (i  = 0; i < 4; i = i + 1) begin : FOR
	always @ (posedge i_sys_clk) begin
		if(!i_rst_n) begin 
           regsiter[i] <= i; 
        end
    end
end
endgenerate
```

<font size = 5 face = "kaiti">波形如下:</font>

![](I:\Work\svn_path\verilog\image\1-数组复位只读波形.PNG)



<font size = 5 face = "kaiti">摩尔机和米勒机框图</font>

![](I:\Work\svn_path\verilog\image\摩尔机和米勒机原理框图.PNG)

```verilog
module fsm (
     input         i_sys_clk
    ,input         i_rst_n
    ,input         i_data_in
    ,output        o_moore_fsm_out
    ,output        o_mealy_fsm_out
);

    reg next_state;
    reg current_state;
    reg next_state_moore;
    reg current_state_moore;
    reg moore_fsm_out;
    reg mealy_fsm_out;

    assign o_moore_fsm_out = moore_fsm_out;
    assign o_mealy_fsm_out = mealy_fsm_out;

    // mealy fsm
    always @ (posedge i_sys_clk or negedge i_rst_n) begin
        if(! i_rst_n)
            current_state <= 0;
        else 
            current_state <= next_state;
    end
    
    always @ (*) begin
        if(! i_rst_n) begin
            mealy_fsm_out = 0;
            next_state = 0;
        end else begin
            case (current_state)
                0 : begin
                        if (i_data_in) begin
                            next_state = 1;
                            mealy_fsm_out = 1;
                        end else begin
                            next_state = 0;
                            mealy_fsm_out = 0;
                        end
                    end
                1 : begin
                        next_state = 0;
                        mealy_fsm_out = 0;
                    end
                default : begin
                            next_state = 0;
                            mealy_fsm_out = 0;
                          end
            endcase
        end
    end

    // moore fsm

    always @ (posedge i_sys_clk or negedge i_rst_n) begin
        if (! i_rst_n) begin
            current_state_moore <= 0;
       end else
            current_state_moore <= next_state_moore;
    end
    
    always @ (*) begin
        if (! i_rst_n) 
            next_state_moore <= 0;
        else begin
            case (current_state_moore)
                0 : begin
                        if(i_data_in) 
                            next_state_moore <= 1;
                        else 
                            next_state_moore <= 0;
                    end   
                1 : begin
                        next_state_moore <= 0;
                    end
                default : next_state_moore <= 0;
            endcase 
        end
    end

    always @ (*) begin
        if(! i_rst_n)
            moore_fsm_out = 0;
        else begin
            case (current_state_moore)
                0 : moore_fsm_out = 1;
                1 : moore_fsm_out = 0;
                default : moore_fsm_out = 0;
            endcase
        end
    end

endmodule 
```

<font size = 5 face = "kaiti">波形如下:</font>

<img src="I:\Work\svn_path\verilog\image\摩尔机和米勒机仿真图像.PNG" style="zoom:150%;" />



































