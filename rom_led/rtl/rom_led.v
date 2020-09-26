module rom_led(
    input               sys_clk,
    input               sys_rst_n,
    output  reg [3:0]   led
);

wire clk_10m;
wire clk_1m;

reg     [13:0]  addr;
reg     [16:0]  counter;
reg     [1:0]   trans_flag;
wire    [3:0]   data;


always @(posedge clk_1m or negedge sys_rst_n) begin
	if (!sys_rst_n)
		counter <= 17'd0;
	else if (counter<17'd999)      //10Hz
		counter <= counter + 17'd1;
	else
        counter <= 17'd0;
end

always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)
        trans_flag <= 2'd0;
    else if(counter==17'd995)
        trans_flag <= 2'd1;
    else
        trans_flag <= 2'd0;
end

always @(posedge clk_10m or negedge sys_rst_n) begin
    if(!sys_rst_n)
        addr <= 14'd0;
    else if(trans_flag)
        addr <= addr + 14'd1;
    else
        addr <= addr;
end

always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)
        led <= 4'd0;
    else
        led <= data;
end

pll u_pll(
    .areset     (~sys_rst_n),
    .inclk0     (sys_clk),
    .c0         (clk_10m),
    .c1         (clk_1m)
);

rom u_rom(
    .address    (addr),
    .clock      (sys_clk),
    .q          (data)
);

endmodule