// $Id: $
// File name:   demultiplexer.sv
// Created:     4/3/2018
// Author:      Matthew Haines
// Lab Section: 337-01
// Version:     1.0  Initial Design Entry
// Description: demultiplexer for modules

module registers
(
	//Input from lookup block
	input wire [3:0] length,
	input wire enable,
	input wire [7:0] character,
	input wire [11:0] path,
	output reg [7:0] Table [255:0],
	//output to lookup block
	output reg saveComp


);

//Intermediate saving the hash value
wire [7:0] hash;

	always_comb
	begin
		hash = 7'b0;
		saveComp = 0;

		if(enable)
		begin
			
			//If length is 7 or less bits, use the path as the key value (0 to 128)
			if(length <= 7)
			begin
				hash[6:0] = path[6:0];
			end
			else
			begin
				case(length)
					//Length 8 hash set 128+6 bit value (2^6 = 64)				
					8: begin
						hash = 128 + path[8:3];
					end
					//Length 9 hash set 192+5 bit value (2^5 = 32)
					9: begin
						hash = 192 + path[9:5];
					end
					//Length 10 hash set 224+4 bit value (2^4 = 16)
					10: begin
						hash = 224 + path[10:7];
					end
					//Length 11 hash set 240+3 bit value (2^3 = 8)
					11: begin
						hash = 240 + path[11:9];
					end
					//Length 12 hash set 248+3 bit value (2^3 = 8)
					12: begin
						hash = 248 + path[12:10];
					end
				endcase
			end
	end
//Use hash to select proper register to save character								
assign Table[hash] = character;
//Assert Save complete flag
assign saveComp = 1;
endmodule
