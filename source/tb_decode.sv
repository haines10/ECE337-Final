`timescale 1ns / 10ps

module tb_decode ();

	localparam	CLK_PERIOD	= 2.5;
	localparam	TEST_DELAY = 1;
	//comment
	reg tb_clk;
	
	always
	begin
		tb_clk = 1'b0;
		#(CLK_PERIOD/2.0);
		tb_clk = 1'b1;
		#(CLK_PERIOD/2.0);
	end
	
	localparam 	DEFAULT_SIZE = 4;
	integer tb_test_num;
	reg tb_n_rst;
	reg [7:0] tb_rx_data;
	reg tb_data_ready;
	reg tb_overrun_error;
	reg tb_framing_error;
	reg tb_lookupDone;
	reg tb_writeComp;
	reg tb_data_read;
	reg [11:0] tb_location;
	reg [3:0] tb_length;
	reg tb_enable;
	reg tb_decodeDone;	

	generate

		decode DUT (.clk(tb_clk), .n_rst(tb_n_rst), .rx_data(tb_rx_data), .data_ready(tb_data_ready), .overrun_error(tb_overrun_error), .framing_error(tb_framing_error), .lookupDone(tb_lookupDone), .writeComp(tb_writeComp), .data_read(tb_data_read), .location(tb_location), .length(tb_length), .enable(tb_enable), .decodeDone(tb_decodeDone));

	endgenerate

	clocking cb @(posedge tb_clk);
 		// 1step means 1 time precision unit, 10ps for this module. We assume the hold time is less than 200ps.
		default input #1step output #100ps; 
		output #800ps n_rst = tb_n_rst; 
		output  rx_data = tb_rx_data;
		output 	data_ready = tb_data_ready;
		output overrun_error = tb_overrun_error;
		output framing_error = tb_framing_error;
		output lookupDone = tb_lookupDone;
		output writeComp = tb_writeComp;
		input data_read = tb_data_read;
		input location = tb_location;
		input length = tb_length;
		input enable = tb_enable;
		input decodeDone = tb_decodeDone;
		
	endclocking

	initial begin
		tb_n_rst		= 1'b1;			
		tb_test_num		= 1'b0;
	
		@(negedge tb_clk);
		tb_n_rst	<= 1'b0; 	
		@cb;
		cb.n_rst	<= 1'b1; 	
		
		@cb
		@cb

		
//Test 1:
		tb_test_num = tb_test_num + 1;
		
		cb.n_rst	<= 1'b0;
		
		if (tb_data_read == cb.data_read)	
			$info("Test Case %0d:: PASSED", tb_test_num);
		else
			$error("Test Case %0d:: FAILED", tb_test_num);
			
		if (tb_location == cb.location)	
			$info("Test Case %0d:: PASSED", tb_test_num);
		else
			$error("Test Case %0d:: FAILED", tb_test_num);
			
		if (tb_length == cb.length)	
			$info("Test Case %0d:: PASSED", tb_test_num);
		else
			$error("Test Case %0d:: FAILED", tb_test_num);	
	
		if (tb_enable == cb.enable)	
			$info("Test Case %0d:: PASSED", tb_test_num);
		else
			$error("Test Case %0d:: FAILED", tb_test_num);
		
		if (tb_decodeDone == cb.decodeDone)	
			$info("Test Case %0d:: PASSED", tb_test_num);
		else
			$error("Test Case %0d:: FAILED", tb_test_num);
			
		@cb;

// Test 2:
		tb_test_num = tb_test_num + 1;
		
		cb.n_rst	<= 1'b0;
		
		if (tb_data_read == cb.data_read)	
			$info("Test Case %0d:: PASSED", tb_test_num);
		else
			$error("Test Case %0d:: FAILED", tb_test_num);
			
		if (tb_location == cb.location)	
			$info("Test Case %0d:: PASSED", tb_test_num);
		else
			$error("Test Case %0d:: FAILED", tb_test_num);
			
		if (tb_length == cb.length)	
			$info("Test Case %0d:: PASSED", tb_test_num);
		else
			$error("Test Case %0d:: FAILED", tb_test_num);	
	
		if (tb_enable == cb.enable)	
			$info("Test Case %0d:: PASSED", tb_test_num);
		else
			$error("Test Case %0d:: FAILED", tb_test_num);
		
		if (tb_decodeDone == cb.decodeDone)	
			$info("Test Case %0d:: PASSED", tb_test_num);
		else
			$error("Test Case %0d:: FAILED", tb_test_num);
			
		@cb;
			

// Test 3: 
		tb_test_num = tb_test_num + 1;
		
		cb.n_rst	<= 1'b0;
		
		if (tb_data_read == cb.data_read)	
			$info("Test Case %0d:: PASSED", tb_test_num);
		else
			$error("Test Case %0d:: FAILED", tb_test_num);
			
		if (tb_location == cb.location)	
			$info("Test Case %0d:: PASSED", tb_test_num);
		else
			$error("Test Case %0d:: FAILED", tb_test_num);
			
		if (tb_length == cb.length)	
			$info("Test Case %0d:: PASSED", tb_test_num);
		else
			$error("Test Case %0d:: FAILED", tb_test_num);	
	
		if (tb_enable == cb.enable)	
			$info("Test Case %0d:: PASSED", tb_test_num);
		else
			$error("Test Case %0d:: FAILED", tb_test_num);
		
		if (tb_decodeDone == cb.decodeDone)	
			$info("Test Case %0d:: PASSED", tb_test_num);
		else
			$error("Test Case %0d:: FAILED", tb_test_num);
			
		@cb;
			
	
// Test 4:
		tb_test_num = tb_test_num + 1;

		cb.n_rst	<= 1'b0;
		
		if (tb_data_read == cb.data_read)	
			$info("Test Case %0d:: PASSED", tb_test_num);
		else
			$error("Test Case %0d:: FAILED", tb_test_num);
			
		if (tb_location == cb.location)	
			$info("Test Case %0d:: PASSED", tb_test_num);
		else
			$error("Test Case %0d:: FAILED", tb_test_num);
			
		if (tb_length == cb.length)	
			$info("Test Case %0d:: PASSED", tb_test_num);
		else
			$error("Test Case %0d:: FAILED", tb_test_num);	
	
		if (tb_enable == cb.enable)	
			$info("Test Case %0d:: PASSED", tb_test_num);
		else
			$error("Test Case %0d:: FAILED", tb_test_num);
		
		if (tb_decodeDone == cb.decodeDone)	
			$info("Test Case %0d:: PASSED", tb_test_num);
		else
			$error("Test Case %0d:: FAILED", tb_test_num);
			
		@cb;
			
	end
endmodule 

