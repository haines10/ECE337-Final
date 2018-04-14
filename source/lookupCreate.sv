// $Id: $
// File name:   lookupCreate.sv
// Created:     4/3/2018
// Author:      Matthew Haines
// Lab Section: 337-01
// Version:     1.0  Initial Design Entry
// Description: creates lookup Table for huffman decoding

module lookupCreate
(
	input wire clk,
	input wire n_rst,
	//From UART
	input wire [7:0] rx_data,
	input wire data_ready,
	input wire overrun_error,
	input wire framing_error,
	//From decode Block
	input wire decodeDone,
	//From registers block
	input wire saveComp,
	//Output to UART
	output reg data_read,
	//Output to Registers
	output reg [7:0] lookupTab,
	output reg [3:0] length,
	output reg enable,
	output reg [11:0] path,
	//Output to decode block
	output reg lookupDone
);

logic [11:0] path1;
logic [3:0] length1;
logic [7:0] lookupTab1;

typedef enum bit [3:0] {IDLE, READ_BIT, GET_CHAR, GET_LENGTH, GET_PATH, WAIT, SAVE, DONE} state;
	state curr;
	state next;

	always_ff @ (posedge(clk), negedge(n_rst))
	begin
		if(n_rst == 0)
			curr <= WAIT;
			length <= 0;
			path <= 0;
			lookupTab = 0;
		else
			curr <= next;
			length <= length1;
			path <= path1;
			lookupTab <= lookupTab1;
			
	end

	always_comb
	begin

	next = curr;
	length1 = length;
	lookupTab1 = lookupTab;
	path1 = path;
	data_read = 0;
	lookupDone = 0;
	enable = 0;
	
	case(curr)
		//Idle State
		IDLE: begin
			if(data_ready)
				next = READ_BIT;
		end
		
		//Assert data_read flag to read in byte and move to GET_CHAR
		READ_BIT: begin
			if(data_ready)
			begin
				data_read = 1;
				next = GET_CHAR;
				if(overrun_error || framing_error)
				begin
					next = IDLE;
				end
			end
				
			else
				next = READ_BIT;

		end
		
		//Assign whole byte to be the lookup table value. Move to GET_LENGTH
		GET_CHAR: begin
			//data_read flag asserted to obtain next byte
			if(data_ready)
			begin
				lookupTab1 = rx_data;
				data_read = 1;
				next = GET_LENGTH;
			end
			else
			begin
				next = GET_CHAR;
			end
		end
		
		//The first four bits following the character represent length of path. Retrieve and move to GET_PATH
		GET_LENGTH: begin
			length1 = rx_data[3:0];
			next = GET_PATH;
		end
		
		//Retrieve the next 4 bits representing the path
		GET_PATH: begin
			if(data_ready)
			begin
				//Length of 16 indicates lookup table is complete
				if(length == 16)
				begin
					next = DONE;
				end
				else
				begin
					path1[3:0] = rx_data[7:4];
					data_read = 1;
					next = GET_PATH2;
				end
			end
		end
		
		//Retrieve remaining 8 bits of path
		GET_PATH2: begin
			path1[11:4] = rx_data;
			next = SAVE;
		end
		
		//Ensure encode value saved in register
		SAVE: begin
			enable = 1;
			//saveComp is the completion flag from the register save
			if(saveComp)
			begin
				next = READ_BIT;
			end
		end
			

		//Enters if EOF is found. Does not leave util decodeDone is asserted
		DONE: begin
			lookupDone = 1;
			if(decodeDone == 1)
			begin
				next = IDLE;	
			end
			else
			begin
				next = DONE;
			end
		end	
	endcase
end
endmodule







