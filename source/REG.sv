// $Id: $
// File name:   REG.sv
// Created:     4/14/2018
// Author:      Matthew Haines
// Lab Section: 337-01
// Version:     1.0  Initial Design Entry
// Description: wrapper for registers in/out

module REG
(
	input wire [3:0] length,
	input wire [7:0] charIn,
	input wire [11:0] path,
	input wire enableIn,
	input wire [3:0] lengthOut,
	input wire [11:0] location,
	input wire enableOut,
	output reg saveComp,
	output reg writeComp,
	output reg [7:0] charOut
);

logic [7:0] Table_hold [255:0];
 
registers IN (.length(length), .enable(enableIn), .character(charIn), .path(path), .Table(Table_hold), .saveComp(saveComp));

outputLogic OUT (.Table(Table_hold), .length(lengthOut), .enable_out(enableOut), .location(location), .writeComp(writeComp), .charOut(charOut));

endmodule
	

	
