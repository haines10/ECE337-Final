// $Id: $
// File name:   flex_counter.sv
// Created:     1/30/2018
// Author:      Matthew Haines
// Lab Section: 337-01
// Version:     1.0  Initial Design Entry
// Description: Lab 3
`timescale 1ns / 10ps

module flex_counter
#(
	parameter NUM_CNT_BITS = 4
)
(
	input wire clk,
	input wire n_rst,
	input wire clear,
	input wire count_enable,
	input wire [NUM_CNT_BITS-1:0] rollover_val,
	output reg [NUM_CNT_BITS-1:0] count_out,
	output reg rollover_flag
);

reg curr_flag;
reg next_flag;
reg [NUM_CNT_BITS-1:0] curr_cnt;
reg [NUM_CNT_BITS-1:0] next_cnt;

always_ff @ (posedge(clk), negedge(n_rst))
begin
	if(n_rst == 0)
	begin
		curr_cnt <= '0;	
		curr_flag <= '0;
	end
	else
	begin
		curr_cnt <= next_cnt;
		curr_flag <= next_flag;
	end
end

always_comb
begin
	if(clear == 1)
	begin
		next_cnt = '0;
		next_flag = '0;
	end
	else
	begin
		if(count_enable == 1)
		begin
			next_cnt = curr_cnt + 1;
			next_flag = 1'b0;
			if(next_cnt == (rollover_val + 1))
			begin
				next_cnt = 1;
			end
			if(next_cnt == rollover_val)
			begin
				next_flag = 1'b1;
			end
		end
		else 
		begin
			next_cnt = curr_cnt;
			next_flag = 1'b0;
		end
	end
end
assign count_out = curr_cnt;
assign rollover_flag = curr_flag;
endmodule
			
