module top(
    input                   sys_clk,
    input                   sys_rst_n,
    input           [9:0]   data_in,
    output  signed          data_out
);

wire    signed  [10:0]  data_sub;
wire    signed  [10:0]  data_qsub;
wire            [9:0]   data_o;
wire            [10:0]  data_mult;
wire            [11:0]  data;
wire    signed  [11:0]  Din;
wire    signed  [11:0]  Dout;
wire    signed  [11:0]  Yin;
wire    signed  [23:0]  Xout;
wire    signed  [23:0]  Yout;
wire    signed  [24:0]  Ysum;
wire    signed  [24:0]  Ydiv;

assign Din = data;
assign data_out = Dout;

assign Ysum = Xout - Yout;
assign Ydiv = {{10{Ysum[24]}}, Ysum[24:10]};
assign Yin = rst ? 1'd0 : Ydiv[11:0];
assign Dout = Yin;

// //data_in转数据格式，扩位转signed
assign data_sub = {1'b0, data_in[9:0]};
assign data_o = (data_qsub[10]==1'b0) ? data_qsub[9:0] : ~data_qsub[9:0]+1'b1;  //去符号原码，10bit

assign Din = data;
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

trans u_trans(
    .clk        (sys_clk),
    .rst_n      (sys_rst_n),
    .data_o     (data_o),
    .data_qsub  (data_qsub),
    .data       (data)          //12bit
);


endmodule