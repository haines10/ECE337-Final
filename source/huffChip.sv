// $Id: $
// File name:   huffChip.sv
// Created:     4/14/2018
// Author:      Matthew Haines
// Lab Section: 337-01
// Version:     1.0  Initial Design Entry
// Description: overall wrapper

module huffChip
(
	input wire serial_in,
	input wire clk,
	input wire n_rst,
	input wire externalEn,
	output reg [7:0] externalChar
);
logic data_read_hold;
logic [7:0] rx_data_hold;
logic data_ready_hold;
logic overrun_hold;
logic framing_hold;
logic decodeHold;
logic saveHold;
logic [7:0] lookupTab_hold;
logic [3:0] lengthIn_hold;
logic [11:0] pathHold;
logic enableSave;
logic lookupHold;
logic writeHold;
logic [11:0] locationHold;
logic [3:0] lengthOut_hold;
logic enableWrite;
logic decodeDone_hold;



rcv_block UART (.clk(clk), .n_rst(n_rst), .serial_in(serial_in), .data_read(data_read_hold), .rx_data(rx_data_hold), .data_ready(data_ready_hold), .overrun_error(overrun_hold), .framing_error(framing_hold));

lookupCreate TABLE (.clk(clk), .n_rst(n_rst), .rx_data(rx_data_hold), .data_ready(data_ready_hold), .overrun_error(overrun_hold), .framing_error(framing_hold), .decodeDone(decodeHold), .saveComp(saveHold), .data_read(data_read_hold), .lookupTab(lookupTab_hold), .length(lengthIn_hold), .enable(enableSave), .lookupDone(lookupHold), .path(pathHold));

decode DECODING (.clk(clk), .n_rst(n_rst), .rx_data(rx_data_hold), .data_ready(data_ready_hold), .overrun_error(overrun_hold), .framing_error(framing_hold), .lookupDone(lookupHold), .writeComp(writeHold), .data_read(data_read_hold), .location(locationHold), .length(lengthOut_hold), .enable(enableWrite), .decodeDone(decodeDone_hold));


