`timescale 1ns / 1ps
//****************************************************************//
//  This document contains information proprietary to the         //
//  CSULB student that created the file - any reuse without       //
//  adequate approval and documentation is prohibited             //
//                                                                //
//  Class: <CECS 460>                                             //
//  Project name: <Project 3>                                     //
//  File name: <TX.v>                                             //
//                                                                //
//  Created by <Chou Thao> on <4/27/17>.                          //
//  Copyright © 2016 <Chou Thao>. All rights reserved.            //
//                                                                //
//  Abstract: <This module is a transmit engine which loads in    //
//             a shift register an 8 bit input, OUT_PORT, when    //
//             input signal load goes high. Upon assertion of     //
//             load, output register TXRDY goes low. Then the     //
//             shift register perodically shifts out the data     //
//             upon the assertion of signal BTU which causes      //
//             the output, TX, to output the next data from the   //
//             the shift register. A counter register, bit_count  //
//             increments for each BTU assertion and once it is   //
//             equivalent to 4'b1011, a signal wire DONE goes     //
//             high. Once DONE is high, output TXRDY will go high //
//             following DONE signaling the shift register to     //
//             stop.>                                             //
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
module TX(clk, rst, load, max, EIGHT, PEN, OHEL, OUT_PORT, TXRDY, TX);
	input        clk, rst, load;
	input        EIGHT, PEN, OHEL;
	input  [7:0] OUT_PORT;
	input [18:0] max;
	
	output reg  TXRDY;
	output      TX;
	
	// signals
	wire       BTU;
	wire       DONE;
	wire [1:0] EPAR;
	
	// signals
	reg       DOIT;
	reg       LOADDI;
	
	// data registers
	reg [10:0] SR;
	reg  [7:0] LDATA;
	
	// count registers
	reg [18:0] bt_count;
	reg  [3:0] bit_count;
	
	// clk to TX signal
	assign BTU = (bt_count == max) ? 1'b1: 1'b0;
	
	// if rst high set bt_count to 20'b0
	// if bt_count is equal to max set
	// bt_count to 20'b0 else increment
	// bt_count by 20'b1 (BAUD RATE) when
	// DOIT is high
	always@(posedge clk, posedge rst)
		if (rst)
			bt_count <= 19'b0;
		else if (bt_count == max)
			bt_count <= 19'b0;
		else if (DOIT)
			bt_count <= bt_count + 19'b1;
		else
			bt_count <= bt_count;
			
	// DONE signal goes high when bit_count
	// reaches max value, 4'b1011
	assign DONE = (bit_count == 4'b1011);
			
	// if rst high set bit_count to 3'b0
	// if bit_count is equal to 3'b111 set
	// bit_count to 3'b0 else increment
	// bit_count by 3'b1 when both DOIT &
	// BTU is high
	always@(posedge clk, posedge rst)
		if (rst)
			bit_count <= 4'b0;
		else if (bit_count == 4'b1011)
			bit_count <= 4'b0;
		else if ({DOIT,BTU} == 2'b11)
			bit_count <= bit_count + 4'b1;
		else
			bit_count <= bit_count;
			
	// if rst high set DOIT low else if
	// DONE is high set DOIT low else if
	// LOADDI is high set DOIT high
	always@(posedge clk, posedge rst)
		if (rst)
			DOIT <= 1'b0;
		else if (DONE)
			DOIT <= 1'b0;
		else if (LOADDI)
			DOIT <= 1'b1;
		else
			DOIT <= DOIT;
	
	//	if rst high set LOADDI low
	// else if set LOADDI to load
	always@(posedge clk, posedge rst)
		if (rst)
			LOADDI <= 1'b0;
		else
			LOADDI <= load;
			
	// loadable data register
	always@(posedge clk, posedge rst)
		if (rst)
			LDATA <= 8'b0;
		else if (load)
			LDATA <= OUT_PORT;
		else
			LDATA <= LDATA;
			
	// two bit data from eight and parity
	assign EPAR = ({EIGHT, PEN, OHEL} == 3'b000) ?  2'b11 :
					  ({EIGHT, PEN, OHEL} == 3'b001) ?  2'b11 :
					  ({EIGHT, PEN, OHEL} == 3'b010) ?  {1'b1, (^LDATA[6:0])} :
					  ({EIGHT, PEN, OHEL} == 3'b011) ?  {1'b1, ~(^LDATA[6:0])} :
					  ({EIGHT, PEN, OHEL} == 3'b100) ?  {1'b1, LDATA[7]}:
					  ({EIGHT, PEN, OHEL} == 3'b101) ?  {1'b1, LDATA[7]}:
					  ({EIGHT, PEN, OHEL} == 3'b110) ?  {(^LDATA[7:0]), LDATA[7]} :
																	{~(^LDATA[7:0]), LDATA[7]};
					  
	// shift register
	always@(posedge clk, posedge rst)
		if (rst)
			SR <= 11'b11111111111;
		else if (LOADDI)
			SR <= {EPAR,LDATA[6:0], 1'b0, 1'b1};
		else if (BTU)
			SR <= {1'b1, SR[10:1]};
		else
			SR <= SR;
			
	// data bit to be transmitted
	assign TX = (SR[0]);
		
	// determine TXRDY active low
	always@(posedge clk, posedge rst)
		if (rst)
			TXRDY <= 1'b1;
		else if (load)
			TXRDY <= 1'b0;
		else if (DONE)
			TXRDY <= 1'b1;
		else
			TXRDY <= TXRDY;

endmodule
