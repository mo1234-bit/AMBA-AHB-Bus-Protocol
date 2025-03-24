module test ();
reg Hrst,Hclk,HReady,enable;
	reg [31:0]HWRITE_i,HRdata_i;
	reg[31:0]HADDR_i;
	reg [$clog2(4)-1:0]SEL;
	reg [2:0]HSIZE_i;
	reg HRESP;
    reg wr;

	wire  HREADY,HREQ;
	wire  [$clog2(4)-1:0]HSEL;
	wire  [31:0]HADDR_o;
	wire  [31:0]HWRITE_o;
	wire  [2:0]HSIZE_o;
	wire  [3:0]HPROT;
	wire  [1:0]HTRANS;
	wire  [2:0]HBURST;
	wire  HMASTERLOCK;
    wire  HWRITE;
    wire  [31:0]DATA_o;

    master dut ( Hrst,Hclk,HReady,enable,
	HWRITE_i,HRdata_i,
	HADDR_i,
	SEL,
	HSIZE_i,
	HRESP,
	wr,

//output signals

	HREADY,HREQ,
	HSEL,
	HADDR_o,
	HWRITE_o,
    HSIZE_o,
	HPROT,
	HTRANS,
	HBURST,
	HMASTERLOCK,
    HWRITE,
    DATA_o
);
    initial begin
    	Hclk=0;
    	forever 
    	#1 Hclk=~Hclk;
    end

    initial begin
    	Hrst=0;
    	@(negedge Hclk);
    	Hrst=1;
    	enable=1;
    	wr=1;
    	HWRITE_i=32'h2A;
    	HADDR_i=32'h4A;
    	SEL=2'b10;
    	@(negedge Hclk);
    	HWRITE_i=32'h2A;
    	HRdata_i=32'h8E;
    	HSIZE_i=2'b10;
    	@(negedge Hclk);
    	@(negedge Hclk);
    	wr=0;
    	HADDR_i=32'h4C;
    	SEL=2'b11;
    	@(negedge Hclk);
    	@(negedge Hclk);
    	@(negedge Hclk);
      $stop;
    end 
    endmodule
