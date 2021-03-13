module fifo_tb(

    );
    parameter DWIDTH=16; // Data width
    parameter AWIDTH=4; // Address width
    parameter DEPTH=2**AWIDTH; // FIFO depth
    reg clk, reset;
    reg [DWIDTH-1:0] in;
    reg push;
    reg pop;
    wire empty, almostempty, full, almostfull;
    wire [DWIDTH-1:0] out;
    wire [AWIDTH:0] num;
    
    integer i;
    // Create DUT
    synchronous_fifo # (.DWIDTH(DWIDTH), .AWIDTH(AWIDTH), .DEPTH(DEPTH)) dut(
        .clk(clk),
        .reset(reset),
        .in(in),
        .push(push),
        .pop(pop),
        .empty(empty),
        .almostempty(almostempty),
        .full(full),
        .almostfull(almostfull),
        .out(out),
        .num(num)
    );
    
    initial begin
        clk = 0;
        forever begin
            #10 clk = ~clk;
        end
    end
    
    initial begin
    reset = 1'b1;
    pop = 1'b0;
    #15
    push = 1'b1;
    #5;
    reset = 1'b0;
        for (i=0; i<2*DEPTH; i=i+1) begin
            in= i;
            #20;
            if (i==3*DEPTH/2) begin
                pop = 1'b1;
            end
        end
        push = 1'b0;
    end
endmodule


