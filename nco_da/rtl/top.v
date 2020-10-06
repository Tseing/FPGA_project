module top(
    input               sys_clk,
    input               sys_rst_n,
    output              da_clk,
    output              da_wrt,
    output      [13:0]  da_data
);

wire            clk_125m;
wire    [14:0]  oc_sin;
wire    [14:0]  wave_div;
wire    [14:0]  wave;
wire    [14:0]  wave_add;
wire    [14:0]  data;

assign da_clk = ~clk_125m;
assign da_wrt = clk_125m;
assign da_data = data[13:0];

assign wave_div = (oc_sin[14]==1'b0) ? oc_sin : {1'b1, ~(oc_sin[13:0]-1'b1)};       //补码转原码
assign wave = {wave_div[14], 1'b0, wave_div[13:1]};                                 //幅值除以2，原码移位
assign wave_add = (wave[14]==1'b0) ? wave : {1'b1, ~(wave[13:0]-1'b1)};             //原码转补码

pll u_pll(
    .inclk0         (sys_clk),
    .c0             (clk_125m)
);

nco u_nco(
    .phi_inc_i      (8'd131),       //相位增量
    .clk            (sys_clk),
    .reset_n        (sys_rst_n),
    .clken          (1'b1),         //时钟允许信号
    .fsin_o         (oc_sin),       //本振正弦信号
    .out_valid      (out_valid)     //输出有效信号
);

add u_add(
    .dataa          (wave_add),
    .result         (data)
);

endmodule