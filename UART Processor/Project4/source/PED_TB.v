`timescale 1ns / 1ps
//****************************************************************//
//  This document contains information proprietary to the         //
//  CSULB student that created the file - any reuse without       //
//  adequate approval and documentation is prohibited             //
//                                                                //
//  Class: <CECS 460>                                             //
//  Project name: <Project 3>                                     //
//  File name: <PED_TB.v>                                         //
//                                                                //
//  Created by <Chou Thao> on <5/16/17>.                          //
//  Copyright © 2016 <Chou Thao>. All rights reserved.            //
//                                                                //
//  Abstract: <This test bench testes the funcitonality of the    //
//             the system's pulse maker, verifying the behaviour  //
//             of the pulse maker to generate a one clock wide    //
//             output pulse.>                                     //
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

module PED_TB;

	// Inputs
	reg clk;
	reg rst;
	reg in;

	// Outputs
	wire pulse;

	// Instantiate the Unit Under Test (UUT)
	pulse_maker uut (
		.clk(clk), 
		.rst(rst), 
		.in(in), 
		.pulse(pulse)
	);
	
	always #5 clk = ~clk;

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		in = 0;

		// Wait 100 ns for global reset to finish
		rst = 1'b1;
		#100;
		rst = 1'b0;
        
		// Add stimulus here
		@(posedge clk)
		in = 1'b1;
		#50;
		@(posedge clk)
		in = 1'b0;
		#20;
		@(posedge clk)
		in = 1'b1;
		#10
		@(posedge clk)
		in = 1'b0;
		#20;
		$finish;

	end
      
endmodule

