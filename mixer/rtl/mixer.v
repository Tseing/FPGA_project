module mixer(
    input       clk,
    input       rst_n,
    input       mult,
    output      dout
);

reg     signed  [19:0]  m1, m2, m3, m4, m5, m6, m7;
wire    signed  [22:0]  madd = mult + m1 + m2 + m3 + m4 + m5 + m6 + m7;
wire    signed  [19:0]  mean = madd[22:3];
wire    signed  [19:0]  mt = mult - mean;
assign dout = mt;

always @(posedge clk or negedge rst_n)
    if(!rst_n)  begin
        m1 <= 20'd0;
        m2 <= 20'd0;
        m3 <= 20'd0;
        m4 <= 20'd0;
        m5 <= 20'd0;
        m6 <= 20'd0;
        m7 <= 20'd0;
    end
    else begin
        m1 <= mult;
        m2 <= m1;
        m3 <= m2;
        m4 <= m3;
        m5 <= m4;
        m6 <= m5;
        m7 <= m6;
    end

endmodule