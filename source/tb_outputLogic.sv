`timescale 1ns / 10ps

module tb_outputLogic ();

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

	reg [7:0] Table [256:0];
	reg [3:0] tb_length;
	reg tb_writeComp;
	reg [11:0] tb_location;
	reg tb_enable_out;
	reg [7:0] tb_charOut;	

	generate

		outputLogic DUT (.Table(tb_Table), .location(tb_location), .length(tb_length), .enable_out(tb_enable_out), .writeComp(tb_writeComp), .charOut(tb_charOut));

	endgenerate

	clocking cb @(posedge tb_clk);
 		
		default input #1step output #100ps; 
		
		output Table = tb_Table;
		output location = tb_location;
		output length = tb_length;
		output enable_out = tb_enable_out;
		input charOut = tb_charOut;
		input writeComp = tb_writeComp;
		
	endclocking

	initial begin		
		tb_test_num		= 1'b0;
		
		@cb
		@cb

		
//Test 1:
		tb_test_num = tb_test_num + 1;
		
		if (tb_writeComp == cb.writeComp)	
			$info("Test Case %0d:: PASSED", tb_test_num);
		else
			$error("Test Case %0d:: FAILED", tb_test_num);
			
		if (tb_charOut == cb.charOut)	
			$info("Test Case %0d:: PASSED", tb_test_num);
		else
			$error("Test Case %0d:: FAILED", tb_test_num);


		@cb;

// Test 2:
		tb_test_num = tb_test_num + 1;
		

		if (tb_writeComp == cb.writeComp)	
			$info("Test Case %0d:: PASSED", tb_test_num);
		else
			$error("Test Case %0d:: FAILED", tb_test_num);
			
		if (tb_charOut == cb.charOut)	
			$info("Test Case %0d:: PASSED", tb_test_num);
		else
			$error("Test Case %0d:: FAILED", tb_test_num);

// Test 3: 
		tb_test_num = tb_test_num + 1;
		
		if (tb_writeComp == cb.writeComp)	
			$info("Test Case %0d:: PASSED", tb_test_num);
		else
			$error("Test Case %0d:: FAILED", tb_test_num);
			
		if (tb_charOut == cb.charOut)	
			$info("Test Case %0d:: PASSED", tb_test_num);
		else
			$error("Test Case %0d:: FAILED", tb_test_num);


// Test 4:
		tb_test_num = tb_test_num + 1;

		if (tb_writeComp == cb.writeComp)	
			$info("Test Case %0d:: PASSED", tb_test_num);
		else
			$error("Test Case %0d:: FAILED", tb_test_num);
			
		if (tb_charOut == cb.charOut)	
			$info("Test Case %0d:: PASSED", tb_test_num);
		else
			$error("Test Case %0d:: FAILED", tb_test_num);

			
	end
endmodule 

