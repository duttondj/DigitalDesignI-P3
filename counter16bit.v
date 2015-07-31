// Filename:    counter16bit.v
// Author:      Jason Thweatt, Danny Dutton
// Date:        1 April 2015
// Version:     1
// Description: A 16-bit counter as a starting point for project 3.
 
// Incorporates separate keypress state machine by T. Martin

module counter16bit(clock, enable, clear, disp, dir, countValue, outputValue);
	input clock, enable, clear, disp, dir;
	input [3:0] countValue;
	output [15:0] outputValue;
	
	reg [15:0] counter_state, next_counter_state;
	
// STATE MACHINE: REGISTER BLOCK
// This always block represents sequential logic, so it uses non-blocking assignments.
// It is sensitized to the clock input and the clear input.
// You should picture this always block as a 16-bit register with an active-low asynchronous clear.
// You can modify this block if you REALLY think you need to, but you shouldn't need to.

	always @(posedge clock or negedge clear) begin
	
	// If a negative edge occured on clear, then clear must equal 0.
	// Since the effect of the clear occurs in the absence of a clock pulse, the reset is ASYNCHRONOUS.
	// Release clear to permit synchronous behavior of the counter.
		if (clear == 0)
			counter_state <= 16'b0;

	// If clear is not 0 but this always block is executing anyway, there must have been a positive clock edge.
	// On each positive clock edge, the next state becomes the present state.
		else
			counter_state <= next_counter_state;
	end

// STATE MACHINE: REGISTER INPUT LOGIC
// This always block represents combinational logic, so it uses blocking assignments.
// It is (currently) sensitized to changes in the enable input and the present state.
// You should picture this block as a combinational circuit that feeds the register inputs.
// It determines the next state based on the current state and the mode inputs.

// MODIFY THIS ALWAYS BLOCK TO IMPLEMENT YOUR VERSION OF THE COUNTER.
// UPDATE THE COMMENTS ACCORDINGLY. DELETE THESE COMMENTS IN CAPS.

	always @(enable or counter_state) begin

	// To be safe, assign a default value to next_counter_state.
	// That way, if none of the paths in your case statement apply, the variable will have a known value.
	// This should be overridden by assignments below.
		next_counter_state = counter_state;
		
	// Keep the same counter value if the enable signal is not active.
		if (!enable) 
			next_counter_state = counter_state;
	
	// Otherwise, update the counter based on the counter state, the display mode, the count direction,
	// and the count value.

		else begin
			if (dir)
				next_counter_state = counter_state + countValue;
			else
				next_counter_state = counter_state - countValue;
			if (!disp)
				next_counter_state = 16'h0580;
		end
	end

// OUTPUT MACHINE
// Since the output is always the same as the counter state, assign the current state to the output.
// In a more complex sequential circuit, the output machine would consist of an always block.
// Since the always block for the output machine represents combinational logic, it would use blocking assignments.
	
	assign outputValue = counter_state;

endmodule
