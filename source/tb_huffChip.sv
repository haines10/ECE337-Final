`timescale 1ns / 10ps

module tb_huffChip ();

	localparam	CLK_PERIOD	= 2.5;
	parameter NORM_DATA_PERIOD	= (10 * CLK_PERIOD);
	reg tb_clk;
	
	always
	begin
		tb_clk = 1'b0;
		#(CLK_PERIOD/2.0);
		tb_clk = 1'b1;
		#(CLK_PERIOD/2.0);
	end

	integer tb_test_num;
	reg tb_serial_in;
	reg tb_n_rst;
	reg tb_externalEn;
	reg [7:0] tb_externalChar;
	reg [79:0] testStuff;
	reg [215:0] testStuff2;
	reg [23:0] testStuff3;
	reg [63:0] testStuff4;
	reg [2247:0] testStuff6;
	reg [7:0] holdStuff;
	reg dataLoss;	
	reg data_ready_out;
	integer counter;
	reg [39:0] tb_expected_string1;
	reg [719:0] test6_expected;
	//reg [7:0] verifier;
	//reg [7:0] testParam;
	//reg enShift;
	reg isTrue;
	integer tracker;
	generate
		huffChip DUT (.serial_in(tb_serial_in), .clk(tb_clk), .n_rst(tb_n_rst), .externalEn(tb_externalEn), .externalChar(tb_externalChar), .data_loss(dataLoss), .data_ready_out(data_ready_out));
	endgenerate

	clocking cb @(posedge tb_clk);
		default input #1step output #100ps; 
		output n_rst = tb_n_rst;
		output serial_in = tb_serial_in;
		output externalEn = tb_externalEn;
		input externalChar = tb_externalChar;
		
	endclocking

	// Tasks for regulating the timing of input stimulus to the design
	task send_packet;
		input  [7:0] data;

		
		
		integer i;

	
	begin

		
		
		// First synchronize to away from clock's rising edge
		@(negedge tb_clk)
		
		// Send start bit
		tb_serial_in = 1'b0;
		#NORM_DATA_PERIOD;
		
		// Send data bits
		for(i = 0; i < 8; i = i + 1)
		begin
			tb_serial_in = data[i];
			#NORM_DATA_PERIOD;
		end
		
		// Send stop bit
		tb_serial_in = 1'b1;
		#NORM_DATA_PERIOD;
	end
	
	endtask

	task reset_dut;
	begin
		// Activate the design's reset (does not need to be synchronize with clock)
		tb_n_rst = 1'b0;
		
		// Wait for a couple clock cycles
		@(posedge tb_clk);
		@(posedge tb_clk);
		
		// Release the reset
		@(negedge tb_clk);
		tb_n_rst = 1;
		
		// Wait for a while before activating the design
		@(posedge tb_clk);
		@(posedge tb_clk);
	end
	endtask

	initial begin	

		tb_n_rst	= 1'b1; // Initially inactive
		tb_serial_in	= 1'b1; // Initially idle
		//tb_data_read	= 1'b0; // Initially inactive
		
		// Get away from Time = 0
		//#0.1; 
		
		// Test case 0: Basic Power on Reset
		//tb_test_case = 0;
		
		// Power-on Reset Test case: Simply populate the expected outputs
		// These values don't matter since it's a reset test but really should be set to 'idle'/inactive values
		//holdStuff 				= '0;
		//tb_test_stop_bit		= 1'b1;
		//tb_test_bit_period	= NORM_DATA_PERIOD;
		//tb_test_data_read		= 1'b0;
		
		// Define expected ouputs for this test case
		// Note: expected outputs should all be inactive/idle values
		// For a good packet RX Data value should match data sent
		//tb_expected_rx_data 			= '1;
		// Valid stop bit ('1') -> Valid data -> Active data ready output
		//tb_expected_data_ready		= 1'b0; 
		// Framing error if and only if bad stop_bit ('0') was sent
		//tb_expected_framing_error = 1'b0;
		// Not intentionally creating an overrun condition -> overrun should be 0
		//b_expected_overrun				= 1'b0;
		
		// DUT Reset
		reset_dut();
		
/*

//Test 1: The letter "l"
		tb_test_num = tb_test_num + 1;
		testStuff = 80'b00000000000011110000000000010010000000000000111100000000000000000001001001101100;
		
		for(counter = 0; counter < 80; counter += 8)
		begin
			tb_externalEn = 0;
			holdStuff = testStuff[7:0];
			send_packet(holdStuff);
			#(NORM_DATA_PERIOD);
			testStuff = testStuff >> 8;
			if(data_ready_out)
			begin
				if(tb_externalChar == 8'b01101100)
					$info("Test 1 Passed");
				else
					$info("Test 1 Failed");
			
				tb_externalEn = 1;
			end
				
		end 


		/*holdStuff = testStuff[7:0];
		send_packet(holdStuff);
		#(NORM_DATA_PERIOD * 2);
		testStuff = testStuff >> 8;
		holdStuff = testStuff[7:0];
		send_packet(holdStuff);
		#(NORM_DATA_PERIOD * 2);
		testStuff = testStuff >> 8;
		holdStuff = testStuff[7:0];
		send_packet(holdStuff);
		#(NORM_DATA_PERIOD * 2);
		testStuff = testStuff >> 8;
		holdStuff = testStuff[7:0];
		send_packet(holdStuff);
		#(NORM_DATA_PERIOD * 2);
	
			
	#(NORM_DATA_PERIOD);		

*/

/*
// Test 2: The word "hello"
			
		tb_test_num = tb_test_num + 1;
		counter = 0;
		tracker = 0;
		tb_externalEn = 0;
		testStuff2 = 216'b011001010011101000000000011010000011011000000000011011000001000000000000011011110011111000000000111111111111111111111111001101100000000000111010000000000001000000000000000100000000000000111110000000001111111111111111;
		#(NORM_DATA_PERIOD * 2);

		tb_expected_string1 = 40'b0110100001100101011011000110110001101111;
		
		for(counter = 0; counter < 216; counter += 8)
		begin
	
			holdStuff = testStuff2[215:208];
			send_packet(holdStuff);
			if(data_ready_out)
			begin
				tb_externalEn = 1;
				if(tb_expected_string1[39:32] == tb_externalChar)
				begin 
					$info("Pass on ascii character: %0d", tb_externalChar);
				end
				else
				begin
					$info("Fail on ascii character: %0d", tb_externalChar);
				end
				
				tb_expected_string1 = tb_expected_string1 << 8;
			end
			else
			begin
				tb_externalEn = 0;
			end
			
			//#(NORM_DATA_PERIOD);
			testStuff2 = testStuff2 << 8;
			
		end	
			
*/

	
// Test 3: Very Big Test
		tb_test_num = tb_test_num + 1;

		counter = 0;
		tb_externalEn = 0;
		test6_expected = 720'b010000010010000001110001011101010110100101100011011010110010000001100010011100100110111101110111011011100010000001100110011011110111100000100000011010100111010101101101011100000110010101100100001000000110111101110110011001010111001000100000011101000110100001100101001000000110110001100001011110100111100100100000011001000110111101100111001011100010000001010011011101010111001001110000011100100110100101110011011001010010000001101101011001010010110000100000011000100111010101110100001000000110100101100110001000000110100101110100001000000111001101110101011000110110101101110011001000000100100100100000011101110110100101101100011011000010000001100010011001010010000001110000011010010111001101110011011001010110010000101110;
		testStuff6 = 2248'b0010000000100000000000000010110001111111101000000010111001100010110000000100000101110101011000000100100101111101011000000101001101110011011000000110000101111011011000000110001001010000100000000110001101101110110000000110010001011000100000000110010101000011000000000110011001100001110000000110011101110100111000000110100001111100111000000110100101001001000000000110101001110010111000000110101101101101110000000110110001010010100000000110110101100011110000000110111001111010111000000110111101011111100000000111000001011010100000000111000101110101111000000111001001000010000000000111001101000110000000000111010001010110100000000111010101001110000000000111011001111101111000000111011101010101000000000111100001100110100000000111100101101110100000000111101001100111010000001111111111111111111111110111010101100000001000000000000001110101111000000100111000000000010010010000000001101110110000000110110111000000001000000000000001010000100000000100001000000000010111111000000001010101000000000111101011100000001000000000000001100001110000000101111110000000011001101000000000100000000000000111001011100000010011100000000001100011110000000101101010000000010000110000000001011000100000000010000000000000010111111000000001111101111000000100001100000000010000100000000000100000000000000101011010000000011111001110000001000011000000000010000000000000010100101000000001111011011000000110011101000000011011101000000000100000000000000101100010000000010111111000000001110100111000000110001011000000001000000000000001110011011000000100111000000000010000100000000001011010100000000100001000000000010010010000000001000110000000000100001100000000001000000000000001100011110000000100001100000000011111111010000000100000000000000101000010000000010011100000000001010110100000000010000000000000010010010000000001100001110000000010000000000000010010010000000001010110100000000010000000000000010001100000000001001110000000000110111011000000011011011100000001000110000000000010000000000000011111010110000000100000000000000101010100000000010010010000000001010010100000000101001010000000001000000000000001010000100000000100001100000000001000000000000001011010100000000100100100000000010001100000000001000110000000000100001100000000010110001000000001100010110000001111111111111111;
				
		for(counter = 0; counter < 2248; counter += 8)
		begin
			holdStuff = testStuff6[2247:2240];
			send_packet(holdStuff);
			if(data_ready_out)
			begin
				tb_externalEn = 1;
				if(test6_expected[719:712] == tb_externalChar)
				begin 
					$info("Pass on ascii character: %0d", tb_externalChar);
				end
				else
				begin
					$info("Fail on ascii character: %0d", tb_externalChar);
				end
				
				test6_expected = test6_expected << 8;
			end
			else
			begin
				tb_externalEn = 0;
			end
			
			//#(NORM_DATA_PERIOD);
			testStuff6 = testStuff6 << 8;
		end

/*	
// Test 3: Corner Case- Path Longer than 12 (lookupCreate)
		tb_test_num = tb_test_num + 1;

		counter = 0;
		testStuff3 = 24'b011000011101000000000000;

		for(counter = 0; counter < 24; counter += 8)
		begin
			holdStuff = testStuff3[23:16];
			send_packet(holdStuff);
			#(NORM_DATA_PERIOD);
			testStuff3 = testStuff3 << 8;
		end
			
	
// Test 4: Corner Case- Path Longer than 12 (decode block)
		tb_test_num = tb_test_num + 1;

		counter = 0;
		testStuff4 = 64'b0110110000101100000000000000000011110000000000001101000000000000;

		for(counter = 0; counter < 80; counter += 8)
		begin
			holdStuff = testStuff4[63:56];
			send_packet(holdStuff);
			#(NORM_DATA_PERIOD);
			testStuff4 = testStuff4 << 8;
		end

// Test 5: Corner Case- Path Longer than 12 (decode block)
		tb_test_num = tb_test_num + 1;

		counter = 0;
		testStuff4 = 64'b0101010101011110000000000000111100000000000000000001001001101100;

		for(counter = 0; counter < 80; counter += 8)
		begin
			holdStuff = testStuff4[7:0];
			send_packet(holdStuff);
			#(NORM_DATA_PERIOD);
			testStuff4 = testStuff4 >> 8;
		end
		

*/


	
	end
endmodule 

