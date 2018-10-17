`timescale 1ns / 1ps
//****************************************************************//
//  This document contains information proprietary to the         //
//  CSULB student that created the file - any reuse without       //
//  adequate approval and documentation is prohibited             //
//                                                                //
//  Class: <CECS 460>                                             //
//  Project name: <Project 2>                                     //
//  File name: <top_level_test.v>                                 //
//                                                                //
//  Created by <Chou Thao> on <4/6/17>.                           //
//  Copyright © 2016 <Chou Thao>. All rights reserved.            //
//                                                                //
//  Abstract: <This testbench tests the functionality of the      //
//             top level module.>                                 //
//                                                                //
//  Edit history: <keep track of changes to the file>             //
//                                                                //
//  In submitting this file for class work at CSULB               //
//  I am confirming that this is my work and the work             //
//  of no one else.                                               //
//                                                                //
//  In the event other code sources are utilized I will           //
//  document which portion of code and who is the author          //
//                                                                //
// In submitting this code I acknowledge that plagiarism          //
// in student project work is subject to dismissal from the class //
//****************************************************************//
module top_level_test;

	// Inputs
	reg clk;
	reg rst;
	reg EIGHT;
	reg PEN;
	reg OHEL;
	reg [3:0] BAUD;

	// Outputs
	wire [3:0] anode;
	wire [6:0] sev;
	wire TX;
	wire [7:0] leds;
	
	// integer counter
	integer i, c, j;
	reg [10:0] buff;
	reg [15:0] bin;
	reg [15:0] quot;
	reg  [4:0] val [16:0];
	
	// Instantiate the Unit Under Test (UUT)
	top_level uut (
		.clk(clk), 
		.rst(rst), 
		.anode(anode), 
		.sev(sev), 
		.EIGHT(EIGHT), 
		.PEN(PEN), 
		.OHEL(OHEL), 
		.BAUD(BAUD), 
		.TX(TX),
		.leds(leds)
	);
	
	// initialize clock
	always #5 clk=~clk;
	
	// update buffer for data transmitted
	always@(posedge uut.uart_rxtx.transmit.BTU)begin
		#11;
		buff[c] = TX;
		if (c == 10)
			c = 0;
		else
			c = c + 1;
	end
	
	// for each led update check output
	always@(posedge uut.write[1]) begin
		#11;
		$display("leds=%b",leds);
	end
	
	initial begin
		// Initialize Inputs
		clk = 1'b0;
		rst = 1'b0;
		EIGHT = 1'b0;
		PEN = 1'b0;
		OHEL = 1'b0;
		BAUD = 4'b0;
		c = 0;

		// Wait 100 ns for global reset to finish
		#100;
		rst = 1'b1;
		#100;
		rst = 1'b0;
        
		// Add stimulus here
		@(posedge clk)
			BAUD = 4'b1011; // quickest baud rate
			$display("Initial");
		   $display("leds=%b",leds);
		
		// run initial transmission
		@(negedge uut.uart_rxtx.TXRDY)
			#1;
			$display("Serial data transmitted=%b", buff); // display tranmission
			$display("data transmitted=%h",buff[7:1]);    // display data transmitted
		
		for(i=0; i<8; i=i+1) begin
			$display("\nTransmission %d:",i+1);
			@(posedge clk)
			// changes 8 bit enable, parity enable
			// and odd or even parity bit
			{EIGHT,PEN,OHEL} = i;
			
			// run transmissions
			// print out of CSULB CECS 460 - (5 digit counter value)<CR><LF>
			for(j=0; j<24; j=j+1) begin
			@(posedge uut.uart_rxtx.TXRDY)
				#1;
				$display("Serial data transmitted=%b", buff); // display tranmission
				$display("data transmitted=%h",buff[7:1]);    // display data transmitted
			end
			$stop; // pause after one full message transmission
		end
		$finish;

	end
      
endmodule

