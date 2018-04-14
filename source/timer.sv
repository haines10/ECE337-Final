// $Id: $
// File name:   timer.sv
// Created:     2/4/2018
// Author:      Matthew Haines
// Lab Section: 337-01
// Version:     1.0  Initial Design Entry
// Description: lab4 timer

module timer
(
	input wire clk,
	input wire n_rst,
	input wire enable_timer,
	output reg shift_strobe,
	output reg packet_done
);
wire [3:0] ten;
wire [3:0] nine;
assign ten = 4'd10;
assign nine = 4'd9;

flex_counter TENS (.clk(clk), .n_rst(n_rst), .clear(~enable_timer), .count_enable(enable_timer), .rollover_val(ten), .rollover_flag(shift_strobe));

flex_counter NINES (.clk(clk), .n_rst(n_rst), .clear(~enable_timer), .count_enable(shift_strobe), .rollover_val(nine), .rollover_flag(packet_done));

endmodule
