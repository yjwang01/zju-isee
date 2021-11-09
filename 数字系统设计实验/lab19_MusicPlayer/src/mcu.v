module mcu (
    clk,        //100MHz时钟信号
    reset,      //复位信号，高电平有效
    play_pause, //来自按键处理模块的“播放/暂停”控制信号，一个时钟周期宽度
    next,       //来自按键处理的“下一首”控制信号，一个时钟周期宽度
    song_done,  //song_reader的应答信号，一个时钟周期宽度的高电平脉冲,表示播放结束
    play,       //输出控制song_reader模块是否播放
    reset_play, //时钟周期宽度的高电平复位脉冲，同时复位song_reader&note_player
    song        //当前播放的乐曲序号
);
    input clk, reset, play_pause, next, song_done;
    output play, reset_play;
    output [1:0] song;

    wire NextSong;  //2位二进制计数器使能信号，next为高电平时改变当前播放乐曲序号
    //mcu控制器
    mcu_ctrl mcu_ctrl1(
        .clk(clk),
        .reset(reset),
        .play_pause(play_pause),
        .next(next),
        .song_done(song_done),
        .play(play),
        .reset_play(reset_play),
        .NextSong(NextSong)
    );
    //歌曲计数器
    counter_n #(.n(4), .counter_bits(2)) song_counter(
        .clk(clk),
        .en(NextSong),
        .r(reset),
        .q(song),
        .co()
    );
endmodule