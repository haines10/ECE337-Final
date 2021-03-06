`timescale 1ns / 10ps

module tb_lookupCreate();

	localparam	CLK_PERIOD	= 2.5;
	localparam	TEST_DELAY = 1;
	
	reg tb_clk;
	
	always
	begin
		tb_clk = 1'b0;
		#(CLK_PERIOD/2.0);
		tb_clk = 1'b1;
		#(CLK_PERIOD/2.0);
	end
	
	integer tb_test_num;
	reg tb_n_rst;
	reg [7:0] tb_rx_data;
	reg tb_data_ready;
	reg tb_overrun_error = 0;
	reg tb_framing_error= 0;
	reg tb_lookupDone;
	reg tb_saveComp= 0;
	reg tb_data_read;
	reg [7:0] tb_lookupTab;
	reg [11:0] tb_path;
	reg [3:0] tb_length;
	reg tb_enable;
	reg tb_decodeDone = 0;
	reg [175:0] tb_tester1;	

	generate

		lookupCreate DUT (.clk(tb_clk), .n_rst(tb_n_rst), .rx_data(tb_rx_data), .data_ready(tb_data_ready), .overrun_error(tb_overrun_error), .framing_error(tb_framing_error), .lookupDone(tb_lookupDone), .saveComp(tb_saveComp), .data_read(tb_data_read), .lookupTab(tb_lookupTab), .length(tb_length), .path(tb_path), .enable(tb_enable), .decodeDone(tb_decodeDone));

	endgenerate

	clocking cb @(posedge tb_clk);
 		
		default input #1step output #100ps; 
		output #800ps n_rst = tb_n_rst; 
		output  rx_data = tb_rx_data;
		output 	data_ready = tb_data_ready;
		output overrun_error = tb_overrun_error;
		output framing_error = tb_framing_error;
		output saveComp = tb_saveComp;
		output decodeDone = tb_decodeDone;
		input data_read = tb_data_read;
		input lookupTab = tb_lookupTab;
		input path = tb_path;
		input length = tb_length;
		input enable = tb_enable;
		input lookupDone = tb_lookupDone;
		
	endclocking

	task check_outputs;
		input tb_data_read;
		input [7:0] tb_lookupTab;
		input [3:0] tb_length;
		input tb_enable;
		input [11:0] tb_path;	
		input tb_lookupDone;
	begin
		if (tb_data_read == cb.data_read)	
			$info("Test Case %0d:: PASSED", tb_test_num);
		else
			$error("Test Case %0d:: FAILED", tb_test_num);
			
		if (tb_lookupTab == cb.lookupTab)	
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
		
		if (tb_path == cb.path)	
			$info("Test Case %0d:: PASSED", tb_test_num);
		else
			$error("Test Case %0d:: FAILED", tb_test_num);
		
		if (tb_lookupDone == cb.lookupDone)	
			$info("Test Case %0d:: PASSED", tb_test_num);
		else
			$error("Test Case %0d:: FAILED", tb_test_num);	
			
	end
endtask
		

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
		
		tb_n_rst	<= 1'b0; 	
		@cb;
		cb.n_rst	<= 1'b1;

		tb_tester1 = 176'b00000000001100100000000000010010000000000001001000000000001000100000000000000010000000000000001001100101000000000010001001101000000000000011001001101100000000110001001001101100;

 		tb_rx_data = tb_tester1[7:0];

		tb_data_ready = 1'b1;
		#(CLK_PERIOD * 2);
		tb_data_ready = 1'b0;
		#(CLK_PERIOD);
		tb_tester1 = tb_tester1 >> 8;
		tb_rx_data = tb_tester1[7:0];
		tb_data_ready = 1'b1;
		#(CLK_PERIOD * 2);
		tb_data_ready = 1'b0;
		#(CLK_PERIOD);
		tb_tester1 = tb_tester1 >> 8;
		tb_rx_data = tb_tester1[7:0];
		tb_data_ready = 1'b1;
		#(CLK_PERIOD);
		tb_data_ready = 1'b0;
		#(CLK_PERIOD);
		
		

		
		
		
			
		@cb;

/* Test 2:
		tb_test_num = tb_test_num + 1;
		
		cb.n_rst	<= 1'b0;
		
		if (tb_data_read == cb.data_read)	
			$info("Test Case %0d:: PASSED", tb_test_num);
		else
			$error("Test Case %0d:: FAILED", tb_test_num);
			
		if (tb_lookupTab == cb.lookupTab)	
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
		
		if (tb_path == cb.path)	
			$info("Test Case %0d:: PASSED", tb_test_num);
		else
			$error("Test Case %0d:: FAILED", tb_test_num);
		
		if (tb_lookupDone == cb.lookupDone)	
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
			
		if (tb_lookupTab == cb.lookupTab)	
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
		
		if (tb_path == cb.path)	
			$info("Test Case %0d:: PASSED", tb_test_num);
		else
			$error("Test Case %0d:: FAILED", tb_test_num);
		
		if (tb_lookupDone == cb.lookupDone)	
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
			
		if (tb_lookupTab == cb.lookupTab)	
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
		
		if (tb_path == cb.path)	
			$info("Test Case %0d:: PASSED", tb_test_num);
		else
			$error("Test Case %0d:: FAILED", tb_test_num);
		
		if (tb_lookupDone == cb.lookupDone)	
			$info("Test Case %0d:: PASSED", tb_test_num);
		else
			$error("Test Case %0d:: FAILED", tb_test_num);	
			
		@cb;
	*/		
	end
endmodule 

