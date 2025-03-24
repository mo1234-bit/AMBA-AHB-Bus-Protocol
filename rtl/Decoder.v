module decoder #(parameter SLAVE_NUM=4)(
	input [$clog2(SLAVE_NUM)-1:0]SEL,
	output reg HSEL_1,
	output reg HSEL_2,
	output reg HSEL_3,
	output reg HSEL_4,
	output [$clog2(SLAVE_NUM)-1:0] Multiplexor_SEL
	);

always@ (*)begin
	if(SEL==0)begin
	HSEL_1=1;
    HSEL_2=0;
    HSEL_3=0;
    HSEL_4=0;
    end
    else if(SEL==1)begin
    	HSEL_1=0;
    HSEL_2=1;
    HSEL_3=0;
    HSEL_4=0;
    end
    else if(SEL==2)begin
    	HSEL_1=0;
    HSEL_2=0;
    HSEL_3=1;
    HSEL_4=0;
    end
    else if(SEL==3)begin
    HSEL_1=0;
    HSEL_2=0;
    HSEL_3=0;
    HSEL_4=1;
    end
    else
    begin
    HSEL_1=0;
    HSEL_2=0;
    HSEL_3=0;
    HSEL_4=0;
    end


end
 assign Multiplexor_SEL=SEL;
 endmodule