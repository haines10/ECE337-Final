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
	output reg [7:0] externalChar,
	output reg data_ready_out,
	output reg data_loss
);
logic data_read_hold;
logic [7:0] rx_data_hold;
logic data_ready_hold;
logic data_read_hold1;
logic data_read_hold2;
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
logic [7:0] charOut_hold;



rcv_block UART (.clk(clk), .n_rst(n_rst), .serial_in(serial_in), .data_read(data_read_hold), .rx_data(rx_data_hold), .data_ready(data_ready_hold), .overrun_error(overrun_hold), .framing_error(framing_hold));

lookupCreate TABLE (.clk(clk), .n_rst(n_rst), .rx_data(rx_data_hold), .data_ready(data_ready_hold), .overrun_error(overrun_hold), .framing_error(framing_hold), .decodeDone(decodeHold), .saveComp(saveHold), .data_read(data_read_hold2), .lookupTab(lookupTab_hold), .length(lengthIn_hold), .enable(enableSave), .lookupDone(lookupHold), .path(pathHold));

decode DECODING (.clk(clk), .n_rst(n_rst), .rx_data(rx_data_hold), .data_ready(data_ready_hold), .overrun_error(overrun_hold), .framing_error(framing_hold), .lookupDone(lookupHold), .writeComp(writeHold), .data_read(data_read_hold1), .location(locationHold), .length(lengthOut_hold), .enable(enableWrite), .decodeDone(decodeDone_hold));

REG BothWays (.length(lengthIn_hold), .charIn(lookupTab_hold), .path(pathHold), .enableIn(enableSave), .lengthOut(lengthOut_hold), .location(locationHold), .enableOut(enableWrite), .saveComp(saveHold), .writeComp(writeHold), .charOut(charOut_hold));

rx_data_buff OUTSTUFF (.clk(clk), .n_rst(n_rst), .load_buffer(saveHold), .packet_data(charOut_hold), .data_read(externalEn), .rx_data(externalChar), .data_ready(data_ready_out), .overrun_error(data_loss));

assign data_read_hold = data_read_hold1 || data_read_hold2;

endmodule


