module top(
    input                   sys_clk,
    input                   sys_rst_n,
    input           [9:0]   data_in,
    output  signed  [24:0]  amp,
    output                  ad_clk,
    output                  ad_oe
);


wire                    inverse;            //I，为1时进行IFFT，为0时进行FFT
wire                    sink_ready;         //O，FFT准备好接受数据时置位
wire                    source_ready;       //I,下传流模块可接受数据时置位
wire                    sink_valid;         //I，有效标记，sin_valid和sink_ready都置位时开始传输
wire                    sink_sop;           //I，高电平表示1帧数据载入开始
wire                    sink_eop;           //I，高电平表示1帧数据载入结束
wire    signed  [11:0]  sink_imag;          //I，输入数据的虚部，二进制补码
wire            [1:0]   sink_error;         //I，表示载入数据状态，一般置0
wire            [1:0]   source_error;       //O，表示FFT出现的错误
wire                    source_sop;         //O，高电平表示1帧数据转换开始
wire                    source_eop;         //O，高电平表示1帧数据转换结束
wire            [5:0]   source_exp;
wire                    source_valid;
wire    signed  [11:0]  data;/*synthesis keep*/
wire    signed  [11:0]  xkre;               //O，输出数据的实部，二进制补码数据
wire    signed  [11:0]  xkim;               //O，输出数据的虚部

wire    signed  [10:0]  data_sub;
wire    signed  [10:0]  data_qsub;


wire                    clk_out;
wire                    clk_test;

wire            [9:0]   data_o;/*synthesis keep*/
wire            [10:0]  data_mult;/*synthesis keep*/

// //data_in转数据格式，扩位转signed
assign data_sub = {1'b0, data_in[9:0]};
assign data_o = (data_qsub[10]==1'b0) ? data_qsub[9:0] : ~data_qsub[9:0]+1'b1;  //去符号原码，10bit


assign sink_error = 2'b00;
assign source_ready = 1'b1;
assign inverse = 1'b0;                      //FFT正变换
assign sink_imag = 11'd0;                   //输入数据虚部接地

assign ad_oe = 1'b0;
assign ad_clk = ~clk_out;


wire    signed  [23:0]  xkre_square, xkim_square;
assign xkre_square = xkre * xkre;
assign xkim_square = xkim * xkim;
assign amp = xkre_square + xkim_square;

trans u_trans(
    .clk            (sys_clk),
    .rst_n          (sys_rst_n),
    .data_o         (data_o),
    .data_qsub      (data_qsub),
    .data           (data)
);

cnt u_cnt(
    .clk            (sys_clk),
    .rst_n          (sys_rst_n),
    .sink_sop       (sink_sop),
    .sink_eop       (sink_eop),
    .sink_valid     (sink_valid)
);

fftcore u_fftcore(
    .clk            (sys_clk),
    .reset_n        (sys_rst_n),
    .sink_valid     (sink_valid),
    .sink_ready     (sink_ready),
    .sink_error     (sink_error),
    .sink_sop       (sink_sop),
    .sink_eop       (sink_eop),
    .sink_real      (data),
    .sink_imag      (sink_imag),

    .inverse        (inverse),
    .source_valid   (source_valid),
    .source_ready   (source_ready),
    .source_error   (source_error),
    .source_sop     (source_sop),
    .source_eop     (source_eop),
    .source_exp     (source_exp),
    .source_real    (xkre),
    .source_imag    (xkim)
);

pll u_pll(
    .inclk0         (sys_clk),
    .c0             (clk_out),          //50MHz
    .c1             (clk_test)          //125MHz
);

sub u_sub(
    .dataa          (data_sub),         //data_sub - 512
    .result         (data_qsub)
);


endmodule