`include "APB_bus.v"
`include "gpio.v"
`include "UART.v"

// `timescale 1ns/1ns

module APB_GPIO_Interface(PCLK,PRESETn,PADDR_master,transfer,PWRITE_master,PWDATA_master,PRDATA_master,gpio_i,PENABLE,PSEL,out);
// inputs from master
input PCLK,PRESETn,transfer;
input [7:0] gpio_i,PWDATA_master; // to write on gpio pins
input [3:0] PADDR_master;
input PWRITE_master;


// outputs to master
output [7:0] PRDATA_master; 
output reg PENABLE,PSEL;
// wires between apb and gpio
wire PENABLE_IN,PSEL_IN,PREADY_O,PENABLE_O,PSEL_O;
wire [1:0] current_state_in,current_state_out;
wire [7:0] PRDATA;
output reg[7:0] out;
wire[7:0] PWDATA;
wire [3:0] PADDR;
wire PWRITE;
wire PREADY;


APB apb1(.PCLK(PCLK),.PRESETn(PRESETn),.PSEL(PSEL_O),.PWDATA(PWDATA),.PWDATA_master(PWDATA_master),.PENABLE(PENABLE_OUT),.PREADY(PREADY),.current_state(current_state_out),.PADDR(PADDR),.PADDR_master(PADDR_master),.transfer(transfer),.PWRITE_master(PWRITE_master),.PWRITE(PWRITE),.PRDATA_master(PRDATA_master),.PRDATA(PRDATA));

GPIO g1( .PCLK(PCLK) ,.PENABLE(PENABLE_IN) ,.PWRITE(PWRITE),.PSEL(PSEL_IN),.PRESETn(PRESETn),.PWDATA(PWDATA),.PADDR(PADDR),.PREADY(PREADY_O),.PRDATA(PRDATA),.current_state(current_state_in),.gpio_i(gpio_i),.out_reg(out_reg));

//assign PRDATA = PRDATA_O;
assign PENABLE_IN = PENABLE_O;
assign PSEL_IN = PSEL_O;
assign PREADY = PREADY_O;
assign PENABLE = PENABLE_O;
assign PSEL = PSEL_O;
assign current_state_in = current_state_out;
/*always @(*) begin
	if(!PWRITE)
		PRDATA = PRDATA_O;
	else if(PWRITE)
		out = out_reg;*/
//end
endmodule





