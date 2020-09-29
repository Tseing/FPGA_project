module hs_dual_da(
    input           sys_clk,
    input           sys_rst_n,
    output          da_clk,
    output  [9:0]   da_data,
    output          da_clk1,
    output  [9:0]   da_data1
);

wire    [9:0]   rd_addr;
wire    [9:0]   rd_data;

assign da_clk1 = da_clk;
assign da_data1 = da_data;

pll u_pll(
    .areset     (~sys_rst_n),
    .inclk0     (sys_clk),
    .c0         (clk)
);

da_wave_send u_da_wave_send(
    .clk        (clk),
    .rst_n      (sys_rst_n),
    .rd_data    (rd_data),
    .rd_addr    (rd_addr),
    .da_clk     (da_clk),
    .da_data    (da_data)
);

rom_1024x10b u_rom_1024x10b(
    .clock      (clk),
    .address    (rd_addr),
    .q          (rd_data)
);

endmodule