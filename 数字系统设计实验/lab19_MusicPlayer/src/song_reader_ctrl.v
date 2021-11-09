module song_reader_ctrl (
    clk,
    reset,
    note_done,
    play,
    new_note
);
    input clk, reset, note_done, play;
    output reg new_note;
    parameter RESET = 0, NEW_NOTE = 1, WAIT = 2, NEXT_NOTE = 3;
    reg [1:0] state , nextstate;
    //第一段-时序电路：D寄存器
    always @(posedge clk) begin
        if(reset) state = RESET;
        else state = nextstate;
    end
    //第二段-组合电路：下一状态和输出电路
    always @(*) begin
        new_note = 0; //默认为0
        case (state)
            RESET: begin
                if(play) nextstate = NEW_NOTE;
                else nextstate = RESET;
            end
            NEW_NOTE: begin
               new_note = 1;
               nextstate = WAIT; 
            end
            WAIT: begin
                if(!play) nextstate = RESET;
                else if(note_done) nextstate = NEXT_NOTE;
                     else nextstate = WAIT; 
            end
            NEXT_NOTE: begin
                nextstate = NEW_NOTE;
            end
        endcase
    end
endmodule