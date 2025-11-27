`timescale 1ns / 1ps

module spi_master_tb;

  reg        clk;
  reg        rst_n;
  reg        MISO;
  reg [7:0]  data_in;

  wire       MOSI;
  wire [7:0] data_out;
  wire       sck;
  wire       cs;
  wire       done;

  integer i;

  SPI_Master master (
    .clk     (clk),
    .rst_n   (rst_n),
    .MISO    (MISO),
    .data_in (data_in),
    .MOSI    (MOSI),
    .data_out(data_out),
    .sck     (sck),
    .cs      (cs),
    .done    (done)
  );

  // clock
  initial clk = 0;
  always #5 clk = ~clk;

  // reset
  initial begin
    rst_n = 0;
    #10;
    rst_n = 1;      // assert reset (as your current design uses posedge rst_n)
    #10;
    rst_n = 0;      // release reset
  end

  // stimulus
  initial begin
    data_in = 8'hAF;

    // wait for reset to finish
    #40;

    // drive MISO bits on each sck edge (simple example)
    for (i = 0; i < 8; i = i + 1) begin
      @(negedge sck);
      MISO = i+1;
      $display("[t=%0t] bit%0d MISO=%0b MOSI=%0b", $time, i, MISO, MOSI);
    end

    // wait for done
    @(posedge done);
    $display("Final data_out = %h,%0t", data_out,$time);

    #20;
    $finish;
  end

endmodule
