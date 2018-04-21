`timescale 1ns / 10ps

module tb_huffChip ();

	localparam	CLK_PERIOD	= 2.5;
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

	generate
		huffChip DUT (.serial_in(tb_serial_in), .clk(tb_clk), .n_rst(tb_n_rst), .externalEn(tb_externalEn), .externalChar(tb_externalChar));
	endgenerate

	clocking cb @(posedge tb_clk);
		default input #1step output #100ps; 
		output n_rst = tb_n_rst;
		output serial_in = tb_serial_in;
		output externalEn = tb_externalEn;
		input externalChar = tb_externalChar;
		
	endclocking

	initial begin	
//Test 1:
		tb_test_num = tb_test_num + 1;
		
			
		if (tb_externalChar == cb.externalChar)	
			$info("Test Case %0d:: PASSED", tb_test_num);
		else
			$error("Test Case %0d:: FAILED", tb_test_num);
			

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

