`timescale 1ns/1ns

module master_bridge(
	input [31:0]apb_write_paddr,apb_read_paddr,
	input [31:0] apb_write_data,PRDATA,         
	input PRESETn,PCLK,READ_WRITE,transfer,PREADY,
	input PSELi,
	output reg PSELo,
	output reg PENABLE,
	output reg [31:0]PADDR,
	output reg PWRITE,
	output reg [31:0]PWDATA,apb_read_data_out
	 ); 
       // integer i,count;
  reg [2:0] state, next_state;
  localparam IDLE = 3'b001, SETUP = 3'b010, ENABLE = 3'b100 ;


  always @(posedge PCLK)
  begin
	if(!PRESETn)
		state <= IDLE;
	else
		state <= next_state; 
  end



  always @(state,transfer,PREADY)

  begin
	if(!PRESETn)
	  next_state = IDLE;
	else
          begin
             //PWRITE = ~READ_WRITE;
	     case(state)
                  
		     IDLE: begin 
		              PENABLE =0;

		            if(!transfer)
	        	      next_state = IDLE ;
	                    else
			      next_state = SETUP;
	                   end

	       	SETUP:   begin
			    PENABLE =0;

			    if(READ_WRITE) 
				 //     @(posedge PCLK)
	        		begin   PADDR = apb_read_paddr;
							PSELo=PSELi;
							PWRITE=~READ_WRITE;
					 end          //read
			    else 
			      begin   
			          //@(posedge PCLK)
         		  PADDR = apb_write_paddr;           //write
				  PWDATA = apb_write_data;
				  PWRITE = ~READ_WRITE;
				  PSELo=1;  end
			    
			    if(transfer)
			      next_state = ENABLE;
		            else
           	              next_state = IDLE;
		           end

	       	ENABLE: 
		     begin if(PSELi)
		           PENABLE =1;
			         if(transfer )
			         begin
				          if(PREADY)
				          begin
					            if(!READ_WRITE)
				              begin
				              next_state = SETUP; end
					            else 
					            begin
					            next_state = SETUP; 
				              apb_read_data_out = PRDATA; 
					            end
			            end
				          else next_state = ENABLE; end
		          else next_state = IDLE;  //one line
			        end
			   
           default: next_state = IDLE; 
         	 endcase
       end
  end
     //assign PSEL1 = ((state != IDLE) ? (PADDR[31] ? {1'b0,1'b1} : {1'b1,1'b0}) : 2'd0);
 endmodule
