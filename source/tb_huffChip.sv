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
	reg [7:0] holdStuff;
	reg dataLoss;	
	reg data_ready_out;
	integer counter;
	reg [39:0] tb_expected_string1;
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
		#0.1; 
		
		// Test case 0: Basic Power on Reset
		//tb_test_case = 0;
		
		// Power-on Reset Test case: Simply populate the expected outputs
		// These values don't matter since it's a reset test but really should be set to 'idle'/inactive values
		holdStuff 				= '1;
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
		reset_dut;


//Test 1: The letter "l"
		tb_test_num = tb_test_num + 1;
		testStuff = 80'b00000000000011110000000000010010000000000000111100000000000000000001001001101100;
		
		for(counter = 0; counter < 80; counter += 8)
		begin
			holdStuff = testStuff[7:0];
			send_packet(holdStuff);
			#(NORM_DATA_PERIOD);
			testStuff = testStuff >> 8;
			/*if(data_ready_out)
			begin
				if(tb_externalChar == char[counter2])
					$info("Test Passed");
				else
					$info("Test Failed");
			*/	
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
		*/
		
		
		
		
		
		
			

// Test 2: The word "hello"
			
		tb_test_num = tb_test_num + 1;
		counter = 0;
		testStuff2 = 216'b000000000101001101100101000000000110001101101000000000000000000101101100000000000111001101101111111111111111111111111111000000000110001100000000010100110000000000000001000000000000000100000000011100111111111111111111;
		tb_expected_string1 = 40'b0110100001100101011011000110110001101111;
		
		for(counter = 0; counter < 80; counter += 8)
		begin
			holdStuff = testStuff2[7:0];
			send_packet(holdStuff);
			#(NORM_DATA_PERIOD);
			testStuff2 = testStuff2 >> 8;
			if(data_ready_out)
			begin
				if(tb_externalChar == tb_expected_string1[39:32])
					$info("Test Passed");
				else
					$info("Test Failed");
				tb_expected_string1 = tb_expected_string1 << 8;
			end
		end
		
// Test 3: Corner Case- Path Longer than 12 (lookupCreate)
		tb_test_num = tb_test_num + 1;

		counter = 0;
		testStuff3 = 24'b010101010101111001100001;

		for(counter = 0; counter < 80; counter += 8)
		begin
			holdStuff = testStuff3[7:0];
			send_packet(holdStuff);
			#(NORM_DATA_PERIOD);
			testStuff3 = testStuff3 >> 8;
		end
			
	
// Test 4: Corner Case- Path Longer than 12 (decode block)
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
		
	end
endmodule 

