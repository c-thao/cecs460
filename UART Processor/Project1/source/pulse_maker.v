`timescale 1ns / 1ps
//****************************************************************//
//  This document contains information proprietary to the         //
//  CSULB student that created the file - any reuse without       //
//  adequate approval and documentation is prohibited             //
//                                                                //
//  Class: <CECS 460>                                             //
//  Project name: <Project 1>                                     //
//  File name: <pulse_maker.v>                                    //
//                                                                //
//  Created by <Chou Thao> on <9/14/16>.                          //
//  Copyright © 2016 <Chou Thao>. All rights reserved.            //
//                                                                //
//  Abstract: <This is a pulse maker module, more so an edge de-  //
//             tector, which pulses a clock wide output when an   //
//             input in is high.>                                 //
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
module pulse_maker(clk, rst, in, pulse);
   input        clk, rst, in;
	output       pulse;
	
	reg [1:0] q;
	
	assign pulse = (q[0] && ~q[1]);
	
	always@(posedge clk, posedge rst)
	   if(rst)                // if rst is high set q to 2'b0
		   q <= 2'b00;
		else                   // else bring in input in through
		   q <= {q[0], in};    // q[0] to q[1]
	
endmodule
