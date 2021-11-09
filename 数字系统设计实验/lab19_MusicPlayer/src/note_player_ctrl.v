module note_player_ctrl (
    clk,
    reset,
    play_enable,
    load_new_note,
    note_done,
    load,
    timer_clr,
    timer_done
);
    input clk, reset, play_enable, load_new_note, timer_done;
    output reg timer_clr, note_done, load;
    parameter  RESET = 0, WAIT = 1, DONE = 2, LOAD = 3;
    reg[1:0] state, nextstate;
    //第一段-时序电路：D寄存器
    always @(posedge clk) begin
        if(reset) state = RESET;
        else state = nextstate;
    end
    //第二段-组合电路：下一状态和输出电路
    always @(*) begin
        timer_clr = 0; load = 0; note_done = 0; //默认为0
        case (state)
            RESET:begin
                timer_clr = 1;
                nextstate = WAIT;
            end 
            WAIT:begin
                if(~play_enable) nextstate = RESET;
                else begin
                    if(timer_done) nextstate = DONE;
                    else begin
                        if(load_new_note) nextstate = LOAD;
                        else nextstate = WAIT;
                    end
                end 
            end
            DONE:begin
                timer_clr = 1; note_done = 1;
                nextstate = WAIT;
            end
            LOAD:begin
                timer_clr = 1; load = 1;
                nextstate = WAIT;
            end
        endcase
    end
endmodule