module mcu_ctrl (
    clk,        
    reset,
    play_pause,
    next,
    song_done,
    play,
    reset_play,
    NextSong
);
    parameter RESET = 0, PLAY = 1, PAUSE = 2, NEXT = 3;
    input clk, reset, play_pause, next, song_done;
    output reg play, reset_play, NextSong;
    reg[1:0] state, nextstate;
    //第一段-时序电路：D寄存器
    always @(posedge clk) begin
        if(reset) state = RESET;
        else state = nextstate;
    end
    //第二段-组合电路：下一状态和输出电路
    always @(*) begin
        play = 0; reset_play = 0;NextSong = 0; //默认为0
        case(state)
            RESET: begin
                reset_play = 1;
                nextstate = PAUSE;
            end
            PAUSE: begin
                if(play_pause) nextstate = PLAY;
                else if(next)    nextstate = NEXT;
                     else nextstate = PAUSE;
            end
            PLAY: begin
                play = 1;
                if(play_pause) nextstate = PAUSE;
                else begin
                    if(next) nextstate = NEXT;
                    else begin
                        if(song_done) nextstate = RESET;
                        else nextstate = PLAY;
                    end
                end 
            end
            NEXT: begin
                NextSong = 1; reset_play = 1;
                nextstate = PLAY;
            end
        endcase
    end
endmodule