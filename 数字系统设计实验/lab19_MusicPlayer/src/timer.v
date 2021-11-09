module timer(clk, r, en, done, count_number);
    parameter n = 2;
    parameter counter_bits=1; //参数counter_bits表示计数的位数
    input clk, r, en;
    input[counter_bits-1:0] count_number;
    output done;
    reg [counter_bits-1:0] q;

    assign done = (q == count_number-1);
    always @(posedge clk)
        begin
            if(r) q = 0;
            else if(en) q = q+1;
                 else q = q;
        end
endmodule