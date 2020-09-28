module dds(
    input               sys_clk,
    input               sys_rst_n,
    output              da_clk,
    output              da_wrt,
    output      [13:0]  da_data
);

wire            clk_125m;
wire    [13:0]  data;
reg     [13:0]  addr;

assign da_data = data;
assign da_clk = clk_125m;
assign da_wrt = clk_125m;

always @(posedge clk_125m or negedge sys_rst_n) begin
    if(!sys_rst_n)
        addr <= 14'd0;
    else
        addr <= addr + 14'd1;
end

pll u_pll(
    .areset     (~sys_rst_n),
    .inclk0     (sys_clk),
    .c0         (clk_125m)
);

rom u_rom(
    .clock      (clk_125m),
    .address    (addr),
    .q          (data)
);

endmodule