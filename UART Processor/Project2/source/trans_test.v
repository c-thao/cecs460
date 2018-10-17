`timescale 1ns / 1ps
//****************************************************************//
//  This document contains information proprietary to the         //
//  CSULB student that created the file - any reuse without       //
//  adequate approval and documentation is prohibited             //
//                                                                //
//  Class: <CECS 460>                                             //
//  Project name: <Project 2>                                     //
//  File name: <trans_test.v>                                     //
//                                                                //
//  Created by <Chou Thao> on <4/6/17>.                           //
//  Copyright © 2016 <Chou Thao>. All rights reserved.            //
//                                                                //
//  Abstract: <This testbench checks to verify the operation      //
//             of the transmit engine, TX. Inspecting both the    //
//             integrity of data output, TX, and the eight bit    //
//             and parity bit. >                                  //
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
module trans_test;

	// Inputs
	reg clk;
	reg rst;
	reg load;
	reg [18:0] max;
	reg EIGHT;
	reg PEN;
	reg OHEL;
	reg [7:0] OUT_PORT;

	// Outputs
	wire TXRDY;
	wire TX;
	
	// integer
	integer i, j;

	// Instantiate the Unit Under Test (UUT)
	TX uut (
		.clk(clk), 
		.rst(rst), 
		.load(load), 
		.max(max), 
		.EIGHT(EIGHT), 
		.PEN(PEN), 
		.OHEL(OHEL), 
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
		max = 19'b0;
		EIGHT = 1'b0;
		PEN = 1'b0;
		OHEL = 1'b0;
		OUT_PORT = 8'b0;

		// Wait 100 ns for global reset to finish
		rst = 1'b1;
		#100;
		rst = 1'b0;
        
		// initialization of control words
		@(posedge clk)
		max = 109; // fastest baud rate at 921600
		OUT_PORT = 8'b01010101; // random initial value
		
		for(j=0;j<8;j=j+1) begin
			// change 8 bit enable, parity, odd/even
			{EIGHT,PEN,OHEL} = j;
			OUT_PORT = OUT_PORT + j; // change data transmitted
			@(posedge clk)
			load = 1'b1;
			// disable load
			@(posedge clk)
			load = 1'b0;
			$display("\nNew Transmission LSB->MSB");
			$display("{EIGHT,PEN,OHEL}=%b  data=%b ", {EIGHT,PEN,OHEL}, OUT_PORT);
				// check each transmission of data
				for(i=0;i<11;i=i+1) begin
					@(posedge uut.BTU)
					#11;
					$display("TX=%b", TX);
				end
			if(PEN) begin
				if(EIGHT) begin
					if(OHEL)
						// display parity odd
						$display("odd parity bit=%b",(~^OUT_PORT));
					else
						// display parity even
						$display("even parity bit=%b",(^OUT_PORT));
				end
				else begin
					if(OHEL)
						// display parity odd
						$display("odd parity bit=%b",(~^OUT_PORT[6:0]));
					else
						// display parity even
						$display("even parity bit=%b",(^OUT_PORT[6:0]));
				end
			end
			$stop;
		end
	$finish;	
	end
      
endmodule

