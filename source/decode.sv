// $Id: $
// File name:   decode.sv
// Created:     4/3/2018
// Author:      Matthew Haines
// Lab Section: 337-01
// Version:     1.0  Initial Design Entry
// Description: decodes remaining data

module decode
(
	input wire clk,
	input wire n_rst,
	//From UART
	input wire [7:0] rx_data,
	input wire data_ready,
	input wire overrun_error,
	input wire framing_error,
	//From lookup block
	input wire lookupDone,
	//From output logic block
	input wire writeComp,
	//Output to UART
	output reg data_read,
	//Output to output logic block
	output reg [11:0] location,
	output reg [3:0] length,
	output reg enable,
	//Output to lookup block
	output reg decodeDone
);

logic [11:0] nxt_location;
logic [3:0] length1;

typedef enum bit [2:0] {IDLE, READ_BIT, GET_LENGTH, GET_LOCA, GET_LOCA2, WRITE, DONE, WAIT} state;
	state curr;
	state next;

	always_ff @ (posedge(clk), negedge(n_rst))
	begin
		if(n_rst == 0)
		begin
			curr <= IDLE;
			location <= 8'b0;
			length <= 4'b0;
		end
		else
		begin
			curr <= next;
			location <= nxt_location;
			length <= length1;
		end
	end

	always_comb
	begin

	next = curr;
	nxt_location = location;
	length1 = length;
	data_read = 0;
	decodeDone = 0;
	enable = 0;
	
	case(curr)
		//Idle state. Only moves to READ when data_ready & lookupDone
		IDLE: begin
			if(data_ready && lookupDone)
			begin
				data_read = 1;
		
				if(rx_data == 15)
				begin
					next = IDLE;
				end
				else
				begin
					next = GET_LENGTH;
				end
			end
		end
		//Reads in first byte
		READ_BIT: begin
			if(data_ready)
			begin
				data_read = 1;
				next = GET_LENGTH;
			end
			if(overrun_error || framing_error)
			begin
				next = IDLE;
			end
		end
		
		//Reads in next byte. Saves first 4 bits as Length
		GET_LENGTH: begin
				if(overrun_error || framing_error)
				begin
					next = IDLE;
				end
		
				length1 = rx_data[3:0];
				if(length1 == 15)
				begin
					next = DONE;
				end
				else
				begin
					next = GET_LOCA;
				end
		end
		//Saves last 4 bits as location. Asserts data_read to get byte
		GET_LOCA: begin
			nxt_location[3:0] = rx_data[7:4];
			data_read  = 1;
			next = WAIT;
		end
		//Saves full byte into the last (Most Significant) bits of location
		GET_LOCA2: begin
			nxt_location[11:4] = rx_data;
			next = WRITE;
		end
		//Enables output logic to write data
		WRITE: begin
			enable = 1;
			//Moves to read bit if write is complete
			if(writeComp == 1)
			begin
				next = READ_BIT;
			end
		end
		DONE: begin
			decodeDone = 1;
			if(lookupDone == 1)
			begin
				next = IDLE;
				
			end		
		end
		WAIT: begin
			if(data_ready)
			begin
				next = GET_LOCA2;
			end
		end
	endcase
	end
endmodule







