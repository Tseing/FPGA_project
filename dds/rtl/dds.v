module dds(
    input               sys_clk,
    input               sys_rst_n,
    output              da_clk,
    output              da_wrt,
    output      [13:0]  da_data
);

wire            clk_125m;
wire            clk_wave;
wire    [13:0]  data;
reg     [13:0]  addr;

assign da_data = data;
assign da_clk = ~clk_125m;
assign da_wrt = clk_125m;

always @(posedge clk_wave or negedge sys_rst_n) begin
    if(!sys_rst_n)
        addr <= 14'd0;
    else
        addr <= addr + 14'd1;           //1kHz
end

pll u_pll(
    .areset     (~sys_rst_n),
    .inclk0     (sys_clk),
    .c0         (clk_125m),
    .c1         (clk_wave)
);

rom u_rom(
    .clock      (sys_clk),
    .address    (addr),
    .q          (data)
);

endmodule