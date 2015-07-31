/*
	Filename:    TopModule.v
	Author:      Duane Niles, Jason Thweatt, Danny Dutton
	Date:        1 April 2015
	Version:     2
	Description: Top-Level module for synthesis.

	Updated for use on the DE1-SoC platform.
*/

module TopModule(CLOCK_50, SW, KEY, HEX3, HEX2, HEX1, HEX0);
	input CLOCK_50;
	input [5:0] SW;
	input [1:0] KEY;
	output [0:6] HEX3, HEX2, HEX1, HEX0;	// 7-segment display driver interface
														// READ PAGE 26 OF THE MANUAL TO UNDERSTAND WHY THE VECTOR LOOKS LIKE THIS.
														// NO, REALLY. GO READ IT. YOU'LL NEED IT ANYWAY.
	wire enable;
	wire [15:0] hexDigits;
	
// The dot notation represents a "named assignment" - the dotted names of the signals in the module declarations
// correspond to the signals in the top-level module that are enclosed in parentheses.

// This notation helps a reader to make clear associations between signals in a module and the ports of an
// instance of some other module.

	keypressed K1 (.clock(CLOCK_50),			// 50 MHz FPGA Clock
						.reset(KEY[0]),			// Master Reset - Pushbutton Key 0
						.enable_in(KEY[1]),		// Enable - Pushbutton Key 1
						.enable_out(enable));	// Connect to the enable input port of the counter.
					
	counter16bit C1 (.clock(CLOCK_50),				// 50 MHz FPGA Clock
						  .enable(enable),				// Driven by the enable_out port from the keypressed FSM
						  .clear(KEY[0]),					// Master Reset - Pushbutton key 0
						  .disp(SW[5]),					// Disp - DIP switch 5
						  .dir(SW[4]),						// Dir - DIP switch 2
						  .countValue(SW[3:0]),			// countValue - DIP switches (3:0)
						  .outputValue(hexDigits));	// hexDigits - Connect to the seven-segment displays
						  
// INSTANTIATE FOUR INSTANCES OF YOUR 7-SEGMENT DISPLAY DRIVER.
// EACH ONE SHOULD ACCEPT A FOUR-BIT VALUE THAT CORRESPONDS TO ONE HEX DIGIT OF THE COUNTER VALUE.
// THE OUTPUTS OF THE DISPLAY DRIVERS SHOULD CORRESPOND TO A SET OF DRIVERS FOR THE 7-SEGMENT DISPLAYS.
// FOLLOW THE "NAMED ASSIGNMENT" APPROACH USED IN KEYPRESSED AND COUNTER16BIT.

	sevensegdecoder_always S0 (.digit(hexDigits[3:0]),
										.drivers(HEX0));
										
	sevensegdecoder_always S1 (.digit(hexDigits[7:4]),
										.drivers(HEX1));
										
	sevensegdecoder_always S2 (.digit(hexDigits[11:8]),
										.drivers(HEX2));
										
	sevensegdecoder_always S3 (.digit(hexDigits[15:12]),
										.drivers(HEX3));

endmodule
