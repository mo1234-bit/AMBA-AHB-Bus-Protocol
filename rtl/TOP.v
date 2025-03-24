module top #(parameter DATA_WIDTH=32,ADDR_WIDTH=32,SLAVE_NUM=4, HBURST_WIDTH=3)(
	input HRST,
	input HCLK,
	input enable,
	input [DATA_WIDTH-1:0]HWRITE_i,
	input[ADDR_WIDTH-1:0]HADDR_i,
	input [$clog2(SLAVE_NUM)-1:0]SEL,
	input [2:0]HSIZE_i,
	input HWRITE_e_i,
    input [HBURST_WIDTH-1:0]HBURST_i,
//output signals
    output  [DATA_WIDTH-1:0]DATA_o,
    output HREADYOUT,
    output RESP_o);
    
    wire HREADY;
    wire HRESP;
    wire HRESP1;
    wire HRESP2;
    wire HRESP3;
    wire HRESP4;
    wire HREADYOUT1;
    wire HREADYOUT2;
    wire HREADYOUT3;
    wire HREADYOUT4;
    wire [DATA_WIDTH-1:0]HRDATA1;
    wire [DATA_WIDTH-1:0]HRDATA2;
    wire [DATA_WIDTH-1:0]HRDATA3;
    wire [DATA_WIDTH-1:0]HRDATA4;
    wire [$clog2(SLAVE_NUM)-1:0]HSEL;
    wire HSEL_1;
    wire HSEL_2;
    wire HSEL_3;
    wire HSEL_4;
    wire [$clog2(SLAVE_NUM)-1:0]Multiplexor_SEL;
    wire HREQ;
    wire [ADDR_WIDTH-1:0]HADDR_o;
    wire HWRITE_o;
    wire [2:0]HSIZE_o;
    wire [3:0]HPROT;
    wire [1:0]HTRANS;
    wire [HBURST_WIDTH-1:0]HBURST;
    wire HMASTERLOCK;
    wire [DATA_WIDTH-1:0]HRdata_i;
    wire HREADYOUT_m;
    assign HREADYOUT=HREADYOUT_m;
    assign RESP_o=HRESP;
    wire [DATA_WIDTH-1:0]HWDATA_o;
 master dut1 ( HRST,
	 HCLK,
	 HREADYOUT_m,
	 enable,
	 HWRITE_i,
	 HRdata_i,
	 HADDR_i,
	 SEL,
	 HSIZE_i,
	 HRESP,
	 HWRITE_e_i,
     HBURST_i,
//output signals

	 HREADY,
	 HREQ,
	 HSEL,
	 HADDR_o,
	 HWDATA_o,
	 HSIZE_o,
	 HPROT,
	 HTRANS,
	 HBURST,
	 HMASTERLOCK,
     HWRITE_o,
     DATA_o

	);

 decoder du2(HSEL,
	HSEL_1,
	HSEL_2,
	HSEL_3,
	HSEL_4,
    Multiplexor_SEL);

 slave slave1( HCLK,
 HRST,
 HSEL_1,
  HADDR_o,
 HWRITE_o,
 HSIZE_o,
 HBURST,
 HPROT,
 HTRANS,
 HMASTERLOCK,
 HREADY,
 HWDATA_o,
 HREADYOUT1,
 HRESP1,
 HRDATA1);

 slave slave2( HCLK,
 HRST,
 HSEL_2,
  HADDR_o,
 HWRITE_o,
 HSIZE_o,
 HBURST,
 HPROT,
 HTRANS,
 HMASTERLOCK,
 HREADY,
 HWDATA_o,
 HREADYOUT2,
 HRESP2,
 HRDATA2);

 slave slave3( HCLK,
 HRST,
 HSEL_3,
  HADDR_o,
 HWRITE_o,
 HSIZE_o,
 HBURST,
 HPROT,
 HTRANS,
 HMASTERLOCK,
 HREADY,
 HWDATA_o,
 HREADYOUT3,
 HRESP3,
 HRDATA3);

 slave slave4( HCLK,
 HRST,
 HSEL_4,
  HADDR_o,
 HWRITE_o,
 HSIZE_o,
 HBURST,
 HPROT,
 HTRANS,
 HMASTERLOCK,
 HREADY,
 HWDATA_o,
 HREADYOUT4,
 HRESP4,
 HRDATA4);

 multiplexor dut3(HRDATA1,
	HRDATA2,
	HRDATA3,
	HRDATA4,
     HRESP1,
	 HRESP2,
	HRESP3,
	HRESP4,
	HREADYOUT1,
	HREADYOUT2,
	HREADYOUT3,
	HREADYOUT4,
	Multiplexor_SEL,
	HRdata_i,
	HREADYOUT_m,
	HRESP
 	);

endmodule
