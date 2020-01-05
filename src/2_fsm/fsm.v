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
