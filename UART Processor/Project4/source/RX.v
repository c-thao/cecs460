`timescale 1ns / 1ps
//****************************************************************//
//  This document contains information proprietary to the         //
//  CSULB student that created the file - any reuse without       //
//  adequate approval and documentation is prohibited             //
//                                                                //
//  Class: <CECS 460>                                             //
//  Project name: <Project 3>                                     //
//  File name: <RX.v>                                             //
//                                                                //
//  Created by <Chou Thao> on <4/27/17>.                          //
//  Copyright © 2016 <Chou Thao>. All rights reserved.            //
//                                                                //
//  Abstract: <This module is a receive engine which loads in     //
//             a shift register an bit input, RX, when RX goes    //
//             low initiating a start of transmission. Then the   //
//             shift register perodically shifts in the data      //
//             upon the assertion of signal BTU. A counter re-    //
//             gister, bit_count, increments for each BTU assert- //
//             ion and once it is equivalent to max value, a sig- //
//             nal wire DONE goes high. Once DONE is high, output //
//             RXRDY will go high following DONE signaling the    //
//             shift register to stop.>                           //
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
module RX(clk, rst, read, max, RX, EIGHT, PEN, OHEL, RX_STATUS, RXRDY, UART_RDATA);
	input       clk, rst, read, RX;
	input       EIGHT, PEN, OHEL;
	input [18:0] max;
	
	output reg   RXRDY;
	output [2:0] RX_STATUS;
	output [7:0] UART_RDATA;
	
	// signals
	wire       BTU;
	wire       DONE;
	
	// remap combo
	wire [9:0] RM;
	
	// max value
	reg [19:0] k;
	
	// state registers
	reg       START, n_START;
	reg       DOIT, n_DOIT;
	reg [1:0] p_state, n_state;
	
	// status registers
	reg PERR, FERR, OVF;
	
	// shift register
	reg [9:0] SR;
	
	// count registers
	reg [18:0] bt_count;
	reg  [3:0] bit_count;
	
	// clk counts for BTU trigger
	always@(*)
		if ({START,DOIT} == 2'b11)
			k = max/2;
		else
			k = max;
	
	// clk to TX signal
	assign BTU = (bt_count == k) ? 1'b1: 1'b0;
	
	// if rst high set bt_count to 20'b0
	// if bt_count is equal to k set
	// bt_count to 20'b0 else increment
	// bt_count by 20'b1 (BAUD RATE) when
	// DOIT is high
	always@(posedge clk, posedge rst)
		if (rst)
			bt_count <= 19'b0;
		else if (bt_count == k)
			bt_count <= 19'b0;
		else if (DOIT)
			bt_count <= bt_count + 19'b1;
		else
			bt_count <= bt_count;
		
	// DONE if PEN & EIGTH are low then count to 8 (7 data bits &
	// 1 stop bit) else if EIGHT or PEN is high then count to 9 (8
	// data bits & 1 stop bit) else EIGHT & PEN are high then count
   //	to 10 (8 data bits, 1 parity bit, & 1 stop bit) else
	assign DONE = ({PEN,EIGHT} == 2'b00) ? (bit_count == 4'b1001) :
					  ({PEN,EIGHT} == 2'b01) ? (bit_count == 4'b1010) :
					  ({PEN,EIGHT} == 2'b10) ? (bit_count == 4'b1010) :
														(bit_count == 4'b1011);
			
	// if rst high set bit_count to 4'b0
	// if bit_count is equal to 4'b1010 set
	// bit_count to 4'b0 else increment
	// bit_count by 4'b1 when both DOIT &
	// BTU is high
	always@(posedge clk, posedge rst)
		if (rst)
			bit_count <= 4'b0;
		else if (DONE)
			bit_count <= 4'b0;
		else if ({DOIT,BTU} == 2'b11)
			bit_count <= bit_count + 4'b1;
		else
			bit_count <= bit_count;
			
	// shift register
	always@(posedge clk, posedge rst)
		if (rst)
			SR <= 10'b0;
		else if ({START,BTU} == 2'b01) begin
			//$display("RX=%b",RX);
			SR <= {RX,SR[9:1]};
		end
		else
			SR <= SR;
			
	// remap the shift register accordingly
	assign RM = ({EIGHT, PEN}==2'b00) ? {2'b0, SR[9:2]} :
	            ({EIGHT, PEN}==2'b01) ? {1'b0, SR[9:1]} :
					({EIGHT, PEN}==2'b10) ? {1'b0, SR[9:1]} :
						                           {SR[9:0]};
			
	// update UART_RDATA
	assign UART_RDATA = (EIGHT) ? {RM[7:0]} : {1'b0, RM[6:0]};
	
	// status flags
	assign RX_STATUS = {OVF, FERR, PERR};
														
	// Parity Error RS flop
	always@(posedge clk, posedge rst)
		if (rst)
			PERR <= 1'b0;
		else if (read)
			PERR <= 1'b0;
		else if ({DONE,PEN} == 2'b11) 
			case ({EIGHT,OHEL})
				2'b00 : PERR <= RM[7] ^ (^(RM[6:0]));
				2'b01 : PERR <= RM[7] ^ (~^(RM[6:0]));
				2'b10 : PERR <= RM[8] ^ (^(RM[7:0]));
				2'b11 : PERR <= RM[8] ^ (~^(RM[7:0]));
			endcase
		else
			PERR <= PERR;
			
	// framing error rs flop
	always@(posedge clk, posedge rst)
		if (rst)
			FERR <= 1'b0;
		else if (read)
			FERR <= 1'b0;
		else if(DONE)
			case({EIGHT,PEN})
				2'b00 : FERR <= ~RM[7];
				2'b01 : FERR <= ~RM[8];
				2'b10 : FERR <= ~RM[8];
				2'b11 : FERR <= ~RM[9];
			endcase
		else
			FERR <= FERR;
			
	// overflow error rs flop
	always@(posedge clk, posedge rst)
		if(rst)
			OVF <= 1'b0;
		else if (read)
			OVF <= 1'b0;
		else if (RXRDY&DONE)
			OVF <= 1'b1;
		else
			OVF <= OVF;
		
	// determine RXRDY active low
	always@(posedge clk, posedge rst)
		if (rst)
			RXRDY <= 1'b0;
		else if (read)
			RXRDY <= 1'b0;
		else if (DONE)
			RXRDY <= 1'b1;
		else
			RXRDY <= RXRDY;
	
	// if rst is high reset START & DOIT
	// to 2'b00 (initial state) else
	// load START & DOIT with n_START &
	// n_DOIT
	always@(posedge clk, posedge rst)
		if (rst)
			{START,DOIT} <= 2'b0;
		else
			{START,DOIT} <= {n_START,n_DOIT};
			
	// if rst is high reset p_state
	// to 2'b00 (initial state) else
	// load p_state with n_state
	always@(posedge clk, posedge rst)
	   if(rst)
		   p_state = 2'b00;
		else
		   p_state = n_state;
	
   // determines next states based on inputs
	always@(*)
		casez({p_state, RX, BTU, DONE})
		   5'b00_0?? : {n_START,n_DOIT,n_state} = 4'b11_01;
		   5'b01_010 : {n_START,n_DOIT,n_state} = 4'b01_10;
			5'b01_000 : {n_START,n_DOIT,n_state} = 4'b11_01;
			5'b01_1?0 : {n_START,n_DOIT,n_state} = 4'b00_00;
		   5'b10_??1 : {n_START,n_DOIT,n_state} = 4'b00_00;
			5'b10_??0 : {n_START,n_DOIT,n_state} = 4'b01_10;
			default   : {n_START,n_DOIT,n_state} = 4'b00_00;
		endcase
	
endmodule
