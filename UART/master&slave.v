
module master_slave 
(     
  input [31:0]apb_write_paddr,apb_read_paddr,
	input [31:0] apb_write_data,   
  input PSEL1,      
	input PRESETn,PCLK,READ_WRITE,transfer,
	output [31:0] apb_read_data_outu,
  output [31:0] totx,
  output s ,
  input rxdone ,
  input [31:0] fromrx
);

wire rxClk;
wire txClk;
wire PSEL1m;
wire PENABLEm;
wire [31:0] PADDRm;
wire PWRITEm;
wire [31:0]PWDATAm,apb_read_data_outm;
wire PREADYs;
wire [31:0] PRDATA1s;
wire txBusy;
assign apb_read_data_outu=apb_read_data_outm;
assign TxBusy=txBusy;



 master_bridge bridgeInst(
	.apb_write_paddr(apb_write_paddr),.apb_read_paddr(apb_read_paddr),
  .apb_write_data(apb_write_data),        
  .PRESETn(PRESETn),.PCLK(PCLK),.READ_WRITE(READ_WRITE),.transfer(transfer),
  .PSELi(PSEL1),
  .apb_read_data_out(apb_read_data_outm),

  .PREADY(PREADYs), 
  .PRDATA(PRDATA1s), 
  .PWDATA(PWDATAm),
  .PWRITE(PWRITEm),
  .PADDR(PADDRm),
  .PSELo(PSEL1m),
  .PENABLE(PENABLEm)
   ); 
	
	
	slave1 slaveInst(
          .PCLK(PCLK),.PRESETn(PRESETn),
          .PSEL(PSEL1m),.PENABLE(PENABLEm),.PWRITE(PWRITEm),
          .PADDR(PADDRm),.PWDATA(PWDATAm),
          .PRDATA1(PRDATA1s),
          .PREADY(PREADYs), 
          .start(s),.To_TX(totx),.From_RX(fromrx),.Rx_done(rxdone)
          );






endmodule
