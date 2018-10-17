`timescale 1ns / 1ps
//****************************************************************//
//  This document contains information proprietary to the         //
//  CSULB student that created the file - any reuse without       //
//  adequate approval and documentation is prohibited             //
//                                                                //
//  Class: <CECS 460>                                             //
//  Project name: <Project 2>                                     //
//  File name: <dec.v>                                            //
//                                                                //
//  Created by <Chou Thao> on <2/16/17>.                          //
//  Copyright © 2016 <Chou Thao>. All rights reserved.            //
//                                                                //
//  Abstract: <This is a decoder which takes in a 4 bit port_id,  //
//             a read_strobe and write_strobe to determine which  //
//             what outputs to read and write.>                   //
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
module dec(read_strobe, write_strobe, port_id, read, write);
	 input             read_strobe, write_strobe;
	 input       [3:0] port_id;
	 output reg [15:0] read, write;
	 
	 // initialize read and write then 
	 // update the two 16 bit registers
	 // accordingly to the input port_id
	 always @(*)
	 begin
		read = 16'b0;
		write = 16'b0;
		write[port_id] = write_strobe;
		read[port_id] = read_strobe;
	 end

endmodule
