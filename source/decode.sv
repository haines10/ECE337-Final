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
	output reg decodeDone,
	output reg loadBuff
);

logic [11:0] nxt_location;
logic [3:0] length1;
logic enableHold;
logic decodeDone_hold;

typedef enum bit [3:0] {IDLE, READ_BIT, GET_LENGTH, GET_LOCA, GET_LOCA2, WRITE, DONE, WAIT, WAIT_BUFF, ERR} state;
	state curr;
	state next;

	always_ff @ (posedge(clk), negedge(n_rst))
	begin
		if(n_rst == 0)
		begin
			curr <= IDLE;
			location <= 8'b0;
			length <= 4'b0;
			enable <= 0;
			decodeDone <= 0;
		end
		else
		begin
			curr <= next;
			location <= nxt_location;
			length <= length1;
			enable <= enableHold;
			decodeDone <= decodeDone_hold;
		end
	end

	always_comb
	begin

	next = curr;
	nxt_location = location;
	length1 = length;
	data_read = 0;
	decodeDone_hold = decodeDone;
	enableHold = enable;
	loadBuff = 0;
	
	case(curr)
		//Idle state. Only moves to READ when data_ready & lookupDone
		IDLE: begin
			if(lookupDone && data_ready)
			begin
				next = GET_LENGTH;
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
	
				if(data_ready)
				begin
					length1 = rx_data[7:4];
					next = GET_LOCA;
				end

		end
		//Saves last 4 bits as location. Asserts data_read to get byte
		GET_LOCA: begin

			if(length < 15 && length > 12)
			begin
				$error("Invalid path length, exceeds 12 bits");
				next = ERR;
			end
			else
			begin
				if(length == 15 && data_ready)
				begin
					next = DONE;
					decodeDone_hold = 1;
					data_read = 1;
				end
				
				else if(data_ready)
				begin
					nxt_location[11:8] = rx_data[3:0];
					data_read  = 1;
					next = WAIT;
				end
			end
			end
		//Saves full byte into the last (Most Significant) bits of location
		GET_LOCA2: begin
			if(data_ready)
			begin
				nxt_location[7:0] = rx_data;
				enableHold = 1;
				next = WRITE;
			end
		end
		//Enables output logic to write data
		WRITE: begin
			enableHold = 0;
			if(writeComp)
			begin
				next = WAIT_BUFF;
			end
			//Moves to read bit if write is complete
			
		end
		DONE: begin
			if(lookupDone == 1)
			begin
				next = IDLE;	
			end
			else if(data_ready)
			begin
				next = DONE;
				decodeDone_hold = 0;
				length1 = 0;
			end		
		end
		WAIT: begin
			if(!data_ready)
			begin
				next = GET_LOCA2;
			end
		end
	
		WAIT_BUFF: begin
			if(data_ready)
			begin
				data_read = 1;
				loadBuff = 1;
				next = GET_LENGTH;
			end
		end

		ERR: begin
		end
			
			
	endcase
	end
endmodule







