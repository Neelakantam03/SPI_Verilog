//////////SPI_Slave///////////////////////////

module SPI_Slave (
  
   input sck,
  input cs,
  input MOSI,
  input [7:0] data_in,
  output reg MISO,
  output reg [7:0] data_out
);
  
  //internal registers
  //reg [2:0] count1;
  reg [2:0] count;
  reg [7:0] shift_reg;
  
  always@(negedge cs) begin
    count <= 3'd0;
    //count2 <= 3'd0;
    shift_reg <= data_in;
    
  end
  
  
  always@( posedge sck) begin
    if(!cs) begin
      //shift_reg[count2] <= MOSI;
      
//       MOSI <= shift_reg[7];
//           shift_reg <= {shift_reg[6:0], MISO};
//           count <= count + 1;
      
      
          
      MISO <= shift_reg[7];
      shift_reg <= {shift_reg[6:0],MOSI};
      //count <= count+1;
      
      
//       if(count2 == 3'd7) begin
//           data_out <= shift_reg;
//       end
//       else  begin
//          count2 <= count2+1;
//       end
      if(count == 3'd7) begin
         count <= 3'd0;
        data_out <= {shift_reg[6:0],MOSI};
      end
      else 
        count <= count+1;
        
        
        
//       end
//       else begin
//          count1 = count1-1;
//       end
    end
  end
  //assign data_out = shift_reg;
  
  
    endmodule
  
