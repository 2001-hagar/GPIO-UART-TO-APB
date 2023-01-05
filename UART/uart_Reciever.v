 module uartReciever
 #(parameter dataBits = 32, SB_tick = 16 ,addr_uart)
 (
 input clk, reset_n, 
 input recieverInput, s_tick,
 input psel,penable,pwrite,paddr,
 output reg recieverDoneTick,
 output [31:0] recieverOutput,pready
 );
 localparam idle = 0, start = 1, data = 2, stop = 3 , set_up=4 ,access=5;
 reg [2:0] state_reg, state_next;
 reg [3:0] s_reg, s_next;
 reg [$clog2(dataBits) - 1 : 0] n_reg, n_next;
 reg [31:0] b_reg, b_next;
 
 
always@(posedge clk, negedge reset_n)
 begin
   if (~reset_n)
     begin
       state_reg <= idle;
       s_reg <= 0;
       n_reg <= 0;
       b_reg <= 0;
     end
   else
     begin
       state_reg <= state_next;
       s_reg <= s_next;
       n_reg <= n_next;
       b_reg <= b_next;
     end
   end
   

  always@(*) // ?
   begin
     state_next = state_reg;
     s_next = s_reg;
     n_next = n_reg;
     b_next = b_reg;
     recieverDoneTick = 1'b0;
     case (state_reg)
       idle: //0
       if (~recieverInput)
         begin
           s_next = 0;
           state_next = start;
         end
         start: //1
         if (s_tick)
           if (s_reg == 7)
             begin
               s_next = 0;
               n_next = 0;
               state_next = data;
             end
           else 
             s_next = s_reg + 1;
         data:
         if (s_tick)
           if (s_reg == 15)
             begin
               s_next = 0;
               b_next = {recieverInput, b_reg [dataBits - 1 : 1]}; // shifting to right
               if (n_reg == (dataBits - 1))
                 state_next = stop;
               else
                 n_next = n_reg + 1;
               end
             else s_next = s_reg + 1;
         stop:
         if (s_tick)
           if (s_reg == (SB_tick - 1))
             begin
               recieverDoneTick = 1'b1;
               state_next = set_up;
             end
           else
             s_next = s_reg + 1;
         set_up:
         if((psel == 1 && addr_uart == 0x2364)&& pwrite==0)   
           begin
             state_next=access;   
          end 
         access:
         if(penable==1&&recieverDoneTick == 1'b1)
           begin
              assign pready=1;    
         default:
             state_next = idle;
           endcase
         end
           assign recieverOutput = b_reg;
         endmodule
