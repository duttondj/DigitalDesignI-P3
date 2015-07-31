/*
  Filename:    TB_counter16bit.v
  Author:      Duane Niles (modified by JST, 24 March 2015) Danny Dutton, 4/1/2015
  Date:        10/15/2013
  Version:     3
  Description: Counter testbench.
 */

`timescale 1ns/100ps

module TB_counter16bit();
	reg clock, enable, clear, disp, dir;
	reg [4:0] countValue;
	wire [15:0] outputValue;
	
// Instantiate counter.
	counter16bit C1 (clock, enable, clear, disp, dir, countValue, outputValue);
	
	initial begin
		clock = 0;
		enable = 0;
		disp = 0;
		countValue = 0;
		dir = 1;
		#25 clear = 1;
		#25 clear = 0;
		#50 clear = 1;
		#100 disp = 1;
		#100 countValue = 4'd1;
		#100 countValue = 4'd2;
		#200 dir = 0;
		#200 $stop;
	end
	
	always begin
		#20 clock = ~clock;
	end
	
	always begin
		#65 enable = ~enable;
	end

endmodule
