//同步器
module synch(clk, synch_in, synch_out);
    input clk, synch_in;
    output synch_out;
    
    wire q0, q1;
    dffre ff0(.clk(clk), .en(1), .r(0), .d(synch_in), .q(q0));
    dffre ff1(.clk(clk), .en(1), .r(0), .d(q0), .q(q1));
    assign synch_out = (~q1) && q0;
endmodule
