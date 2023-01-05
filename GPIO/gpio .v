module GPIO 
(
  input PRESETn,PCLK,
  input PSEL,
  input PENABLE,
  input [3:0] PADDR,
  input PWRITE,
  input [7:0] PWDATA,
  output reg [7:0] PRDATA,
  output PREADY,
  input  [7:0] gpio_i,
  input [1:0] current_state,
  output reg[7:0] out_reg
);
integer n,i;
reg[7:0] mem[0:7];

localparam DIRECTION = 0, OUTPUT = 1, INPUT = 2;
localparam IDLE=2'b00,SETUP=2'b01,ACCESS= 2'b10;
reg [7:0] dir_reg=8'd0;
//reg [7:0] out_reg=8'd0;
reg [7:0] in_reg=8'd0;

assign PREADY  = 1'b1;
/*
// read
always @(posedge PCLK)
begin
	if(!PWRITE)
	case(PADDR)
		DIRECTION: PRDATA = dir_reg;
		OUTPUT:	PRDATA = out_reg;
		INPUT: PRDATA = in_reg;
		default: PRDATA =8'd0;
	endcase
end
*/
always @(*)
begin
     if(current_state==ACCESS) begin
	if(PSEL & PENABLE & !PWRITE)
	begin
		PRDATA=mem[PADDR];
	end
	else if(PSEL & PENABLE & PWRITE)begin
		if(PADDR == DIRECTION)
			dir_reg = mem[PADDR];
		else if(PADDR == OUTPUT)
		begin
			for(n =0;n<8;n=n+1)
				out_reg[n] = dir_reg[n] ? mem[PADDR] : 1'bz;
		end
		else if(PADDR == INPUT)
		begin
			for(i = 0;i<8;i=i+1)
				mem[PADDR][i] = dir_reg[n]? 1'bz : gpio_i[i];
		end
	 end
	end
end

endmodule