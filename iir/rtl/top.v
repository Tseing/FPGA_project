module top(
    input                   sys_clk,
    input                   sys_rst_n,
    input           [9:0]   data_in,
    output  signed          data_out
);

zero u_zero(
    .clk        (sys_clk),
    .rst_n      (sys_rst_n),
    .Xin        (Din),
    .Xout       (Xout)
);

pole u_pole(
    .clk        (sys_clk),
    .rst_n      (sys_rst_n),
    .Yin        (Yin),
    .Yout       (Yout)
);

endmodule