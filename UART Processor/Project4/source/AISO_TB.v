`timescale 1ns / 1ps
//****************************************************************//
//  This document contains information proprietary to the         //
//  CSULB student that created the file - any reuse without       //
//  adequate approval and documentation is prohibited             //
//                                                                //
//  Class: <CECS 460>                                             //
//  Project name: <Project 3>                                     //
//  File name: <AISO_TB.v>                                        //
//                                                                //
//  Created by <Chou Thao> on <5/16/17>.                          //
//  Copyright © 2016 <Chou Thao>. All rights reserved.            //
//                                                                //
//  Abstract: <This test bench testes the funcitonality of the    //
//             the system's AISO, verifying the behaviour of the  //
//             reset design.>                                     //
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

module AISO_TB;

	// Inputs
	reg clk;
	reg rst;

	// Outputs
	wire rst_s;

	// Instantiate the Unit Under Test (UUT)
	AISO uut (
		.clk(clk), 
		.rst(rst), 
		.rst_s(rst_s)
	);
	
	always #5 clk=~clk;

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;

		// Wait 100 ns for global reset to finish
		#20;
		rst=1'b1;
		#100;
      rst=1'b0;
		#100;

	end
      
endmodule

