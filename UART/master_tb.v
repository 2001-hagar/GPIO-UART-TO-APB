`timescale 1ns/1ns
`include "APB_bridge.v"
module master_tb();

parameter c_CLOCK_PERIOD_NS = 100;
parameter c_BIT_PERIOD      = 104167;   

  reg r_Clock = 0;
	reg [31:0]apb_write_paddr,apb_read_paddr;
	reg [31:0] apb_write_data,PRDATA;     
	reg READ_WRITE,transfer,PREADY;
  reg PRESETn;
	reg PSELi;
	wire PSELo;
	wire PENABLE;
  wire [31:0]PADDR;
	wire PWRITE;
	wire [31:0]PWDATA,apb_read_data_out;


 
master_bridge master_inst
(
.apb_write_paddr(apb_write_paddr),
.apb_read_paddr(apb_read_paddr),
.apb_write_data(apb_write_data),
.PRDATA(PRDATA),
.PCLK(r_Clock),
.READ_WRITE(READ_WRITE),
.transfer(transfer),
.PREADY(PREADY),.PSELi(PSELi),.PSELo(PSELo),.PENABLE(PENABLE),
.PADDR(PADDR),.PWRITE(PWRITE),.PWDATA(PWDATA),
.apb_read_data_out(apb_read_data_out)
);

always
  #(c_CLOCK_PERIOD_NS/2) r_Clock <= !r_Clock;


  // Main Testing:
  initial
    begin
      @(posedge r_Clock);
      transfer=1;
      READ_WRITE=0;
      apb_write_paddr=1;
      apb_write_data=32'hffffffff;
      PSELi=1;
      PRESETn=1;

      @(posedge r_Clock);
      @(posedge r_Clock);
      @(posedge r_Clock);

      PREADY=1  ;    
      
      // Check that the correct command was received
      if (PWDATA ==32'hffffffff)
        $display("Test Passed - Correct Byte Received");
      else
        $display("Test Failed - Incorrect Byte Received");
       
    end
   
endmodule 
  
  
  
  
  