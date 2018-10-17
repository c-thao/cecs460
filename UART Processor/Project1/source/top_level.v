`timescale 1ns / 1ps
//****************************************************************//
//  This document contains information proprietary to the         //
//  CSULB student that created the file - any reuse without       //
//  adequate approval and documentation is prohibited             //
//                                                                //
//  Class: <CECS 460>                                             //
//  Project name: <Project 1>                                     //
//  File name: <top_level.v>                                      //
//                                                                //
//  Created by <Chou Thao> on <2/16/17>.                          //
//  Copyright © 2016 <Chou Thao>. All rights reserved.            //
//                                                                //
//  Abstract: <This module is a top level 16 bit counter which    //
//             instantiates various modules. The 16 bit counter   //
//             is perodically driven by a seven segment display   //
//             controller and the counter is incremented/decre-   //
//             mented dependent on an input sw. The sw initiates  //
//             a interrupt and the tramelblaze goes into its ISR  //
//             which handles the incrementing/decrementing.>      //
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
module top_level(clk, rst, sw, uphdwl, anode, sev);
   input clk, rst, sw, uphdwl;
	output [3:0] anode;
	output [6:0] sev;
   
	reg  [15:0] din;
	wire [15:0] D_in;
	wire [15:0] out_port, port_id;
	wire [15:0] read, write;
	wire        read_strobe, write_strobe;
	wire        rst_s, db, pulse, intr, ack;
	
	
	// asynchronous reset to sync all clock on flops
	// and avoid metastability
	AISO             a_rst(.clk(clk), .rst(rst), .rst_s(rst_s));
	
	//debounce fsm to debounce a switch input
	db_fsm           debounce(.clk(clk), .rst(rst_s), .sw(sw), .db(db));
	
	// posedge detector which goes high on the edge
	// when a switch input is high
	pulse_maker      p_edge(.clk(clk), .rst(rst_s), .in(db), .pulse(pulse));
	
	// rs flop to generate an interrupt when a switch pulse is generated
	RS_flop          rs_intr(.clk(clk), .rst(rst_s), .set(pulse), .ack(ack),
	                         .intr(intr));
	
	// 16 bit picoblaze
	tramelblaze_top  t_blaze(.CLK(clk), .RESET(rst_s), .IN_PORT({15'b0, uphdwl}),
	                         .INTERRUPT(intr), .OUT_PORT(out_port), .PORT_ID(port_id),
									 .READ_STROBE(read_strobe), .WRITE_STROBE(write_strobe),
									 .INTERRUPT_ACK(ack));
	
	// decoder for read and write using a port_id to denote a port location
	dec              port_dec(.read_strobe(read_strobe), .write_strobe(write_strobe),
	                          .port_id(port_id[3:0]), .read(read), .write(write));
	
	// 16 bit register
	always@(posedge clk, posedge rst_s)
		if (rst_s == 1'b1)
			din = 16'b0;
		else if (write[4] == 1'b1)
			din = out_port;
		else
			din = din;
	
	// 7 sev value
	assign D_in = din;
	
	// controller to transform a 16 bit value into hex onto an seven segment display
	sev_seg_fsm    sev_seg(.clk(clk), .rst(rst_s), .d_in(D_in), .d_out(sev),
	                       .anode(anode));

endmodule
