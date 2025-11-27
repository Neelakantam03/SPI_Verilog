
`timescale 1ns/1ps
module SPI_Master(
  input        clk,
  input        rst_n,
  input        MISO,
  input  [7:0] data_in,
  output reg   MOSI,
  output  reg [7:0] data_out,
  output reg   sck,
  output reg   cs,
  output reg done 
);

  // Internal registers
  reg [7:0] shift_reg;
  reg [2:0] count;
  reg [1:0] state;

  // State encoding
  localparam idle     = 2'b00,
             load     = 2'b01,
             transfer = 2'b10,
             finish   = 2'b11;

  // Clock and reset logic
  always @(posedge clk or posedge rst_n) begin
    if (rst_n) begin
      //count <= 0;
       sck   <= 1; //sck <=0;
      //cs    <= 1;
      state <= idle;
    end else begin
      sck <= ~sck;
    end
  end

  // SPI state machine
  always @(posedge sck or posedge rst_n) begin //here rst have to change negedge 
    if (rst_n) begin // here !rst_n
      state <= idle;
      shift_reg <= 8'b0;
      MOSI <= 0;
      cs <= 1;
      done <= 0;
      count<= 3'd0;
      data_out <= 8'd0;
    end else begin
      case (state)
        idle: begin
          //shift_reg <= 8'b0;
         // MOSI <= 1'b0;
         cs <=1'b1;
         done <= 1'b0;
          state <= load;
        end

        load: begin
         cs <= 1'b0;
          shift_reg <= data_in;
//          cs <= 0;
          count <= 3'd0;
          state <= transfer;
        end

        transfer: begin
         
          MOSI <= shift_reg[7];
          shift_reg <= {shift_reg[6:0], MISO};
          count <= count + 1;
          if (count == 7)
            state <= finish;
          
        end

        finish: begin
          cs <= 1;
        
          data_out <= shift_reg;
          done <= 1'b1;
          state <= idle;
        end

        default: state <= idle;
      endcase
    end
  end

  //assign data_out = shift_reg;

endmodule