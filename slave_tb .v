`timescale 1ns/1ns
`include "slave.v"
module tb_slave();

parameter c_CLOCK_PERIOD_NS = 100;
parameter c_BIT_PERIOD      = 104167; 
 reg r_Clock=0;
 reg PRESETn=1;
 reg PSEL;
 reg PENABLE;
 reg PWRITE;
 reg Rx_done;
 reg [31:0]PADDR;
 reg [31:0]PWDATA;
 reg [31:0]From_RX;
 wire [31:0]PRDATA1;  //output
 wire PREADY;  //output
 wire start;   //output
 wire [31:0] To_TX;  //output

/**task UART_WRITE_BYTE;
    input [31:0] i_Data;
    integer     ii;
    begin
       
      // Send Start Bit
      r_Rx_Serial <= 1'b0;
      #(c_BIT_PERIOD);
     // #1000;
       
       
       
      // Send Data Byte
      for (ii=0; ii<32; ii=ii+1)
        begin
          r_Rx_Serial <= i_Data[ii];
          #(c_BIT_PERIOD);
        end
       
      // Send Stop Bit
      r_Rx_Serial <= 1'b1;
      #(c_BIT_PERIOD);
     end
  endtask // UART_WRITE_BYTE
  **/
 
 slave1 inst(
          .PCLK(r_Clock),.PRESETn(PRESETn),
          .PSEL(PSEL),.PENABLE(PENABLE),.PWRITE(PWRITE),.Rx_done(Rx_done),
          .PADDR(PADDR),.PWDATA(PWDATA),.From_RX(From_RX),
         .PRDATA1(PRDATA1),
         .PREADY(PREADY), 
        .start(start),
        .To_TX(To_TX));

always
  #(c_CLOCK_PERIOD_NS/2) r_Clock <= !r_Clock;


  // Main Testing:
  initial
    begin
      

      @(posedge r_Clock);
      PSEL=1;
      PWRITE=1;
      PADDR=2;
      PWDATA=32'hffffffff;
      @(posedge r_Clock); 
      PENABLE=1;      
      @(posedge r_Clock); 
      // Check that the correct command was received
      if (To_TX ==32'hffffffff)
        $display("Test Passed - Correct Byte Received");
      else
        $display("Test Failed - Incorrect Byte Received");
       
    end
   
   
endmodule 
  
  
