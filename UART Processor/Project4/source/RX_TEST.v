`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   17:34:26 04/11/2017
// Design Name:   RX
// Module Name:   C:/Users/CHOU/Desktop/cecs460/Project3/project3/RX_TEST.v
// Project Name:  project3
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: RX
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module RX_TEST;

	// Inputs
	reg clk;
	reg rst;
	reg read;
	reg [19:0] max;
	reg RX;
	reg EIGHT;
	reg PEN;
	reg OHEL;

	// Outputs
	wire [2:0] RX_STATUS;
	wire RXRDY;
	wire [7:0] UART_RDATA;

	// Instantiate the Unit Under Test (UUT)
	RX uut (
		.clk(clk), 
		.rst(rst), 
		.read(read), 
		.max(max), 
		.RX(RX), 
		.EIGHT(EIGHT), 
		.PEN(PEN), 
		.OHEL(OHEL), 
		.RX_STATUS(RX_STATUS), 
		.RXRDY(RXRDY), 
		.UART_RDATA(UART_RDATA)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		read = 0;
		max = 0;
		RX = 0;
		EIGHT = 0;
		PEN = 0;
		OHEL = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

