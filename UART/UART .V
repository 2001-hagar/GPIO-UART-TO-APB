
module Uart 
(
 
  input [31:0]apb_write_paddr,apb_read_paddr,
	input [31:0] apb_write_data,   
  input PSEL1,      
	input PRESETn,PCLK,READ_WRITE,transfer,
	output [31:0] apb_read_data_outu,
    // rx interface
  input wire rx,         //serial
    // tx interface
  output wire tx,        //serial
  output wire txDone,
   output wire TxBusy
  //ApB
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
wire s,rxdone,txBusy;
wire [31:0] totx,fromrx;
assign apb_read_data_outu=apb_read_data_outm;
assign TxBusy=txBusy;





master_slave  master_slave_inst(
  .apb_write_paddr(apb_write_paddr),.apb_read_paddr(apb_read_paddr),
  .apb_write_data(apb_write_data),        
  .PRESETn(PRESETn),.PCLK(PCLK),.READ_WRITE(READ_WRITE),.transfer(transfer),
  .PSEL1(PSEL1),
  .apb_read_data_outu(apb_read_data_outu),
  .s(s),.totx(totx),.fromrx(fromrx),.rxdone(rxdone)


);



BaudRateGenerator #(.CLOCK_RATE(10000000),.BAUD_RATE(115200))  generatorInst (
    .clk(PCLK),
    .rxClk(rxClk),
    .txClk(txClk)
);

uart_rx #(.CLKS_PER_BIT(87)) rxInst (
    .i_Clock(rxClk),
    .i_Rx_Serial(rx),
    .o_Rx_Byte(fromrx),
    .o_Rx_DV(rxdone)
);

uart_tx  #(.CLKS_PER_BIT(87)) txInst (
    .i_Clock(txClk),
    .i_Tx_DV(s),
    .i_Tx_Byte(totx),
    .o_Tx_Serial(tx),
    .o_Tx_Done(txDone),
    .o_Tx_Active(txBusy)
);

endmodule
