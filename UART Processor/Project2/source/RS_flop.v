`timescale 1ns / 1ps
//****************************************************************//
//  This document contains information proprietary to the         //
//  CSULB student that created the file - any reuse without       //
//  adequate approval and documentation is prohibited             //
//                                                                //
//  Class: <CECS 460>                                             //
//  Project name: <Project 2>                                     //
//  File name: <RS_flop.v>                                        //
//                                                                //
//  Created by <Chou Thao> on <2/16/17>.                          //
//  Copyright © 2016 <Chou Thao>. All rights reserved.            //
//                                                                //
//  Abstract: <This module is controls an interrupt signal. It    //
//             sets up an interrupt output, intr, when an input   //
//             set goes high. It's intr is set back to low once   //
//             an acknowledge, ack goes high, is recieved.>       //
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
module RS_flop(clk, rst, set, ack, intr);
	input      clk, rst, set, ack;
	output reg intr;
	
	// initialize intr low
	// if set high then intr high
	// if ack high then intr low
	always@(posedge clk, posedge rst)
		if (rst == 1'b1)
			intr = 1'b0;
		else if (set == 1'b1)
			intr = 1'b1;
		else if (ack == 1'b1)
			intr = 1'b0;
		
endmodule
