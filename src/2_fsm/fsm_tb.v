module fsm_tb;

    reg i_sys_clk;
    reg i_rst_n;
    reg i_data_in;
    wire o_moore_fsm_out;
    wire o_mealy_fsm_out;

    fsm U_fsm (
        .i_sys_clk          (i_sys_clk      ),
        .i_rst_n            (i_rst_n        ),
        .i_data_in          (i_data_in      ),
        .o_moore_fsm_out    (o_moore_fsm_out),
        .o_mealy_fsm_out    (o_mealy_fsm_out)

    );
    
    initial begin
        $fsdbDumpfile ("tb.fsdb");
        $fsdbDumpvars ();
        i_sys_clk = 0;
        i_rst_n = 0;
        i_data_in = 0;
        #200 i_rst_n = 1;
        #200 i_data_in = 1;
        #200 i_data_in = 0;
        #200 i_data_in = 1;
        #200 i_data_in = 0;
        #2000 $stop();
    end

    always #10 i_sys_clk = ~ i_sys_clk;

endmodule 
