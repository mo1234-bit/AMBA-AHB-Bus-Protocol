module slave#(parameter DATA_WIDTH=32,ADDR_WIDTH=32,HPROT_SIZE=4, HBURST_WIDTH=3)(
input HCLK,
input HRST,
input HSELx,
input [ADDR_WIDTH-1:0] HADDR,
input HWRITE,
input [2:0]HSIZE,
input [HBURST_WIDTH-1:0]HBURST,
input [HPROT_SIZE-1:0]HPROT,
input [1:0]HTRANS,
input HMASTERLOCK,
input HREADY,
input [DATA_WIDTH-1:0]HWDATA,

output reg HREADYOUT,
output reg HRESP,
output reg [DATA_WIDTH-1:0]HRDATA
	);

parameter IDLE=2'b00;
parameter READY=2'b01;
parameter WRITE=2'b10;
parameter READ=2'b11;
    
    parameter BYTE=8;
    parameter HALFWORD=16;
    parameter WORD=32;
    reg HREADYOUT_buf;
    reg[ADDR_WIDTH-1:0]WR_ADDR,RD_ADDR;
    reg single_flag;
    reg incr_flag;
    reg wrap4_flag;
    reg incr4_flag;
    reg wrap8_flag;
    reg incr8_flag;
    reg wrap16_flag;
    reg incr16_flag;
    wire[7:0]BURST_MODE;
    reg[DATA_WIDTH-1:0]HRDATA_BUF;

    assign BURST_MODE ={single_flag,incr_flag,wrap4_flag,incr4_flag,wrap8_flag,incr8_flag,wrap16_flag,incr16_flag} ;

reg [DATA_WIDTH-1:0]mem[31:0];
reg[1:0]cs,ns;

always @(posedge HCLK) begin
	if (!HRST) begin
		cs<=0;
		
	end
	else begin
		cs<=ns;
	end
end

