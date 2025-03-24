module master #(parameter DATA_WIDTH=32,ADDR_WIDTH=32,SLAVE_NUM=4,HPROT_SIZE=4, HBURST_WIDTH=3)
(
//input signals

	input Hrst,
	input Hclk,
	input HReadyout,
	input enable,
	input [DATA_WIDTH-1:0]HWRITE_i,
	input [DATA_WIDTH-1:0]HRdata_i,
	input[ADDR_WIDTH-1:0]HADDR_i,
	input [$clog2(SLAVE_NUM)-1:0]SEL,
	input [2:0]HSIZE_i,
	input HRESP,
	input wr,
    input [HBURST_WIDTH-1:0]HBURST_i,
//output signals

	output reg HREADY,
	output reg HREQ,
	output reg [$clog2(SLAVE_NUM)-1:0]HSEL,
	output reg [ADDR_WIDTH-1:0]HADDR_o,
	output reg [DATA_WIDTH-1:0]HWRITE_o,
	output reg [2:0]HSIZE_o,
	output reg [HPROT_SIZE-1:0]HPROT,
	output  [1:0]HTRANS,
	output reg [HBURST_WIDTH-1:0]HBURST,
	output reg HMASTERLOCK,  // hardwired to zero becouse there is no need for it becouse we use one master
    output reg HWRITE,
    output reg [DATA_WIDTH-1:0]DATA_o

	);
parameter IDLE=2'b00;
parameter READY=2'b01;
parameter WRITE=2'b10;
parameter READ=2'b11;
reg[1:0]cs,ns;
assign HTRANS=cs;
always @(posedge Hclk ) begin
	if (~Hrst) begin
		cs<=IDLE;
		
	end
	else  begin
		cs<=ns;
	end
end

always@(cs,enable,wr)begin
	case(cs)
	IDLE:begin
		if(enable)
		ns=READY;
		else 
		ns=IDLE;
	end

	READY:begin
	if(wr&&enable)
	ns=WRITE;
	else if(~wr&&enable)
	ns=READ;
	else
	ns=IDLE;
	end

	WRITE:begin
	if(enable)
	ns=READY;
	else 
	ns=IDLE;
end

	READ:begin
	if(enable)
	ns=READY;
	else 
	ns=IDLE;
	end
	endcase
end

always @(posedge Hclk ) begin
	if (~Hrst) begin
	HREADY<=0;
	HREQ<=0;
	HSEL<=0;
	HADDR_o<=0;
    HWRITE_o<=0;
	HSIZE_o<=0;
	HPROT<=0;
	HBURST<=0;
    HMASTERLOCK<=0;
    HWRITE<=0;
    DATA_o<=0;
		
	end else begin
	case(ns)
	IDLE:begin
	HADDR_o<=HADDR_i;
	HSEL<=SEL;
	HPROT<=4'b0011; // we don't use any protection so we  sets HPROT to 0011 to correspond to a Non-cacheable, Non-bufferable, privileged, data access.
	end

	READY:begin
	HADDR_o<=HADDR_i;
	HSEL<=SEL;
    HWRITE<=wr;
    HBURST<=HBURST_i;
    HREQ<=1;
    HREADY<=1;
    HWRITE_o<=HWRITE_i;
    
	end

	WRITE:begin
	 HWRITE<=wr;
    HBURST<=HBURST_i;
    HREQ<=1;
    HREADY<=1;
    HWRITE_o<=HWRITE_i;
	end

	READ:
	begin
	HADDR_o<=HADDR_i;
	HSEL<=SEL;
		 HWRITE<=wr;
    HBURST<=HBURST_i;
    HREQ<=1;
    HREADY<=1;
    HSIZE_o<=HSIZE_i;
    DATA_o<=HRdata_i;
	end
	endcase
	end
end
endmodule


