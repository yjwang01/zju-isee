module fulladder_n (a, b, s, ci, co);
    parameter n = 4;//加法器位数，默认4位加法器；
    input [n-1:0] a;
    input [n-1:0] b;
    output [n-1:0] s;
    input ci;
    output co;
    wire co;
    integer i;//循环变量
    reg [n-1:0] s;
    reg [n:0] c;//暂存一位加法器的进位；
    assign co = c[n];
    always @(*)
        begin
            c[0] = ci;
            for(i = 0; i <= n-1; i = i+1)
                begin
                    s[i] = a[i]^b[i]^c[i];
                    c[i+1] = a[i]&&b[i] || a[i]&&c[i] || b[i]&&c[i];
                end 
        end
endmodule