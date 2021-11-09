module dds (
    clk,
    reset,
    k,                              //相位增量
    sampling_pulse,                 //采样脉冲
    new_sample_ready,
    sample
);
    input clk, reset, sampling_pulse;
    input [21:0] k;        
    output [15:0] sample;
    output new_sample_ready;

    wire [21:0] raw_addr;           //地址处理输入
    wire [21:0] fulladder_out;      //加法器输出
    wire [9:0]rom_addr;             //ROM地址
    wire [15:0]raw_data;            //ROM数据输出
    wire [15:0]data;                //数据处理输出  
    wire area;                      //sine分区
    //加法器实现相位增量
    fulladder_n #(.n(22)) fulladder1(.a(k), .b(raw_addr), .s(fulladder_out), .ci(0), .co());
    //D寄存器存储得到的相位
    dffre #(.n(22))ff0(.d(fulladder_out), .en(sampling_pulse), .r(reset), .clk(clk), .q(raw_addr));
    //地址处理
    assign rom_addr[9:0] = raw_addr[20]?(raw_addr[20:10]==1024?1023:(~raw_addr[19:10]+1)):raw_addr[19:10];
    //ROM查表
    sine_rom rom1(.clk(clk), .addr(rom_addr), .dout(raw_data));
    //D寄存器得到area分区
    dffre #(.n(1))ff1(.clk(clk), .d(raw_addr[21]), .en(1), .r(0), .q(area));
    //数据处理
    assign data = area?(~raw_data[15:0]+1):raw_data[15:0];
    //D寄存器获得sample
    dffre #(.n(16))ff2(.d(data), .en(sampling_pulse), .r(0), .clk(clk), .q(sample));
    //D寄存器得到new_sample_ready
    dffre #(.n(1))ff3(.d(sampling_pulse), .en(1), .r(0), .clk(clk), .q(new_sample_ready));
endmodule