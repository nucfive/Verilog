module memory (
     input              i_sys_clk
    ,input              i_rst_n
    ,input              i_wr
    ,input              i_rd
    ,input      [3:0]   i_wr_addr
    ,input      [3:0]   i_wr_data
    ,input      [3:0]   i_rd_addr
    ,output     [7:0]   o_rd_data
);
    
    reg [7:0] regsiter [3:0];
    reg [7:0] data;
    /* linux 下使用readmem函数不好使
    initial begin
        $readmemh("./data", regsiter);
    end
    */
    always @ (posedge i_sys_clk) begin
        if(!i_rst_n)
            data <= 4'd0;
        else if(i_rd) 
            data <= regsiter[i_rd_addr];
        else 
            data <= data;
    end
        
    assign o_rd_data = data;
    genvar i;
    generate for (i  = 0; i < 4; i = i + 1) begin : FOR
        always @ (posedge i_sys_clk) begin
            if(!i_rst_n) begin 
                // 第一种复位二维数组的方式
                /*
                regsiter[0] <= 0; 
                regsiter[1] <= 1;
                regsiter[2] <= 2;
                regsiter[3] <= 3;
                */
                // 第二种复位方式
                regsiter[i] <= i; 
            end else if(i_wr)
                regsiter[i_wr_addr] <= i_wr_data;
            else 
                regsiter[i_wr_addr] <= regsiter[i_wr_addr];
        end
    end
    endgenerate

endmodule 
