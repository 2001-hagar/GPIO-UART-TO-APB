module APB(PCLK,PREADY,PRESETn,PENABLE,PADDR,PSEL,transfer,current_state,PWDATA_master,PWDATA,PADDR_master,PWRITE_master,PWRITE,PRDATA_master,PRDATA);

// Inputs from Master
input PCLK,PREADY,PRESETn,transfer;
input PWRITE_master;
output reg PWRITE;
output reg PENABLE,PSEL;

output reg [7:0] PWDATA,PRDATA_master;

input[7:0] PRDATA;
input[7:0] PWDATA_master;

input [3:0] PADDR_master;
output reg [3:0] PADDR;
localparam IDLE=2'b00,SETUP=2'b01,ACCESS= 2'b10;

output reg [1:0] current_state = IDLE;
reg [1:0] next_state = IDLE;


always @(posedge PCLK or negedge PRESETn)
begin
	if(!PRESETn)
		current_state <= IDLE;
	else
		current_state <= next_state;
end

// FSM
always @(posedge PCLK)
begin
	PWRITE = PWRITE_master;
	case(current_state)
		IDLE: begin
			PSEL = 0;
			PENABLE = 0;
			if(transfer)
				next_state = SETUP;
		 	end
		SETUP: begin
			PENABLE = 0;
			PADDR = PADDR_master;
			if(PWRITE_master) begin
					PWDATA = PWDATA_master;
			end
			if(transfer) 
				begin
				PSEL = 1;
				next_state = ACCESS;
				end
			end
		ACCESS: begin
			PENABLE = 1;
			if(PREADY & transfer) begin
				next_state = SETUP;
				if(!PWRITE_master)
					PRDATA_master = PRDATA;
			end
			else if(!PREADY)
				next_state = ACCESS;
			else if(PREADY & !transfer)
				next_state = IDLE;
			end
	endcase
end


endmodule