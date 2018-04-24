// $Id: $
// File name:   outputLogic.sv
// Created:     4/4/2018
// Author:      Matthew Haines
// Lab Section: 337-01
// Version:     1.0  Initial Design Entry
// Description: output buffer to hold data

module outputLogic
(
	//Input wire from registers 
	input wire [7:0] Table [255:0],
	//Input from decode block
	input wire [3:0] length,
	input wire enable_out,
	input wire [11:0] location,
	//Output to decode block
	output reg writeComp,
	//Output to external peripheral
	output reg [7:0] charOut
);

logic [7:0] lookup;

//Refer to registers for Hashing explanation
	always_comb
	begin
		lookup = 7'b0;
		writeComp = 0;
		if(enable_out)
		begin
			
			if(length <= 7)
			begin
				lookup[6:0] = location[6:0];
			end
			else
			begin
				case(length)
				
					8: begin
						lookup = 128 + location[8:3];
					end
					
					9: begin
						lookup = 192 + location[9:5];
					end
					
					10: begin
						lookup = 224 + location[10:7];
					end

					11: begin
						lookup = 240 + location[11:9];
					end
					
					12: begin
						lookup = 248 + location[11:10];
					end
				endcase
			end
			charOut = Table[lookup];
			writeComp = 1;
		end
	end


endmodule

