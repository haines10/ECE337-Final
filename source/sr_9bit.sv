// $Id: $
// File name:   sr_9bit.sv
// Created:     2/4/2018
// Author:      Matthew Haines
// Lab Section: 337-01
// Version:     1.0  Initial Design Entry
// Description: Lab 4 sr_9bit

module sr_9bit
(
	input wire clk,
	input wire n_rst,
	input wire shift_strobe,
	input wire serial_in,
	output reg [7:0] packet_data,
	output reg stop_bit
);

reg [8:0] out;

flex_stp_sr #(.NUM_BITS(9), .SHIFT_MSB(0)) SHIFT (.clk(clk), .n_rst(n_rst), .serial_in(serial_in), .shift_enable(shift_strobe), .parallel_out(out));

always_comb
begin
	packet_data = out[7:0];
	stop_bit = out[8];
end
endmodule

