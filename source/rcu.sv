// $Id: $
// File name:   rcu.sv
// Created:     2/4/2018
// Author:      Matthew Haines
// Lab Section: 337-01
// Version:     1.0  Initial Design Entry
// Description: Final

`timescale 1ns / 10ps

module rcu
(
	input wire clk,
	input wire n_rst,
	input wire start_bit_detected,
	input wire packet_done,
	input wire framing_error,
	output reg sbc_clear,
	output reg sbc_enable,
	output reg load_buffer,
	output reg enable_timer
);

	typedef enum bit [2:0] {WAIT, START, PACK, STOP, FRAME, SAVE} state;
	state curr;
	state next;

	always_ff @ (posedge(clk), negedge(n_rst))
	begin
		if(n_rst == 0)
			curr <= WAIT;
		else
			curr <= next;
	end

	always_comb
	begin

	next = curr;
	sbc_clear = 0;
	sbc_enable = 0;
	enable_timer = 0;
	load_buffer = 0;

	case(curr)
		WAIT: begin
			if(start_bit_detected)
				next = START;
		end

		START: begin
			sbc_clear = 1;
			next = PACK;
		end
	
		PACK: begin
			enable_timer = 1;
			sbc_clear = 0;	
			if(packet_done == 1)
				next = STOP;
		end
		
		STOP: begin
			enable_timer = 0;
			sbc_enable = 1;
			next = FRAME;
		end

		FRAME: begin
			sbc_enable = 0;
			if(framing_error == 1)
				next = WAIT;
			else
				next = SAVE;
		end
		
		SAVE: begin
			load_buffer = 1;
			next = WAIT;
		end
	endcase
end
endmodule

