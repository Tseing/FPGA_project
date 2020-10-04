module dds(
    input               clk_wave,
    input               clk_freq,
    input               sys_rst,
    output  reg [13:0]  addr
);

reg [13:0]  freq_cons;
reg [8:0]   freq_cnt;

always @(posedge clk_wave) begin
        freq_cons <= {5'b00000, freq_cnt[8:0]};
        addr <= addr + freq_cons;                           //100Hz~10kHz
end                                                         //f=kt*f_0

always @(posedge clk_freq or negedge sys_rst) begin
    if(!sys_rst)
        freq_cnt <= 9'd0;
    else if(freq_cnt < 9'd100)
        freq_cnt <= freq_cnt + 9'd1;
    else
        freq_cnt <= 9'd0;
end

endmodule