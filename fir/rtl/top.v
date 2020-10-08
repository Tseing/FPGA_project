module top(
    input                   sys_clk,
    input                   sys_rst_n,
    input           [9:0]   data_in,
    output  signed  [24:0]  data_out,
    output                  ad_clk,
    output                  ad_oe
);

wire            [1:0]   source_error;
wire                    source_valid;
wire                    sink_ready;
wire                    sink_valid;
wire            [11:0]  data;

wire    signed  [10:0]  data_sub;
wire    signed  [10:0]  data_qsub;
wire            [9:0]   data_o;/*synthesis keep*/
wire            [10:0]  data_mult;/*synthesis keep*/

assign sink_valid = 1'b1;
assign ad_clk = ~sys_clk;
assign ad_oe = 1'b0;


// //data_in转数据格式，扩位转signed
assign data_sub = {1'b0, data_in[9:0]};
assign data_o = (data_qsub[10]==1'b0) ? data_qsub[9:0] : ~data_qsub[9:0]+1'b1;  //去符号原码，10bit

fircore u_fircore(
    .clk                (sys_clk),
    .reset_n            (sys_rst_n),
    .ast_sink_data      (data),                 //I，输入数据
    .ast_sink_valid     (sink_valid),           //I，置1时向FIR输入数据
    .ast_source_ready   (1'b1),                 //I，源准备
    .ast_sink_error     (2'd0),                 //I，标识错误
    .ast_source_data    (data_out),             //O，输出信号
    .ast_sink_ready     (sink_ready),
    .ast_source_valid   (souce_valid),          //O，输出信号有效时置位
    .ast_source_error   (source_error)          //O，标识错误
);

sub u_sub(
    .dataa          (data_sub),         //data_sub - 512 11bit
    .result         (data_qsub)
);

trans u_trans(
    .clk            (sys_clk),
    .rst_n          (sys_rst_n),
    .data_o         (data_o),
    .data_qsub      (data_qsub),
    .data           (data)
);

endmodule