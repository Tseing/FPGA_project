module pole(
    input                   clk,
    input                   rst_n,
    input   signed  [11:0]  Yin,
    output  signed  [24:0]  Yout
);

reg     signed  [11:0]  Yin_reg[1:0];
reg             [3:0]   i, j;

wire    signed  [11:0]  coe[2:0];
//assign coe[2] =  12'd1024;
assign coe[1] = -12'd1911;
assign coe[0] =  12'd986;

wire signed [23:0] mult_reg [1:0];
assign Yout = mult_reg[0] + mult_reg[1];

always @(posedge clk or posedge rst_n) begin
    if (rst_n) begin
        for (i=0; i<2; i=i+1'b1)
            Yin_reg[i] <= 'd0;
    end
    else begin
        for (j=0; j<1; j=j+1'b1)
            Yin_reg[j+1] <= Yin_reg[j];
        Yin_reg[0] <= Yin;
    end
end


multY0 u_multY0(
    .dataa      (Yin_reg[0]),
    .datab      (coe[0]),
    .result     (mult_reg[0])
);

multY1 u_multY1(
    .dataa      (Yin_reg[1]),
    .datab      (coe[1]),
    .result     (mult_reg[1])
);

endmodule