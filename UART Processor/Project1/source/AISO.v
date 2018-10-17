`timescale 1ns / 1ps
//****************************************************************//
//  This document contains information proprietary to the         //
//  CSULB student that created the file - any reuse without       //
//  adequate approval and documentation is prohibited             //
//                                                                //
//  Class: <CECS 460>                                             //
//  Project name: <Project 1>                                     //
//  File name: <AISO.v>                                           //
//                                                                //
//  Created by <Chou Thao> on <9/14/16>.                          //
//  Copyright © 2016 <Chou Thao>. All rights reserved.            //
//                                                                //
//  Abstract: <This module is an asynchronous in synchronous out  //
//             reset where an assertion of a reset input(rst)     //
//             asserts an output rst_s to go high. Whenever the   //
//             input rst is deasserted a 1 is driven through the  //
//             the least significant bit of a 2 bit register Q in //
//             turn deasserting the output rst_s.>                //
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
module AISO(clk, rst, rst_s);
	input  clk, rst;
	output rst_s;
	reg    [1:0] Q;
	
	assign rst_s = ~Q[0];     // rst_s is asserted when Q[0] is
	                          // low
	
	always@(posedge clk, posedge rst)
		if(rst)                // if rst is high set Q to 2'b0
		   Q <= 2'b00;
		else                   // else drop a 1'b1 into Q[0] and
			Q <= {Q[0],1'b1};   // bring it through to Q[1]
	
endmodule
