module top(
    input               sys_clk,
    input               sys_rst_n,
    output              da_clk,
    output              da_wrt,
    output      [13:0]  da_data
);

wire            clk_125m;
wire            clk_wave;
wire            clk_freq;
wire    [13:0]  data;
wire    [13:0]  addr;


assign da_data = data;
assign da_clk = ~clk_125m;
assign da_wrt = clk_125m;


pll u_pll(
    .areset     (~sys_rst_n),
    .inclk0     (sys_clk),
    .c0         (clk_125m),
    .c1         (clk_wave),
    .c2         (clk_freq)
);

rom u_rom(
    .clock      (sys_clk),
    .address    (addr),
    .q          (data)
);

dds u_dds(
    .clk_wave   (clk_wave),         //1.638MHz
    .clk_freq   (clk_freq),         //2kHZ
    .sys_rst    (sys_rst_n),
    .addr       (addr)
);

endmodule