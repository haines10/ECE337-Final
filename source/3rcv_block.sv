// $Id: $
// File name:   rcv_block.sv
// Created:     2/4/2018
// Author:      Matthew Haines
// Lab Section: 337-01
// Version:     1.0  Initial Design Entry
// Description: Final RCV

module rcv_block
(
	input wire clk,
	input wire n_rst,
	input wire serial_in,
	input wire data_read,
	output reg [7:0] rx_data,
	output reg data_ready,
	output reg overrun_error,
	output reg framing_error
);
wire start_bit_detected;
wire stop_bit;
wire sbc_enable;
wire sbc_clear;
wire load_buffer;
wire enable_timer;
wire packet_done;
wire shift_strobe;
wire [7:0] packet_data;


stop_bit_chk STOP (.clk(clk), .n_rst(n_rst), .sbc_clear(sbc_clear), .sbc_enable(sbc_enable), .stop_bit(stop_bit), .framing_error(framing_error));

start_bit_det START ( .clk(clk), .n_rst(n_rst), .serial_in(serial_in), .start_bit_detected(start_bit_detected));

sr_9bit SHIFT (.clk(clk), .n_rst(n_rst), .shift_strobe(shift_strobe), .serial_in(serial_in), .packet_data(packet_data), .stop_bit(stop_bit));

timer TIME (.clk(clk), .n_rst(n_rst), .enable_timer(enable_timer), .shift_strobe(shift_strobe), .packet_done(packet_done));

rcu RCU ( .clk(clk), .n_rst(n_rst), .start_bit_detected(start_bit_detected), .packet_done(packet_done), .framing_error(framing_error), .sbc_clear(sbc_clear), .sbc_enable(sbc_enable), .load_buffer(load_buffer), .enable_timer(enable_timer));

rx_data_buff RX_DATA ( .clk(clk), .n_rst(n_rst), .load_buffer(load_buffer), .packet_data(packet_data), .data_read(data_read), .rx_data(rx_data), .data_ready(data_ready), .overrun_error(overrun_error));

endmodule
