module top(
    input           sys_clk,
    input           sys_rst_n,
    input   [9:0]   din,            //输入信号
    output  [9:0]   s_oc,           //本振信号，625kHz
    output          out_valid,      //nco输出有效信号
    output  [19:0]  dout            //混频输出
);

wire            [9:0]   oc_sin;
wire    signed  [19:0]  mult;
assign s_oc = oc_sin;

mixer u_mixer(
    .clk            (clk),
    .rst_n          (sys_rst_n),
    .mult           (mult),
    .dout           (dout)
);

nco u_nco(
    .phi_inc_i      (16'd8192),     //相位增量，对应625kHz
    .clk            (clk),
    .reset_n        (sys_rst_n),
    .clken          (1'b1),         //时钟允许信号
    .fsin_o         (oc_sin),       //本振正弦信号
    .out_valid      (out_valid)     //输出有效信号
);

mult1 u_mult1(
    .dataa          (din),
    .datab          (oc_sin),
    .result         (mult)
);

pll u_pll(
    .inclk0         (sys_clk),
    .c0             (clk)
);

endmodule