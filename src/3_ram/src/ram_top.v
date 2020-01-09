module ram_top # (
     parameter DEPTH = 32
    ,parameter WIDTH = 32
) (
     input              i_sys_clk
    ,input              i_rst_n
    ,input              i_wr
    ,input  [DEPTH-1:0] i_wr_addr
    ,input  [WIDTH-1:0] i_wr_data
    ,input              i_rd
    ,input  [DEPTH-1:0] i_rd_addr
    ,output [WIDTH-1:0] o_rd_data
);

    reg [WIDTH-1:0] mem [DEPTH-1:0];
    reg [WIDTH-1:0] rd_data;
    
    always @ (posedge i_sys_clk) begin
        if (i_wr)
            mem[i_wr_addr] <= i_wr_data;
        else 
            mem[i_wr_addr] <= mem[i_wr_addr];
    end

    always @ (posedge i_sys_clk) begin 
        if (! i_rst_n)
            rd_data <= 0;
        else if (i_rd)
            rd_data <= mem[i_rd_addr];
        else 
            rd_data <= rd_data;
    end

    assign o_rd_data = rd_data;

endmodule 
