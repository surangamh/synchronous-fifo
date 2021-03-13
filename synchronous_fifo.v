module synchronous_fifo # (parameter DWIDTH=16, AWIDTH=4, DEPTH=16)(
input clk,
input reset,
input push,
input [DWIDTH-1:0] in,
input pop,
output [DWIDTH-1:0] out,
output empty,
output almostempty,
output full,
output almostfull,
output reg [AWIDTH:0] num
);

parameter ALMOSTEMPTY=3; // number of items greater than zero
parameter ALMOSTFULL=DEPTH-3; // number of items less than DEPTH
reg weRAM;
reg [DWIDTH-1:0] wdReg;
reg [AWIDTH-1:0] wPtr;
reg [AWIDTH-1:0] rPtr;
wire fifoWrValid;
wire fifoRdValid;

assign empty = num==0?1:0;
assign almostempty =num==ALMOSTEMPTY?1:0;
assign full = num==DEPTH?1:0;
assign almostfull =num==ALMOSTFULL?1:0;
assign fifoWrValid = !full & push;
assign fifoRdValid = !empty & pop;


ram #(.DWIDTH(DWIDTH), .AWIDTH(AWIDTH), .DEPTH(DEPTH)) ram_i(
.clk(clk),
.we(weRAM),
.wa(wPtr),
.wd(wdReg),
.ra(rPtr),
.rd(out)
);

// write enable logic
always @ (posedge clk)
    begin
        if (reset)
        weRAM <= 0;
        else if (fifoWrValid)
        weRAM <= 1;
        else
        weRAM <= 0;       
    end
// write data logic 
always @ (posedge clk)
    begin
        wdReg <= in;     
    end   
// write pointer logic
always @ (posedge clk)
    begin
        if (reset)
            wPtr <= 0;
        else if (weRAM)
            wPtr <= wPtr + 1'b1; 
    end
// read pointer logic
always @ (posedge clk)
    begin
        if (reset)
            rPtr <= 0;
        else if (fifoRdValid)
            rPtr <= rPtr + 1'b1;  
    end  
// count logic
always @ (posedge clk)
    begin
        if (reset)
            num <= 0;
        else if (fifoWrValid&!fifoRdValid)
            num <= num+1;
        else if (fifoRdValid&!fifoWrValid)
            num <= num-1;
    end
endmodule 