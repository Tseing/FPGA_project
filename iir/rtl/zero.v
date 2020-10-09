module zero(
    input                   rst_n,
    input                   clk,
    input   signed  [11:0]  Xin,
    output  signed  [24:0]  Xout
);

reg     signed  [11:0]  Xin_reg[1:0];
reg             [3:0]   i, j;

wire    signed  [11:0]  coe[2:0];
assign coe[2] =  12'd1006;
assign coe[1] = -12'd1911;
assign coe[0] =  12'd1006;

wire signed [23:0] mult_reg [2:0];
assign Xout = mult_reg[0] + mult_reg[1] + mult_reg[2];

always @(posedge clk or posedge rst_n) begin
    if (rst_n) begin
        for (i=0; i<2; i=i+1'b1)
            Xin_reg[i] <= 'd0;
    end
    else begin
        for (j=0; j<1; j=j+1'b1)
            Xin_reg[j+1] <= Xin_reg[j];
        Xin_reg[0] <= Xin;
    end
end

multX2 u_multX2(
    .dataa      (Xin),
    .datab      (coe[2]),
    .result     (mult_reg[2])
);

multX1 u_multX1(
    .dataa      (Xin_reg[1]),
    .datab      (coe[1]),
    .result     (mult_reg[1])
);

multX0 u_multX0(
    .dataa      (Xin_reg[0]),
    .datab      (coe[0]),
    .result     (mult_reg[0])
);

endmodule