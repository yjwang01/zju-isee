module song_reader (
    clk,                //100MHz时钟信号
    reset,              //复位信号，高电平有效
    play,               //来自mcu的控制信号，高电平有效
    song,               //来自mcu的控制信号，当前播放歌曲的序号
    note_done,          //note_player的应答信号，表示一个音符播放结束并索取新音符
    song_done,          //给mcu的应答信号，当乐曲播放结束，输出一个时钟周期宽度的脉冲，表示乐曲播放结束
    note,               //音符标记
    duration,           //音符的持续时间
    new_note            //给模块note_player的控制信号，表示新的音符需播放
);
    input clk, reset, play, note_done;
    input [1:0] song;
    output song_done, new_note;
    output [5:0] note, duration;

    wire[4:0] q;        //歌曲音符地址（五位）
    wire co;            //歌曲结束信号
    //控制器
    song_reader_ctrl song_reader1(
        .clk(clk),
        .reset(reset),
        .note_done(note_done),
        .play(play),
        .new_note(new_note)
    );
    //地址计数器
    counter_n #(.n(32), .counter_bits(5))song_choose(
        .clk(clk),
        .en(note_done),
        .r(reset),
        .q(q),
        .co(co)
    );
    //song_rom
    song_rom song1(
        .clk(clk),
        .dout({note[5:0], duration[5:0]}),
        .addr({song[1:0],q[4:0]})
    );
    //结束判断
    is_over is_over1(
        .clk(clk),
        .duration(duration),
        .r(co),
        .out(song_done)
    );
endmodule