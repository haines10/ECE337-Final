// $Id: $
// File name:   stop_bit_chk.sv
// Created:     2/4/2018
// Author:      Matthew Haines
// Lab Section: 337-01
// Version:     1.0  Initial Design Entry
// Description: lab 4 stuff

module stop_bit_chk
(
	input wire clk,
	input wire n_rst,
	input wire sbc_clear,
	input wire sbc_enable,
	input wire stop_bit,
	output reg framing_error
);

reg next_frame;

always @ (posedge(clk), negedge(n_rst))
begin : REG
	if(n_rst == 1'b0)
	begin
		framing_error <= 1'b0;
	end
	else
	begin
		framing_error <= next_frame;
	end
end

always @ (framing_error, sbc_clear, sbc_enable, stop_bit)
begin : NEXT
	next_frame <= framing_error;
	if(sbc_clear == 1'b1)
	begin
		next_frame <= 1'b0;
	end
	else if(stop_bit == 1'b1)
	begin
		if(stop_bit == 1'b1)
		begin
			next_frame <= 1'b0;
		end
		else
		begin
			next_frame <= 1'b1;
		end
	end
end

endmodule

