module testss();
reg HCLK;
reg HRST;
reg HSELx;
reg [32-1:0] HADDR;
reg HWRITE;
reg [1:0]HSIZE;
reg [3-1:0]HBURST;
reg [4-1:0]HPROT;
reg [1:0]HTRANS;
reg HMASTERLOCK;
reg HREADY;
reg [32-1:0]HWDATA;

wire HREADYOUT;
wire HRESP;
wire [32-1:0]HRDATA;

slave dut2( HCLK,
 HRST,
 HSELx,
 HADDR,
 HWRITE,
 HSIZE,
 HBURST,
 HPROT,
 HTRANS,
 HMASTERLOCK,
 HREADY,
 HWDATA,
 HREADYOUT,
 HRESP,
 HRDATA);

initial begin
	HCLK=0;
	forever 
	#1 HCLK=~HCLK;
end
initial begin
	HRST=0;
	@(negedge HCLK);
	HRST=1;
	HSELx=1;
	HADDR=32'd5;
    HWRITE=1;
    HSIZE=0;
    HBURST=0;
    HPROT=0;
    HTRANS=0;
    HMASTERLOCK=0;
    HWDATA=32'd45;
    HREADY=1;
    repeat(2)@(negedge HCLK);
    HSELx=0;
    @(negedge HCLK);
    HSELx=1;
    HADDR=32'd6;
    HBURST=1;
    HWDATA=32'd80;
    repeat(6)@(negedge HCLK);
    HSELx=0;
    @(negedge HCLK);
    HSELx=1;
    HADDR=32'd6;
    HBURST=0;
    HWRITE=0;
    repeat(3)@(negedge HCLK);

$stop;
end
endmodule

