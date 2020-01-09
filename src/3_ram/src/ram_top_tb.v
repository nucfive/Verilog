`timescale 1ns/1ns
module ram_top_tb;
    
    reg i_sys_clk;
    reg i_rst_n;
    reg i_wr;
    reg [31:0] i_wr_addr;
    reg [31:0] i_wr_data;
    reg i_rd;
    reg [31:0] i_rd_addr;
    reg [8:0] cnt;
    wire [31:0]o_rd_data;

    ram_top # (
        .DEPTH (32),
        .WIDTH (32)
    ) u_ram_top (
        .i_sys_clk (i_sys_clk   ),
        .i_rst_n   (i_rst_n     ),
        .i_wr      (i_wr        ),
        .i_wr_addr (i_wr_addr   ),
        .i_wr_data (i_wr_data   ),
        .i_rd      (i_rd        ),
        .i_rd_addr (i_rd_addr   ),
        .o_rd_data (o_rd_data   )
    );

    initial begin
        $fsdbDumpfile("tb.fsdb");
        $fsdbDumpvars();
        i_sys_clk = 0;
        i_rst_n = 0;
        i_wr = 0;
        i_wr_addr = 0;
        i_wr_data = 0;
        i_rd = 0;
        i_rd_addr = 0;
        #200 i_rst_n = 1;
        #2000 $stop();
    end

    always #10 i_sys_clk = ~ i_sys_clk;
    
    always @ (posedge i_sys_clk) begin
        if (! i_rst_n) 
            cnt <= 0;
        else if (cnt >= 200)
            cnt <= 0;
        else if (cnt <= 199)
            cnt <= cnt + 1;
        else 
            cnt <= cnt;
    end
    // wr
    always @  (posedge i_sys_clk) begin
        if (! i_rst_n)
            i_wr <= 0;
        else if (cnt >= 42)
            i_wr <= 0;
        else if (cnt >= 10) 
            i_wr <= 1;
        else 
            i_wr <= i_wr;
    end

    always @ (posedge i_sys_clk) begin
        if (!i_rst_n)
            i_wr_addr <= 0;
        else if (cnt >= 42)
            i_wr_addr <= 0;
        else if (cnt >= 11)
            i_wr_addr <= i_wr_addr + 1;
        else 
            i_wr_addr <= i_wr_addr;
    end

    always @ (posedge i_sys_clk) begin
        if (!i_rst_n)
            i_wr_data <= 0;
        else if (cnt >= 42)
            i_wr_data <= 0;
        else if (cnt >= 10) 
            i_wr_data <= i_wr_data + 1;
        else 
            i_wr_data <= i_wr_data;
    end
    // rd
    always @  (posedge i_sys_clk) begin
        if (! i_rst_n)
            i_rd <= 0;
        else if (cnt >= 52)
            i_rd <= 0;
        else if (cnt >= 20) 
            i_rd <= 1;
        else 
            i_rd <= i_rd;
    end

    always @ (posedge i_sys_clk) begin
        if (!i_rst_n)
            i_rd_addr <= 0;
        else if (cnt >= 52)
            i_rd_addr <= 0;
        else if (cnt >= 21)
            i_rd_addr <= i_rd_addr + 1;
        else 
            i_rd_addr <= i_rd_addr;
    end

endmodule 
