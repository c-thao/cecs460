`timescale 1ns / 1ps
//****************************************************************//
//  This document contains information proprietary to the         //
//  CSULB student that created the file - any reuse without       //
//  adequate approval and documentation is prohibited             //
//                                                                //
//  Class: <CECS 460>                                             //
//  Project name: <Project 3>                                     //
//  File name: <top_level.v>                                      //
//                                                                //
//  Created by <Chou Thao> on <4/27/17>.                          //
//  Copyright © 2016 <Chou Thao>. All rights reserved.            //
//                                                                //
//  Abstract: <This module is a top level which instantiates      //
//             a 16 bit microprocessor with a UART system.>       //
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
module top_level(clk, rst, anode, sev, EIGHT, PEN, OHEL, BAUD, TX, RX, leds);
   input        clk, rst, RX;
	input        EIGHT, PEN, OHEL;
	input  [3:0] BAUD;
	output [3:0] anode;
	output [6:0] sev;
	output [7:0] leds;
	output       TX;
   
	reg   [7:0] leds;
	reg  [15:0] din;
	wire [15:0] out_port, port_id, IN_PORT;
	wire [15:0] read, write;
	wire        UART_INTR;
	wire        read_strobe, write_strobe;
	wire        rst_s, intr, ack;
	
	assign IN_PORT[15:8] = 8'b0;
	
	// asynchronous reset to sync all clock on flops
	// and avoid metastability
	AISO             a_rst(.clk(clk), .rst(rst), .rst_s(rst_s));
	
	// UART engine
	UART             uart_rxtx(.clk(clk), .rst(rst_s), .load(write[0]),
										.read(read[1:0]), .RX(RX), .EIGHT(EIGHT), .PEN(PEN),
										.OHEL(OHEL), .BAUD(BAUD), .OUT_PORT(out_port[7:0]),
										.UART_INTR(UART_INTR), .TX(TX), .IN_PORT(IN_PORT[7:0]));
	
	// rs flop to generate an interrupt when a switch pulse is generated
	RS_flop          rs_intr(.clk(clk), .rst(rst_s), .set(UART_INTR), .ack(ack),
	                         .intr(intr));
	
	// 16 bit picoblaze
	tramelblaze_top  t_blaze(.CLK(clk), .RESET(rst_s), .IN_PORT(IN_PORT),
	                         .INTERRUPT(intr), .OUT_PORT(out_port), .PORT_ID(port_id),
									 .READ_STROBE(read_strobe), .WRITE_STROBE(write_strobe),
									 .INTERRUPT_ACK(ack));
	
	// decoder for read and write using a port_id to denote a port location
	dec              port_dec(.read_strobe(read_strobe), .write_strobe(write_strobe),
	                          .port_id(port_id[3:0]), .read(read), .write(write));
	
	// 8 bit register for leds
	always@(posedge clk)
		if (rst_s)
			leds <= 8'b0;
		else if(write[1])
			leds <= out_port[7:0];
		else
			leds <= leds;
			
	// 16 bit register for leds
	always@(posedge clk)
		if (rst_s)
			din <= 16'b0;
		else if(write[2])
			din <= out_port;
		else
			din <= din;
			
	// controller to transform a 16 bit value into hex onto an seven segment display
	sev_seg_fsm    sev_seg(.clk(clk), .rst(rst_s), .d_in(din), .d_out(sev),
	                       .anode(anode));

endmodule
