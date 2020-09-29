module da_wave_send(
    input               clk,
    input               rst_n,
    input       [9:0]   rd_data,
    output  reg [9:0]   rd_addr,
    output              da_clk,
    output      [9:0]   da_data
);

assign da_clk = ~clk;
assign da_data = rd_data;

always @(posedge clk or negedge rst_n) begin
    if(rst_n==1'b0)
        rd_addr <= 10'd0;
    else
        rd_addr <= rd_addr + 10'd10;
end

endmodule