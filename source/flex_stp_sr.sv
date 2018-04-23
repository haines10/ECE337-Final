// $Id: $
// File name:   flex_stp_sr.sv
// Created:     1/30/2018
// Author:      Matthew Haines
// Lab Section: 337-01
// Version:     1.0  Initial Design Entry
// Description: lab3

module flex_stp_sr
#(
	parameter NUM_BITS = 4,
	parameter SHIFT_MSB = 1
)
(
	input wire clk,
	input wire n_rst,
	input wire shift_enable,
	input wire serial_in,
	output reg [NUM_BITS-1:0] parallel_out
);

reg [NUM_BITS-1:0] steps;
integer i;

always_ff @ (posedge clk, negedge n_rst)  begin
    if(n_rst == 0)
      parallel_out <= '1;
    else
      parallel_out <=steps;
        
end

always_comb
begin
    if(shift_enable == 1) begin
	if (SHIFT_MSB == 1)
        	steps = {parallel_out[NUM_BITS-2:0], serial_in}; //shifting
        else
        	steps = {serial_in, parallel_out[NUM_BITS-1:1]}; //shifting
    	end
	else
        	steps = parallel_out;
  
  	end

endmodule

			
	
