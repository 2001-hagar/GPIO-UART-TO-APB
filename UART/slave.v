`timescale 1ns/1ns



module slave1(
         input PCLK,PRESETn,
         input PSEL,PENABLE,PWRITE,Rx_done,
         input [31:0]PADDR,PWDATA,From_RX,
        output [31:0]PRDATA1,
        output reg PREADY, 
        output reg start,
        output reg[31:0] To_TX);
    
     reg [31:0]reg_addr;
     reg [31:0] mem [0:63];

    assign PRDATA1 =  mem[reg_addr];

    always @(*)
       begin
         if(!PRESETn)
              PREADY = 0;
          //else
    if(Rx_done)
	       mem[PADDR]=From_RX;       
	  if(PSEL && !PENABLE && !PWRITE)
	     begin PREADY = 0;
	     end  
	  else if(PSEL && PENABLE && !PWRITE && Rx_done)//read
	     begin  PREADY = 1;
              reg_addr =  PADDR;
              //PRDATA1 =  mem[PADDR]; 
	       end
     else if(PSEL && !PENABLE && PWRITE)  //setup
	     begin  PREADY = 0; end

	  else if(PSEL && PENABLE && PWRITE)//write on slave
	     begin  PREADY = 1;
	            mem[PADDR] = PWDATA;
	            start=1; 
	            To_TX =PWDATA; end

     else PREADY = 0;
        end
    endmodule
