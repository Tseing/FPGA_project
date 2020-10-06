module cnt(
    input           clk,
    input           rst_n,
    output          sink_sop,
    output          sink_eop,
    output          sink_valid
);

reg [10:0]  count;
reg         sop;
reg         eop;
reg         valid;

assign sink_sop = sop;
assign sink_eop = eop;
assign sink_valid = valid;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        eop <= 1'b0;
        sop <= 1'b0;
        valid <= 1'b0;
        count <= 11'b0;
    end
    else begin
        count <= count + 11'b1;
        if(count==11'b1)
            sop <= 1'b1;
        else
            sop <= 1'b0;

        if(count==11'd512)
            eop <= 1'b1;
        else
            eop <= 1'b0;

        if(count>=11'd1 & count <=11'd512)
            valid <= 1'b1;
        else
            valid <= 1'b0;
    end
end

endmodule