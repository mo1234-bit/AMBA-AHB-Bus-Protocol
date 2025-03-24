module multiplexor(
	input [31:0]HRDATA1,
	input [31:0]HRDATA2,
	input [31:0]HRDATA3,
	input [31:0]HRDATA4,
	input HRESP1,
	input HRESP2,
	input HRESP3,
	input HRESP4,
	input HREADYOUT1,
	input HREADYOUT2,
	input HREADYOUT3,
	input HREADYOUT4,
	input [1:0]SEL,
	output reg [31:0]HRDATA,
	output reg HREADYOUT,
	output reg HRESP);

   always@(*)begin
   	 if (SEL==0)begin
   	 	HRDATA=HRDATA1;
        HREADYOUT=HREADYOUT1;
        HRESP=HRESP1;
   	 end
   	 else if(SEL==1)begin
   	 	HRDATA=HRDATA2;
        HREADYOUT=HREADYOUT2;
        HRESP=HRESP2;
   	 end
   	 else if(SEL==2)begin
   	 	HRDATA=HRDATA3;
        HREADYOUT=HREADYOUT3;
        HRESP=HRESP3;
   end
   else if(SEL==3)begin
   	 	HRDATA=HRDATA4;
        HREADYOUT=HREADYOUT4;
        HRESP=HRESP4;
        end
        else begin
   	 	HRDATA=0;
        HREADYOUT=0;
        HRESP=0;
        end
        end
        endmodule