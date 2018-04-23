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
	reg [31:0] testStuff;
	reg [7:0] holdStuff;
	reg dataLoss;	
	reg data_ready_out;
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
//Test 1:
		tb_test_num = tb_test_num + 1;
		testStuff = 32'b01101000011001010110100001100001;
		holdStuff = testStuff[7:0];
		send_packet(holdStuff);
		#(NORM_DATA_PERIOD * 2);
		testStuff = testStuff >> 8;
		holdStuff = testStuff[7:0];
		send_packet(holdStuff);
		#(NORM_DATA_PERIOD * 2);
		
		
		
		
		
		
			

// Test 2:
		tb_test_num = tb_test_num + 1;
		
		if (tb_externalChar == cb.externalChar)	
			$info("Test Case %0d:: PASSED", tb_test_num);
		else
			$error("Test Case %0d:: FAILED", tb_test_num);
			

// Test 3: 
		tb_test_num = tb_test_num + 1;

		if (tb_externalChar == cb.externalChar)	
			$info("Test Case %0d:: PASSED", tb_test_num);
		else
			$error("Test Case %0d:: FAILED", tb_test_num);
			
	
// Test 4:
		tb_test_num = tb_test_num + 1;

		if (tb_externalChar == cb.externalChar)	
			$info("Test Case %0d:: PASSED", tb_test_num);
		else
			$error("Test Case %0d:: FAILED", tb_test_num);
			
	end
endmodule 

