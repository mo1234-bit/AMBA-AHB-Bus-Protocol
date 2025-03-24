module top_test();
parameter DATA_WIDTH=32,ADDR_WIDTH=32,SLAVE_NUM=4, HBURST_WIDTH=3;

	reg HRST;
	reg HCLK;
	reg enable;
	reg [DATA_WIDTH-1:0]HWRITE_i;
	reg[ADDR_WIDTH-1:0]HADDR_i;
	reg [$clog2(SLAVE_NUM)-1:0]SEL;
	reg [2:0]HSIZE_i;
	reg HWRITE_e_i;
    reg [HBURST_WIDTH-1:0]HBURST_i;
//wire signals
    wire  [DATA_WIDTH-1:0]DATA_o;
    wire HREADYOUT;
    wire RESP;
    top dut( HRST,
	 HCLK,
	 enable,
	 HWRITE_i,
	HADDR_i,
	 SEL,
	 HSIZE_i,
	 HWRITE_e_i,
     HBURST_i,
// signals
     DATA_o,
     HREADYOUT,
     RESP);
    initial begin
    	HCLK=0;
    	forever  
    	#1 HCLK=~HCLK;
    end
    initial begin
    	HRST=0;
    	@(negedge HCLK);
    	HRST=1;
    	enable=1;
    	HWRITE_i=32'd1000;
    	HSIZE_i=2;
    	SEL=0;
    	HADDR_i=32'd5;
    	@(negedge HCLK);
    	SEL=0;
    	HWRITE_e_i=1;
    	HBURST_i=0;
        repeat(2)@(negedge HCLK);
        enable=0;
        @(negedge HCLK);
        enable=1;
        HWRITE_e_i=0;
        repeat(4)@(negedge HCLK);
         enable=0;
        @(negedge HCLK);
        enable=1;
        HWRITE_e_i=1;
        HSIZE_i=0;
        repeat(4)@(negedge HCLK);
        enable=0;
        @(negedge HCLK);
        enable=1;
        HWRITE_e_i=0;
        repeat(4)@(negedge HCLK);
          enable=0;
        @(negedge HCLK);
        enable=1;
        HWRITE_e_i=1;
        HSIZE_i=2;
        HBURST_i=1;
        repeat(8)@(negedge HCLK);
        SEL=1;
         enable=0;
        @(negedge HCLK);
         SEL=0;
        enable=1;
        HWRITE_e_i=0;
        repeat(8)@(negedge HCLK);
        $stop;
    end
    endmodule