// $Id: $
// File name:   start_bit_det.sv
// Created:     2/4/2018
// Author:      Matthew Haines
// Lab Section: 337-01
// Version:     1.0  Initial Design Entry
// Description: more stuff

module start_bit_det
(
	input wire clk,
	input wire n_rst,
	input wire serial_in,
	output reg start_bit_detected
);

reg curr;
reg next;
reg phase;

always @ (posedge(clk), negedge(n_rst))
begin : REG_LOGIC
	if(n_rst == 1'b0)
	begin
		next <= 1'b1;
		curr <= 1'b1;
		phase <= 1'b1;
	end
	else
	begin
		next <= curr;
		curr <= phase;
		phase <= serial_in;
	end
end

assign start_bit_detected = next & (~curr);


endmodule
