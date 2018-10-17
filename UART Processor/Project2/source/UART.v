`timescale 1ns / 1ps
//****************************************************************//
//  This document contains information proprietary to the         //
//  CSULB student that created the file - any reuse without       //
//  adequate approval and documentation is prohibited             //
//                                                                //
//  Class: <CECS 460>                                             //
//  Project name: <Project 2>                                     //
//  File name: <UART.v>                                           //
//                                                                //
//  Created by <Chou Thao> on <4/6/17>.                           //
//  Copyright © 2016 <Chou Thao>. All rights reserved.            //
//                                                                //
//  Abstract: <This module is a UART system which instantiates    //
//             a module TX. This module also instantiates a mux   //
//             to determine a baud rate input to the module TX.>  //
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
module UART(clk, rst, load, EIGHT, PEN, OHEL, BAUD, OUT_PORT, TXRDY, TX);
	input       clk, rst, load;
	input       EIGHT, PEN, OHEL;
	input [3:0] BAUD;
	input [7:0] OUT_PORT;
	output      TXRDY;
	output      TX;
	 
	// clock ticks for baud
	reg  [18:0] max;
	wire [18:0] k;
	
	// update maximum clock ticks
	// for baud
	assign k = max;
	
	// baud rate decoder changes
	// maximum count value
	always@(*)
		case(BAUD)
		4'b0000 : max = 333333; // 300 baud
		4'b0001 : max = 83333;  // 1200 baud
		4'b0010 : max = 41667;  // 2400 baud
		4'b0011 : max = 20833;  // 4800 baud
		4'b0100 : max = 10417;  // 9600 baud
		4'b0101 : max = 5208;   // 19200 baud
		4'b0110 : max = 2604;   // 38400 baud
		4'b0111 : max = 1736;   // 57600 baud
		4'b1000 : max = 868;    // 115200 baud
		4'b1001 : max = 434;    // 230400 baud
		4'b1010 : max = 217;    // 460800 baud
		4'b1011 : max = 109;    // 921600 baud
		default : max = 333333; // 300 baud
		endcase
		
	// TX ENGINE
	TX transmit (.clk(clk), .rst(rst), .load(load), .max(k), .EIGHT(EIGHT),
					 .PEN(PEN), .OHEL(OHEL), .OUT_PORT(OUT_PORT), .TXRDY(TXRDY),
					 .TX(TX));
	
endmodule
