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
logic [7:0] hash;
integer holder;

	always_comb
	begin
		
		saveComp = 0;
		hash = 7'b0;
		holder = length;
		if(enable)
		begin
			
			//If length is 7 or less bits, use the path as the key value (0 to 128)
			if(holder <= 7)
			begin
				hash[6:0] = path[11:5];
			end
			else
			begin
				case(holder)
					//Length 8 hash set 128+6 bit value (2^6 = 64)				
					8: begin
						hash = 128 + path[11:6];
					end
					//Length 9 hash set 192+5 bit value (2^5 = 32)
					9: begin
						hash = 192 + path[11:7];
					end
					//Length 10 hash set 224+4 bit value (2^4 = 16)
					10: begin
						hash = 224 + path[11:8];
					end
					//Length 11 hash set 240+3 bit value (2^3 = 8)
					11: begin
						hash = 240 + path[11:9];
					end
					//Length 12 hash set 248+3 bit value (2^3 = 8)
					12: begin
						hash = 248 + path[11:9];
					end
				endcase
			end
		Table[hash] = character;
		saveComp = 1;
		end
	end

endmodule
