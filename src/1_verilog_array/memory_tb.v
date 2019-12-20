`timescale 1ns/1ns
module memory_tb;
    reg i_sys_clk;
    reg i_rst_n;
    reg i_wr;
    reg i_rd;
    reg [3:0] i_wr_addr;
    reg [3:0] i_wr_data;
    reg [3:0] i_rd_addr;
    wire [7:0] o_rd_data;
    
    memory u_memory (
        .i_sys_clk  (i_sys_clk  ),
        .i_rst_n    (i_rst_n    ),
        .i_wr       (i_wr       ),
        .i_rd       (i_rd       ),
        .i_wr_addr  (i_wr_addr  ),
        .i_wr_data  (i_wr_data  ),
        .i_rd_addr  (i_rd_addr  ),
        .o_rd_data  (o_rd_data  )
    );
    
    initial begin
        $fsdbDumpfile("tb.fsdb");
        $fsdbDumpvars();
        i_sys_clk = 0;
        i_rst_n = 0;
        i_wr = 0;
        i_rd = 0;
        i_wr_addr = 0;
        i_wr_data = 0;
        i_rd_addr = 0;
        #200 i_rst_n = 1;
        #30000 $stop();
    end

    always #10 i_sys_clk = !i_sys_clk;

    reg [31:0] cnt;
    
    always @ (posedge i_sys_clk) begin
        if(!i_rst_n)
            cnt <= 0;
        else if(cnt <= 100)
            cnt <= cnt + 1;
        else if(cnt > 100)
            cnt <= 0;
        else 
            cnt <= cnt;
    end
    
    always @ (posedge i_sys_clk) begin
        if(!i_rst_n)
            i_wr <= 1'b0;
        else if(cnt == 2)
            i_wr <= 1;
        else if(cnt == 6)
            i_wr <= 0;
        else if(cnt == 10)
            i_wr <= 1;
        else 
            i_wr <= i_wr;
    end
    /*
    always @ (posedge i_sys_clk) begin
        if(!i_rst_n)
            i_wr_addr <= 0;
        else if(cnt >= 6)
            i_wr_addr <= 0;
        else if(cnt >= 3)
            i_wr_addr <= i_wr_addr + 1;
        else 
            i_wr_addr <= i_wr_addr;
    end

    always @ (posedge i_sys_clk) begin
        if(!i_rst_n)
            i_wr_data <= 0;
        else if(cnt >= 6)
            i_wr_data <= 0;
        else if(cnt >= 3)
            i_wr_data <= i_wr_data + 1;
        else 
            i_wr_data <= i_wr_data;
    end
    */
    always @ (posedge i_sys_clk) begin
        if(!i_rst_n)
            i_rd_addr <= 0;
        else if(cnt >= 11)
            i_rd_addr <= 0;
        else if(cnt >= 7)
            i_rd_addr <= i_rd_addr + 1;
        else 
            i_rd_addr <= i_rd_addr;
    end

    always @ (posedge i_sys_clk) begin
        if(!i_rst_n)
            i_rd <= 0;
        else if(cnt == 6)
            i_rd <= 1;
        else if(cnt == 11)
            i_rd <= 0;
        else 
            i_rd <= i_rd;
    end

endmodule
