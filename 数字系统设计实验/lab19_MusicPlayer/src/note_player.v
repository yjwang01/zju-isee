module note_player(
    clk,                //时钟信号
    reset,              //复位信号,来自mcu模块的reset_play
    play_enable,        //来自mcu模块的play信号，高电平表示播放
    note_to_load,       //来自song_reader模块的音符标记note
    duration_to_load,   //来自song_reader模块的音符时长duration
    load_new_note,      //来自song_raeder模块的new_note信号，表示音符播放完毕
    note_done,          //给song_reader模块的应答信号，表示音符播放完毕
    sampling_pulse,     //来自同步化电路模块的ready信号，频率48kHz，表示索取新的样品
    beat,               //定时基准信号，频率为48kHz
    sample,             //正弦样品输出
    sample_ready        //下一个正弦信号
);
    input clk, reset, play_enable, load_new_note, sampling_pulse, beat;
    input[5:0] note_to_load, duration_to_load;
    output note_done, sample_ready;
    output[15:0] sample;
    wire load, timer_clr, timer_done;
    wire[5:0] q;
    wire [19:0] dout;
    //控制器
    note_player_ctrl note_player_ctrl1(
        .clk(clk),
        .reset(reset),
        .play_enable(play_enable),
        .load_new_note(load_new_note),
        .note_done(note_done),
        .load(load),
        .timer_clr(timer_clr),
        .timer_done(timer_done)
    );
    //D寄存器
    dffre #(.n(6))ff0(
        .clk(clk),
        .d(note_to_load),
        .en(load),
        .r(~play_enable || reset),
        .q(q)
    );
    //Frequency ROM
    frequency_rom freq1(
        .clk(clk),
        .dout(dout),
        .addr(q)
    ); 
    //DDS
    dds dds1(
        .clk(clk),
        .reset(reset || (~play_enable)),
        .k({2'b00, dout}),
        .sampling_pulse(sampling_pulse),
        .new_sample_ready(sample_ready),
        .sample(sample)
    );
    //音符节拍计时器
    timer #(.n(64), .counter_bits(6))timer1(
        .clk(clk),
        .r(timer_clr),
        .en(beat),
        .count_number(duration_to_load),
        .done(timer_done)
    );
    
endmodule