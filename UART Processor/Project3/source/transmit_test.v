`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   18:13:30 03/14/2017
// Design Name:   UART
// Module Name:   C:/Users/Chou Thao/Desktop/cecs460/Project2/Project2/transmit_test.v
// Project Name:  Project2
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: UART
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module transmit_test;

	// Inputs
	reg clk;
	reg rst;
	reg load;
	reg EIGHT;
	reg PEN;
	reg OHEL;
	reg [3:0] BAUD;
	reg [7:0] OUT_PORT;

	// Outputs
	wire TXRDY;
	wire TX;
	
	integer i;

	// Instantiate the Unit Under Test (UUT)
	UART uut (
		.clk(clk), 
		.rst(rst), 
		.load(load), 
		.EIGHT(EIGHT), 
		.PEN(PEN), 
		.OHEL(OHEL), 
		.BAUD(BAUD), 
		.OUT_PORT(OUT_PORT), 
		.TXRDY(TXRDY), 
		.TX(TX)
	);
	
	// 10ns period
	always #5 clk=~clk;

	initial begin
		// Initialize Inputs
		clk = 1'b0;
		rst = 1'b0;
		load = 1'b0;
		EIGHT = 1'b0;
		PEN = 1'b0;
		OHEL = 1'b0;
		BAUD = 4'b0;
		OUT_PORT = 8'b0;

		// Wait 100 ns for global reset to finish
		rst = 1'b1;
		#100;
		rst = 1'b0;
        
		// initialization of control words
		@(posedge clk)
		BAUD = 4'b1011; // lowest baud rate
		OUT_PORT = 8'b01010101; // random initial value
		load = 1'b1;
		
		// disable load
		@(posedge clk)
		load = 1'b0;
		
		// check each transmission of data
		for(i=0;i<11;i=i+1) begin
		@(posedge uut.uart_rxtx.transmit.BTU)
			#11;
			$display("TX=%b", TX);
			$stop;
		/*
			@(TX)
			#1;
			$display("TX=%b", TX);
			$stop;
		*/
		end
		$finish;
		
	end
      
endmodule