always@(*)begin
	case(cs)
	IDLE:begin
	 single_flag=0;
     incr_flag=0;
     wrap4_flag=0;
     incr4_flag=0;
     wrap8_flag=0;
    incr8_flag=0;
     wrap16_flag=0;
     incr16_flag=0;
     if(HSELx==1)
     ns=READY;
     else
     	ns=IDLE;
     end

     READY:begin
     case(HBURST)
     3'b000:begin
     single_flag=1;
     incr_flag=0;
     wrap4_flag=0;
     incr4_flag=0;
     wrap8_flag=0;
     incr8_flag=0;
     wrap16_flag=0;
     incr16_flag=0;
     end
     3'b001:begin
     single_flag=0;
     incr_flag=1;
     wrap4_flag=0;
     incr4_flag=0;
     wrap8_flag=0;
     incr8_flag=0;
     wrap16_flag=0;
     incr16_flag=0;
     end
     3'b010:begin
     single_flag=0;
     incr_flag=0;
     wrap4_flag=1;
     incr4_flag=0;
     wrap8_flag=0;
     incr8_flag=0;
     wrap16_flag=0;
     incr16_flag=0;
     end
     3'b011:begin
     single_flag=0;
     incr_flag=0;
     wrap4_flag=0;
     incr4_flag=1;
     wrap8_flag=0;
     incr8_flag=0;
     wrap16_flag=0;
     incr16_flag=0;
     end
     3'b100:begin
     single_flag=0;
     incr_flag=0;
     wrap4_flag=0;
     incr4_flag=0;
     wrap8_flag=1;
     incr8_flag=0;
     wrap16_flag=0;
     incr16_flag=0;
     end
     3'b101:begin
     single_flag=0;
     incr_flag=0;
     wrap4_flag=0;
     incr4_flag=0;
     wrap8_flag=0;
     incr8_flag=1;
     wrap16_flag=0;
     incr16_flag=0;
     end
     3'b110:begin
     single_flag=0;
     incr_flag=0;
     wrap4_flag=0;
     incr4_flag=0;
     wrap8_flag=0;
     incr8_flag=0;
     wrap16_flag=1;
     incr16_flag=0;
     end
     3'b111:begin
     single_flag=0;
     incr_flag=0;
     wrap4_flag=0;
     incr4_flag=0;
     wrap8_flag=0;
     incr8_flag=0;
     wrap16_flag=0;
     incr16_flag=1;
     end
     endcase
     if(HWRITE&&HREADY)
     ns=WRITE;
     else  if(~HWRITE&&HREADY)
     ns=READ;
     else if(HSELx)
     ns=READY;
     else 
     ns=IDLE;
     end 
     WRITE:begin     
     case(HBURST)
     3'b000:begin
     single_flag=1;
     incr_flag=0;
     wrap4_flag=0;
     incr4_flag=0;
     wrap8_flag=0;
     incr8_flag=0;
     wrap16_flag=0;
     incr16_flag=0;
      if(HSELx)
     ns=READY;
     else  
     ns=IDLE;
     end
     3'b001:begin
     single_flag=0;
     incr_flag=1;
     wrap4_flag=0;
     incr4_flag=0;
     wrap8_flag=0;
     incr8_flag=0;
     wrap16_flag=0;
     incr16_flag=0; 
     if(HSELx)
     ns=WRITE;
     else  
     ns=IDLE;
    end
     3'b010:begin  
     single_flag=0;
     incr_flag=0;
     wrap4_flag=1;
     incr4_flag=0;
     wrap8_flag=0;
     incr8_flag=0;
     wrap16_flag=0;
     incr16_flag=0;
     if(HSELx)
     ns=WRITE;
     else  
     ns=IDLE;end  
     3'b011:begin
     single_flag=0;
     incr_flag=0;
     wrap4_flag=0;
     incr4_flag=1;
     wrap8_flag=0;
     incr8_flag=0;
     wrap16_flag=0;
     incr16_flag=0;
     if(HSELx)
     ns=WRITE;
     else  
     ns=IDLE;end
     3'b100:begin
     single_flag=0;
     incr_flag=0;
     wrap4_flag=0;
     incr4_flag=0;
     wrap8_flag=1;
     incr8_flag=0;
     wrap16_flag=0;
     incr16_flag=0;
     if(HSELx)
     ns=WRITE;
     else  
     ns=IDLE;end
     3'b101:begin
     single_flag=0;
     incr_flag=0;
     wrap4_flag=0;
     incr4_flag=0;
     wrap8_flag=0;
     incr8_flag=1;
     wrap16_flag=0;
     incr16_flag=0;
     if(HSELx)
     ns=WRITE;
     else  
     ns=IDLE;end 
     3'b110:begin
     single_flag=0;
     incr_flag=0;
     wrap4_flag=0;
     incr4_flag=0;
     wrap8_flag=0;
     incr8_flag=0;
     wrap16_flag=1;
     incr16_flag=0;
     if(HSELx)
     ns=WRITE;
     else  
     ns=IDLE;end
     3'b111:begin 
     single_flag=0;
     incr_flag=0;
     wrap4_flag=0;
     incr4_flag=0;
     wrap8_flag=0;
     incr8_flag=0;
     wrap16_flag=0;
     incr16_flag=1;
     if(HSELx)
     ns=WRITE;
     else  
     ns=IDLE;end
     endcase
     end

     READ:begin     
     case(HBURST)
     3'b000:begin
     single_flag=1;
     incr_flag=0;
     wrap4_flag=0;
     incr4_flag=0;
     wrap8_flag=0;
     incr8_flag=0;
     wrap16_flag=0;
     incr16_flag=0; 
     if(HSELx)
     ns=READY;
     else  
     ns=IDLE;end
     3'b001:begin
     single_flag=0;
     incr_flag=1;
     wrap4_flag=0;
     incr4_flag=0;
     wrap8_flag=0;
     incr8_flag=0;
     wrap16_flag=0;
     incr16_flag=0;
     if(HSELx)
     ns=READ;
     else  
     ns=IDLE;
      end
     3'b010:begin
     single_flag=0;
     incr_flag=0;
     wrap4_flag=1;
     incr4_flag=0;
     wrap8_flag=0;
     incr8_flag=0;
     wrap16_flag=0;
     incr16_flag=0;
     if(HSELx)
     ns=READ;
     else  
     ns=IDLE;end
     3'b011:begin
     single_flag=0;
     incr_flag=0;
     wrap4_flag=0;
     incr4_flag=1;
     wrap8_flag=0;
     incr8_flag=0;
     wrap16_flag=0;
     incr16_flag=0;
     if(HSELx)
     ns=READ;
     else  
     ns=IDLE;end
     3'b100:begin
     single_flag=0;
     incr_flag=0;
     wrap4_flag=0;
     incr4_flag=0;
     wrap8_flag=1;
     incr8_flag=0;
     wrap16_flag=0;
     incr16_flag=0;
     if(HSELx)
     ns=READ;
     else  
     ns=IDLE;end
     3'b101:begin
     single_flag=0;
     incr_flag=0;
     wrap4_flag=0;
     incr4_flag=0;
     wrap8_flag=0;
     incr8_flag=1;
     wrap16_flag=0;
     incr16_flag=0;
     if(HSELx)
     ns=READ;
     else  
     ns=IDLE;end
     3'b110:begin
     single_flag=0;
     incr_flag=0;
     wrap4_flag=0;
     incr4_flag=0;
     wrap8_flag=0;
     incr8_flag=0;
     wrap16_flag=1;
     incr16_flag=0;
     if(HSELx)
     ns=READ;
     else  
     ns=IDLE;end
     3'b111:begin
     single_flag=0;
     incr_flag=0;
     wrap4_flag=0;
     incr4_flag=0;
     wrap8_flag=0;
     incr8_flag=0;
     wrap16_flag=0;
     incr16_flag=1;
     if(HSELx)
     ns=READ;
     else  
     ns=IDLE;end
     endcase
     end
     default:begin
     single_flag=1;
     incr_flag=0;
     wrap4_flag=0;
     incr4_flag=0;
     wrap8_flag=0;
     incr8_flag=0;
     wrap16_flag=0;
     incr16_flag=0;
     ns=0;end
     endcase
     end

