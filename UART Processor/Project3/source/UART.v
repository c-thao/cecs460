`timescale 1ns / 1ps
//****************************************************************//
//  This document contains information proprietary to the         //
//  CSULB student that created the file - any reuse without       //
//  adequate approval and documentation is prohibited             //
//                                                                //
//  Class: <CECS 460>                                             //
//  Project name: <Project 3>                                     //
//  File name: <UART.v>                                           //
//                                                                //
//  Created by <Chou Thao> on <4/27/17>.                          //
//  Copyright © 2016 <Chou Thao>. All rights reserved.            //
//                                                                //
//  Abstract: <This module is a UART system which incorporates    //
//             both a transmit module, TX, and a receive module,  //
//             RX. This module also instantiates a mux to deter-  //
//             mine a baud rate input for both modules. The UART  //
//             also handles a interrupt signal TXRDY and RXRDY    //
//             data is ready on either line.>                     //
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
module UART(clk, rst, load, read, RX, EIGHT, PEN, OHEL, BAUD, OUT_PORT,
				UART_INTR, TX, IN_PORT);
	input        clk, rst, load;
	input  [1:0] read;
	input        RX;
	input        EIGHT, PEN, OHEL;
	input  [3:0] BAUD;
	input  [7:0] OUT_PORT;
	
	output           UART_INTR;
	output           TX;
	output [7:0] IN_PORT;
	 
	// clock ticks for baud
	reg  [18:0] MAX;
	wire [18:0] k;
	
	// error status
	wire [2:0] STATUS;
	
	// RX data
	wire [7:0] RDATA;
	
	// interrupts
	wire TXRDY, RXRDY;
	wire TX_RDY, RX_RDY;
	
	// update our UART_INTR
	assign UART_INTR = TX_RDY | RX_RDY; // need to update for ped for both signals to drop interrupt signal
	
	// update maximum clock ticks
	// for baud
	assign k = MAX;
	
	// update IN_PORT as a wire
		assign IN_PORT = (read[0]) ? RDATA :
		                 (read[1]) ? {3'b0, STATUS, TXRDY, RXRDY}:
							              8'b0;
	
	// baud rate decoder
	always@(*)
		case(BAUD)
		4'b0000 : MAX <= 333333; // 300 baud
		4'b0001 : MAX <= 83333;  // 1200 baud
		4'b0010 : MAX <= 41667;  // 2400 baud
		4'b0011 : MAX <= 20833;  // 4800 baud
		4'b0100 : MAX <= 10417;  // 9600 baud
		4'b0101 : MAX <= 5208;   // 19200 baud
		4'b0110 : MAX <= 2604;   // 38400 baud
		4'b0111 : MAX <= 1736;   // 57600 baud
		4'b1000 : MAX <= 868;    // 115200 baud
		4'b1001 : MAX <= 434;    // 230400 baud
		4'b1010 : MAX <= 217;    // 460800 baud
		4'b1011 : MAX <= 109;    // 921600 baud
		default : MAX <= 333333; // 300 baud
		endcase
		
	// TX ENGINE
	TX transmit (.clk(clk), .rst(rst), .load(load), .max(k), .EIGHT(EIGHT),
					 .PEN(PEN), .OHEL(OHEL), .OUT_PORT(OUT_PORT), .TXRDY(TXRDY),
					 .TX(TX));
	
	// PED transmit
	pulse_maker trans_edge (.clk(clk), .rst(rst), .in(TXRDY), .pulse(TX_RDY));
	
	// RX engine
	RX reciever (.clk(clk), .rst(rst), .read(read[0]), .RX(RX), .max(k), .EIGHT(EIGHT),
					 .PEN(PEN), .OHEL(OHEL), .RX_STATUS(STATUS), .RXRDY(RXRDY), .UART_RDATA(RDATA));
	
	// PED transmit
	pulse_maker rec_edge (.clk(clk), .rst(rst), .in(RXRDY), .pulse(RX_RDY));
	
endmodule
