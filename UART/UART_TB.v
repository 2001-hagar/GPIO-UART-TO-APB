`timescale 1ns/1ns
`include "UART.v"
module tb_UART();

parameter c_CLOCK_PERIOD_NS = 100;
parameter c_BIT_PERIOD      = 104167;   


reg r_Rx_Serial = 1'b1;        
wire tx;      
wire txDone;
wire TxBusy;
reg r_Clock = 0;
reg [31:0]apb_write_paddr,apb_read_paddr;
reg [31:0] apb_write_data;         
reg PRESETn,READ_WRITE,transfer;
reg PSEL1;
wire [31:0] apb_read_data_outu;



task UART_WRITE_BYTE;
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

 
Uart  uart_inst
(
.apb_write_paddr(apb_write_paddr),
.apb_read_paddr(apb_read_paddr),
.apb_write_data(apb_write_data),
.PCLK(r_Clock),
.PRESETn(PRESETn),
.READ_WRITE(READ_WRITE),
.transfer(transfer),
.PSEL1(PSEL1),
.apb_read_data_outu(apb_read_data_outu),
.rx(r_Rx_Serial),
.tx(tx),
.txDone(txDone),
.TxBusy(TxBusy)
);

always
  #(c_CLOCK_PERIOD_NS/2) r_Clock <= !r_Clock;


  // Main Testing:
  initial
    begin
      transfer=1;
      READ_WRITE=1;
      PRESETn=1;
      PSEL1=1;
      apb_read_paddr=1;
    @(posedge r_Clock);
    UART_WRITE_BYTE(32'hffffffff);
    @(posedge r_Clock);  
  
    #(100000)
      // Check that the correct command was received
      if (apb_read_data_outu == 32'hffffffff)
        $display("Test Passed - Correct Byte Received");
      else
        $display("Test Failed - Incorrect Byte Received");
       
    end
   
endmodule 
  
  
  
  
  