always@(posedge HCLK)begin
	if(~HRST)begin
	HREADYOUT_buf<=0;
    HRESP<=0;
    HRDATA_BUF<=0;
    WR_ADDR<=0;
    RD_ADDR<=0;
    end else begin
    case(ns)
    IDLE:begin
    HREADYOUT_buf<=0;
    HRESP<=0;
    HREADYOUT<=HREADYOUT_buf;
    end 
    READY: begin
    HREADYOUT_buf<=0 ;
    HRESP<=0;
    WR_ADDR<=HADDR;
    RD_ADDR<=HADDR;
    HREADYOUT<=HREADYOUT_buf;
    end
    WRITE:begin
    case(BURST_MODE)
    8'b10000000:begin
    HREADYOUT_buf<=1;
    HRESP<=0;
    mem[WR_ADDR]<=HWDATA;
    end 
     8'b01000000:begin
    HREADYOUT_buf<=1;
    HRESP<=0;
    mem[WR_ADDR]<=HWDATA;
    WR_ADDR<=WR_ADDR+1;
    end 
     8'b00100000:begin
    HREADYOUT_buf<=1;
    HRESP<=0;
    if(WR_ADDR<HADDR+3)begin
    mem[WR_ADDR]<=HWDATA;
    WR_ADDR<=WR_ADDR+1;
    end else begin
    	mem[WR_ADDR]<=HWDATA;

    end 

    end 
     8'b00010000:begin
    HREADYOUT_buf<=1;
    HRESP<=0;
    mem[WR_ADDR]<=HWDATA;
    WR_ADDR<=WR_ADDR+1;
    end 
     8'b00001000:begin
    HREADYOUT_buf<=1;
    HRESP<=0;
    
    if(WR_ADDR<HADDR+7)begin
    mem[WR_ADDR]<=HWDATA;
    WR_ADDR<=WR_ADDR+1;
    end else begin
    	mem[WR_ADDR]<=HWDATA;

    end 
    end 
     8'b00000100:begin
    HREADYOUT_buf<=1;
    HRESP<=0;
    mem[WR_ADDR]<=HWDATA;
     WR_ADDR<=WR_ADDR+1;
    end 
     8'b00000010:begin
    HREADYOUT_buf<=1;
    HRESP<=0;
    if(WR_ADDR<HADDR+15)begin
    mem[WR_ADDR]<=HWDATA;
    WR_ADDR<=WR_ADDR+1;
    end else begin
    	mem[WR_ADDR]<=HWDATA;

    end 
    end 
     8'b00000001:begin
    HREADYOUT_buf<=1;
    HRESP<=0;
    mem[WR_ADDR]<=HWDATA;
    WR_ADDR<=WR_ADDR+1;
    end 
    endcase
    HREADYOUT<=HREADYOUT_buf;
    end

    READ:begin
    case(BURST_MODE)
    8'b10000000:begin
    HREADYOUT_buf<=1;
    HRESP<=0;
    HRDATA_BUF<=mem[RD_ADDR];
    end 
     8'b01000000:begin
    HREADYOUT_buf<=1;
    HRESP<=0;
    HRDATA_BUF<=mem[RD_ADDR];
    RD_ADDR<=RD_ADDR+1;
    end 
     8'b00100000:begin
    HREADYOUT_buf<=1;
    HRESP<=0;
    if(WR_ADDR<HADDR+3)begin
    HRDATA_BUF<=mem[RD_ADDR];
    RD_ADDR<=RD_ADDR+1;
    end else begin
    	HRDATA_BUF<=mem[RD_ADDR];

    end 

    end 
     8'b00010000:begin
    HREADYOUT_buf<=1;
    HRESP<=0;
    HRDATA_BUF<=mem[RD_ADDR];
    RD_ADDR<=RD_ADDR+1;
    end 
     8'b00001000:begin
    HREADYOUT_buf<=1;
    HRESP<=0;
    
    if(WR_ADDR<HADDR+7)begin
    HRDATA_BUF<=mem[RD_ADDR];
    RD_ADDR<=RD_ADDR+1;
    end else begin
    	HRDATA_BUF<=mem[RD_ADDR];

    end 
    end 
     8'b00000100:begin
    HREADYOUT_buf<=1;
    HRESP<=0;
    HRDATA_BUF<=mem[RD_ADDR];
    RD_ADDR<=RD_ADDR+1;
    end 
     8'b00000010:begin
    HREADYOUT_buf<=1;
    HRESP<=0;
    if(WR_ADDR<HADDR+15)begin
    HRDATA_BUF<=mem[RD_ADDR];
    RD_ADDR<=RD_ADDR+1;
    end else begin
    	HRDATA_BUF<=mem[RD_ADDR];

    end 
    end 
     8'b00000001:begin
    HREADYOUT_buf<=1;
    HRESP<=0;
    HRDATA_BUF<=mem[RD_ADDR];
    RD_ADDR<=RD_ADDR+1;
    end 
    	endcase
        HREADYOUT<=HREADYOUT_buf;
    end
    endcase
    end
end

always@(*)begin
    case(HSIZE)
    3'b000:
    HRDATA={24'b0,HRDATA_BUF[BYTE-1:0]};

    3'b001:
      HRDATA={16'b0,HRDATA_BUF[HALFWORD-1:0]};

 3'b010:
      HRDATA=HRDATA_BUF;
      default:
      HRDATA=HRDATA_BUF;
      endcase
end

endmodule