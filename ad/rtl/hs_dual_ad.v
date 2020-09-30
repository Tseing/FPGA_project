module hs_dual_ad(
    input           sys_clk,

    input   [9:0]   ad0_data,
    input           ad0_otr,
    output          ad0_clk,
    output          ad0_oe,

    input   [9:0]   ad1_data,
    input           ad1_otr,
    output          ad1_clk,
    output          ad1_oe
);

wire clk_out;
wire clk_test;

assign ad0_oe = 1'b0;               //低电平有效
assign ad1_oe = 1'b0;               //低电平有效
assign ad0_clk = ~clk_out1;
assign ad1_clk = ~clk_out1;

pll u_pll(
    .inclk0     (sys_clk),
    .c0         (clk_out1),
    .c1         (clk_test)
);

endmodule