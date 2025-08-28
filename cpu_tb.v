`timescale 1ns / 1ps

module cpu_tb;

reg clk = 0;
reg reset = 0;

top uut(clk, reset);

always #5 clk = ~clk;

initial begin
  reset = 1;
  #100_000;
  reset = 0;
  // Optional: let simulation run for a while
  #200;
  $finish;
end

endmodule
