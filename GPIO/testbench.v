`include "APB_Protocol.v"

`timescale 1ns/1ns

module gpiotb;

// inputs from master
reg PCLK,transfer,PRESETn,PWRITE_master;
reg [3:0] PADDR_master;
//inputs from master to GPIO
reg[7:0] PWDATA_master;
reg[7:0] gpio_i; // to write on pins

// outputs
wire [7:0] out;
wire[7:0] PRDATA_master;
wire PENABLE,PSEL;

localparam DIRECTION = 0, OUTPUT = 1, INPUT = 2;
APB_GPIO_Interface uut(.PCLK(PCLK),.PRESETn(PRESETn),.transfer(transfer),.PWRITE_master(PWRITE_master),.PADDR_master(PADDR_master),.PWDATA_master(PWDATA_master),.gpio_i(gpio_i),.PRDATA_master(PRDATA_master),.PENABLE(PENABLE),.PSEL(PSEL),.out(out));

always #50 PCLK = ~PCLK;

initial begin
PCLK = 0;
PRESETn = 0;
transfer = 0;
PADDR_master = 0;
PWRITE_master = 0;
PWDATA_master = 0;
gpio_i = 0;
end

initial begin
PRESETn = 1;
// set pin 0,pin1 dir output
PADDR_master = DIRECTION;
PWDATA_master = 8'd3;
PWRITE_master = 1;
transfer = 1;
#100;
transfer = 0;
#50;

// write 2 
PADDR_master = OUTPUT;
PWDATA_master = 8'd2;
PWRITE_master = 1;
transfer = 1;
#100;

transfer = 0;
#50;

// set pin1,pin4,pin5 direction input
PADDR_master = DIRECTION;
PWDATA_master = 8'd255;
PWRITE_master = 1;
transfer =1;
#100;

transfer = 0;
#50;
// write 25 on pins
PADDR_master = INPUT;
gpio_i = 8'd25;
PWRITE_master = 1;
transfer = 1;
#100;

transfer = 0;
#50;

// read
PADDR_master = INPUT;
PWRITE_master = 0;
transfer = 1;
#100;

transfer = 0;

end
endmodule