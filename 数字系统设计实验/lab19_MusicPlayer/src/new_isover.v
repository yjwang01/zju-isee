//判断是否结束模块
module is_over (
    clk,
    duration,   //音符长度
    r,          //co与此连接，32个音符是否播放完
    out         //song_done
);
    parameter OVER = 0, PLAY = 1, TEMP = 2;
    input clk, r;
    input [5:0] duration;
    output reg out;
    reg [1:0] state = PLAY, nextstate;
    //第一段-时序电路：D寄存器
    always @(posedge clk) begin
        state = nextstate;
    end
    //第二段-组合电路：下一状态和输出电路
    always @(*) begin
        out = 0;    //默认为0
        case (state)
            OVER:begin
                out = 1;
                if(r) nextstate = OVER;
                else begin
                    if(duration) nextstate = PLAY;
                    else  nextstate = TEMP;    
                end
            end 
            PLAY:begin
                if(duration == 0 || r) begin nextstate = OVER; end
                else begin
                    nextstate = PLAY;
                end
            end
            TEMP:begin
                if(r) nextstate = OVER;
                else begin
                    if(duration != 0) nextstate = PLAY; 
                    else nextstate = TEMP;                    
                end
            end
            default: nextstate = TEMP;
        endcase
    end
endmodule