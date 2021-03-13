module ram #(parameter DWIDTH=16,AWIDTH= 4, DEPTH=16)(
input clk,
input we, //write enable              
input [AWIDTH-1:0] wa, // write address
input [DWIDTH-1:0] wd, // write data
input [AWIDTH-1:0] ra, // read address
output reg [DWIDTH-1:0] rd // read data
);

reg [DWIDTH-1:0]mem[DEPTH-1:0];

// memeroy write
always @(posedge clk)
begin
     if(we)
          mem[wa] <= wd;
end

//memory read
always @(posedge clk)
    rd <= mem[ra];
endmodule