module music_player (
    clk, 
    reset,
    play_pause,
    next,
    NewFrame,
    sample,
    play,
    song		
);
    parameter sim = 0;
    input clk, reset, play_pause, next, NewFrame;
    output[15:0] sample;
    output play;
    output[1:0] song;
    wire reset_play, song_done, new_note, note_done, ready, beat, sample_ready;
    wire [5:0] note, duration;
    //主控制器
    mcu mcu1(
		.clk(clk), 
		.reset(reset), 
		.play_pause(play_pause), 
		.next(next), 
		.play(play), 
		.song(song), 
		.reset_play(reset_play), 
		.song_done(song_done)
	);
    //song_reader
    song_reader song_reader1(
        .clk(clk),
        .reset(reset_play),
        .play(play),
        .song(song),
        .song_done(song_done),
        .note(note),
        .duration(duration),
        .new_note(new_note),
        .note_done(note_done)
    );
    //note_player
    note_player note_player1(
        .clk(clk), 
		.reset(reset_play), 
		.play_enable(play), 
		.note_to_load(note), 
		.duration_to_load(duration), 
		.note_done(note_done), 
		.load_new_note(new_note), 
		.beat(beat), 
		.sampling_pulse(ready), 
		.sample(sample), 
		.sample_ready(sample_ready)
    );
    //synchronizer
    synch synch1(
        .clk(clk),
        .synch_in(NewFrame),
        .synch_out(ready)
    );
    //节拍基准产生器 分频器
    counter_n #(.n(sim?64:1000), .counter_bits(sim?6:10))div1(
        .clk(clk),
        .en(ready),
        .r(0),
        .q(),
        .co(beat)
    );
endmodule
