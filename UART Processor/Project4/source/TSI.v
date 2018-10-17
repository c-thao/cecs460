`timescale 1ns / 1ps
//****************************************************************//
//  This document contains information proprietary to the         //
//  CSULB student that created the file - any reuse without       //
//  adequate approval and documentation is prohibited             //
//                                                                //
//  Class: <CECS 460>                                             //
//  Project name: <Project 3>                                     //
//  File name: <TSI.v>                                            //
//                                                                //
//  Created by <Chou Thao> on <5/4/17>.                           //
//  Copyright © 2016 <Chou Thao>. All rights reserved.            //
//                                                                //
//  Abstract: <This module instantiates buffers between input     //
//             and output signals from a chip and its relative    //
//             core/fpga logic.>                                  //
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
module TSI(clk, rst, anode, sev, leds, EIGHT, PEN, OHEL, BAUD, TX, RX, clk_out,
			  rst_out, anode_out, sev_out, leds_out, EIGHT_out, PEN_out, OHEL_out,
			  BAUD_out, TX_out, RX_out);
	input       clk, rst;
	input       RX;
	input       EIGHT, PEN, OHEL;
	input [3:0] BAUD;
	input       TX;
	input [6:0] sev;
	input [3:0] anode;
	input [7:0] leds;
	
	output       clk_out, rst_out;
	output       RX_out;
	output       EIGHT_out, PEN_out, OHEL_out;
	output [3:0] BAUD_out;
	output       TX_out;
	output [6:0] sev_out;
	output [3:0] anode_out;
	output [7:0] leds_out;
	
	// IBUFG: Global Clock Input Buffer (source by an internal signal)
	// All FPGAs
	// Xilinx HDL Libraries Guide, version 11.2
	IBUFG BUFG_inst (
		.O(clk_out), // Clock buffer output
		.I(clk)      // Clock buffer input
	);
	
	/**************************************************************************/
	/************************IBUF DECLARATIONS*********************************/
	/**************************************************************************/
	// IBUF: Single-ended Input Buffer
	// All devices
	// Xilinx HDL Libraries Guide, version 11.2
	IBUF #(
	.IBUF_DELAY_VALUE("0"),   // Specify the amount of added input delay for
									  // the buffer: "0"-"12" (Spartan-3E)
									  // "0"-"16" (Spartan-3A)
	.IFD_DELAY_VALUE("AUTO"), // Specify the amount of added delay for input
									  // register: "AUTO", "0"-"6" (Spartan-3E)
									  // "AUTO", "0"-"8" (Spartan-3A)
	.IOSTANDARD("DEFAULT")    // Specify the input I/O standard
	)IBUF_inst1 (
		.O(rst_out), // Buffer output
		.I(rst)      // Buffer input (connect directly to top-level port)
	);
	
	// IBUF: Single-ended Input Buffer
	// All devices
	// Xilinx HDL Libraries Guide, version 11.2
	IBUF #(
	.IBUF_DELAY_VALUE("0"),   // Specify the amount of added input delay for
									  // the buffer: "0"-"12" (Spartan-3E)
									  // "0"-"16" (Spartan-3A)
	.IFD_DELAY_VALUE("AUTO"), // Specify the amount of added delay for input
									  // register: "AUTO", "0"-"6" (Spartan-3E)
									  // "AUTO", "0"-"8" (Spartan-3A)
	.IOSTANDARD("DEFAULT")    // Specify the input I/O standard
	)IBUF_inst2 (
		.O(EIGHT_out), // Buffer output
		.I(EIGHT)      // Buffer input (connect directly to top-level port)
	);
	
	// IBUF: Single-ended Input Buffer
	// All devices
	// Xilinx HDL Libraries Guide, version 11.2
	IBUF #(
	.IBUF_DELAY_VALUE("0"),   // Specify the amount of added input delay for
									  // the buffer: "0"-"12" (Spartan-3E)
									  // "0"-"16" (Spartan-3A)
	.IFD_DELAY_VALUE("AUTO"), // Specify the amount of added delay for input
									  // register: "AUTO", "0"-"6" (Spartan-3E)
									  // "AUTO", "0"-"8" (Spartan-3A)
	.IOSTANDARD("DEFAULT")    // Specify the input I/O standard
	)IBUF_inst3 (
		.O(PEN_out), // Buffer output
		.I(PEN)      // Buffer input (connect directly to top-level port)
	);
	
	// IBUF: Single-ended Input Buffer
	// All devices
	// Xilinx HDL Libraries Guide, version 11.2
	IBUF #(
	.IBUF_DELAY_VALUE("0"),   // Specify the amount of added input delay for
									  // the buffer: "0"-"12" (Spartan-3E)
									  // "0"-"16" (Spartan-3A)
	.IFD_DELAY_VALUE("AUTO"), // Specify the amount of added delay for input
									  // register: "AUTO", "0"-"6" (Spartan-3E)
									  // "AUTO", "0"-"8" (Spartan-3A)
	.IOSTANDARD("DEFAULT")    // Specify the input I/O standard
	)IBUF_inst4 (
		.O(OHEL_out), // Buffer output
		.I(OHEL)      // Buffer input (connect directly to top-level port)
	);
	
	// IBUF: Single-ended Input Buffer
	// All devices
	// Xilinx HDL Libraries Guide, version 11.2
	IBUF #(
	.IBUF_DELAY_VALUE("0"),   // Specify the amount of added input delay for
									  // the buffer: "0"-"12" (Spartan-3E)
									  // "0"-"16" (Spartan-3A)
	.IFD_DELAY_VALUE("AUTO"), // Specify the amount of added delay for input
									  // register: "AUTO", "0"-"6" (Spartan-3E)
									  // "AUTO", "0"-"8" (Spartan-3A)
	.IOSTANDARD("DEFAULT")    // Specify the input I/O standard
	)IBUF_inst5 (
		.O(BAUD_out[3]), // Buffer output
		.I(BAUD[3])      // Buffer input (connect directly to top-level port)
	);
	
	// IBUF: Single-ended Input Buffer
	// All devices
	// Xilinx HDL Libraries Guide, version 11.2
	IBUF #(
	.IBUF_DELAY_VALUE("0"),   // Specify the amount of added input delay for
									  // the buffer: "0"-"12" (Spartan-3E)
									  // "0"-"16" (Spartan-3A)
	.IFD_DELAY_VALUE("AUTO"), // Specify the amount of added delay for input
									  // register: "AUTO", "0"-"6" (Spartan-3E)
									  // "AUTO", "0"-"8" (Spartan-3A)
	.IOSTANDARD("DEFAULT")    // Specify the input I/O standard
	)IBUF_inst6 (
		.O(BAUD_out[2]), // Buffer output
		.I(BAUD[2])      // Buffer input (connect directly to top-level port)
	);
	
	// IBUF: Single-ended Input Buffer
	// All devices
	// Xilinx HDL Libraries Guide, version 11.2
	IBUF #(
	.IBUF_DELAY_VALUE("0"),   // Specify the amount of added input delay for
									  // the buffer: "0"-"12" (Spartan-3E)
									  // "0"-"16" (Spartan-3A)
	.IFD_DELAY_VALUE("AUTO"), // Specify the amount of added delay for input
									  // register: "AUTO", "0"-"6" (Spartan-3E)
									  // "AUTO", "0"-"8" (Spartan-3A)
	.IOSTANDARD("DEFAULT")    // Specify the input I/O standard
	)IBUF_inst7 (
		.O(BAUD_out[1]), // Buffer output
		.I(BAUD[1])      // Buffer input (connect directly to top-level port)
	);
	
	// IBUF: Single-ended Input Buffer
	// All devices
	// Xilinx HDL Libraries Guide, version 11.2
	IBUF #(
	.IBUF_DELAY_VALUE("0"),   // Specify the amount of added input delay for
									  // the buffer: "0"-"12" (Spartan-3E)
									  // "0"-"16" (Spartan-3A)
	.IFD_DELAY_VALUE("AUTO"), // Specify the amount of added delay for input
									  // register: "AUTO", "0"-"6" (Spartan-3E)
									  // "AUTO", "0"-"8" (Spartan-3A)
	.IOSTANDARD("DEFAULT")    // Specify the input I/O standard
	)IBUF_inst8 (
		.O(BAUD_out[0]), // Buffer output
		.I(BAUD[0])      // Buffer input (connect directly to top-level port)
	);
	
	// IBUF: Single-ended Input Buffer
	// All devices
	// Xilinx HDL Libraries Guide, version 11.2
	IBUF #(
	.IBUF_DELAY_VALUE("0"),   // Specify the amount of added input delay for
									  // the buffer: "0"-"12" (Spartan-3E)
									  // "0"-"16" (Spartan-3A)
	.IFD_DELAY_VALUE("AUTO"), // Specify the amount of added delay for input
									  // register: "AUTO", "0"-"6" (Spartan-3E)
									  // "AUTO", "0"-"8" (Spartan-3A)
	.IOSTANDARD("DEFAULT")    // Specify the input I/O standard
	)IBUF_inst9 (
		.O(RX_out), // Buffer output
		.I(RX)      // Buffer input (connect directly to top-level port)
	);
	
	/**************************************************************************/
	/************************OBUF DECLARATIONS*********************************/
	/**************************************************************************/
	
	// OBUF: Single-ended Output Buffer
	// All devices
	// Xilinx HDL Libraries Guide, version 11.2
	OBUF #(
		.DRIVE(12), 				// Specify the output drive strength
		.IOSTANDARD("DEFAULT"), // Specify the output I/O standard
		.SLEW("SLOW") 				// Specify the output slew rate
	) OBUF_inst1 (
		.O(sev_out[6]), // Buffer output (connect directly to top-level port)
		.I(sev[6])      // Buffer input
	);
	
	// OBUF: Single-ended Output Buffer
	// All devices
	// Xilinx HDL Libraries Guide, version 11.2
	OBUF #(
		.DRIVE(12), 				// Specify the output drive strength
		.IOSTANDARD("DEFAULT"), // Specify the output I/O standard
		.SLEW("SLOW") 				// Specify the output slew rate
	) OBUF_inst2 (
		.O(sev_out[5]), // Buffer output (connect directly to top-level port)
		.I(sev[5])      // Buffer input
	);
	
	// OBUF: Single-ended Output Buffer
	// All devices
	// Xilinx HDL Libraries Guide, version 11.2
	OBUF #(
		.DRIVE(12), 				// Specify the output drive strength
		.IOSTANDARD("DEFAULT"), // Specify the output I/O standard
		.SLEW("SLOW") 				// Specify the output slew rate
	) OBUF_inst3 (
		.O(sev_out[4]), // Buffer output (connect directly to top-level port)
		.I(sev[4])      // Buffer input
	);
	
	// OBUF: Single-ended Output Buffer
	// All devices
	// Xilinx HDL Libraries Guide, version 11.2
	OBUF #(
		.DRIVE(12), 				// Specify the output drive strength
		.IOSTANDARD("DEFAULT"), // Specify the output I/O standard
		.SLEW("SLOW") 				// Specify the output slew rate
	) OBUF_inst4 (
		.O(sev_out[3]), // Buffer output (connect directly to top-level port)
		.I(sev[3])      // Buffer input
	);
	
	// OBUF: Single-ended Output Buffer
	// All devices
	// Xilinx HDL Libraries Guide, version 11.2
	OBUF #(
		.DRIVE(12), 				// Specify the output drive strength
		.IOSTANDARD("DEFAULT"), // Specify the output I/O standard
		.SLEW("SLOW") 				// Specify the output slew rate
	) OBUF_inst5 (
		.O(sev_out[2]), // Buffer output (connect directly to top-level port)
		.I(sev[2])      // Buffer input
	);
	
	// OBUF: Single-ended Output Buffer
	// All devices
	// Xilinx HDL Libraries Guide, version 11.2
	OBUF #(
		.DRIVE(12), 				// Specify the output drive strength
		.IOSTANDARD("DEFAULT"), // Specify the output I/O standard
		.SLEW("SLOW") 				// Specify the output slew rate
	) OBUF_inst6 (
		.O(sev_out[1]), // Buffer output (connect directly to top-level port)
		.I(sev[1])      // Buffer input
	);
	
	// OBUF: Single-ended Output Buffer
	// All devices
	// Xilinx HDL Libraries Guide, version 11.2
	OBUF #(
		.DRIVE(12), 				// Specify the output drive strength
		.IOSTANDARD("DEFAULT"), // Specify the output I/O standard
		.SLEW("SLOW") 				// Specify the output slew rate
	) OBUF_inst7 (
		.O(sev_out[0]), // Buffer output (connect directly to top-level port)
		.I(sev[0])      // Buffer input
	);
	
	// OBUF: Single-ended Output Buffer
	// All devices
	// Xilinx HDL Libraries Guide, version 11.2
	OBUF #(
		.DRIVE(12), 				// Specify the output drive strength
		.IOSTANDARD("DEFAULT"), // Specify the output I/O standard
		.SLEW("SLOW") 				// Specify the output slew rate
	) OBUF_inst8 (
		.O(anode_out[3]), // Buffer output (connect directly to top-level port)
		.I(anode[3])      // Buffer input
	);
	
	// OBUF: Single-ended Output Buffer
	// All devices
	// Xilinx HDL Libraries Guide, version 11.2
	OBUF #(
		.DRIVE(12), 				// Specify the output drive strength
		.IOSTANDARD("DEFAULT"), // Specify the output I/O standard
		.SLEW("SLOW") 				// Specify the output slew rate
	) OBUF_inst9 (
		.O(anode_out[2]), // Buffer output (connect directly to top-level port)
		.I(anode[2])      // Buffer input
	);
	
	// OBUF: Single-ended Output Buffer
	// All devices
	// Xilinx HDL Libraries Guide, version 11.2
	OBUF #(
		.DRIVE(12), 				// Specify the output drive strength
		.IOSTANDARD("DEFAULT"), // Specify the output I/O standard
		.SLEW("SLOW") 				// Specify the output slew rate
	) OBUF_inst10 (
		.O(anode_out[1]), // Buffer output (connect directly to top-level port)
		.I(anode[1])      // Buffer input
	);
	
	// OBUF: Single-ended Output Buffer
	// All devices
	// Xilinx HDL Libraries Guide, version 11.2
	OBUF #(
		.DRIVE(12), 				// Specify the output drive strength
		.IOSTANDARD("DEFAULT"), // Specify the output I/O standard
		.SLEW("SLOW") 				// Specify the output slew rate
	) OBUF_inst11 (
		.O(anode_out[0]), // Buffer output (connect directly to top-level port)
		.I(anode[0])      // Buffer input
	);
	
	// OBUF: Single-ended Output Buffer
	// All devices
	// Xilinx HDL Libraries Guide, version 11.2
	OBUF #(
		.DRIVE(12), 				// Specify the output drive strength
		.IOSTANDARD("DEFAULT"), // Specify the output I/O standard
		.SLEW("SLOW") 				// Specify the output slew rate
	) OBUF_inst12 (
		.O(leds_out[7]), // Buffer output (connect directly to top-level port)
		.I(leds[7])      // Buffer input
	);
	
	// OBUF: Single-ended Output Buffer
	// All devices
	// Xilinx HDL Libraries Guide, version 11.2
	OBUF #(
		.DRIVE(12), 				// Specify the output drive strength
		.IOSTANDARD("DEFAULT"), // Specify the output I/O standard
		.SLEW("SLOW") 				// Specify the output slew rate
	) OBUF_inst13 (
		.O(leds_out[6]), // Buffer output (connect directly to top-level port)
		.I(leds[6])      // Buffer input
	);
	
	// OBUF: Single-ended Output Buffer
	// All devices
	// Xilinx HDL Libraries Guide, version 11.2
	OBUF #(
		.DRIVE(12), 				// Specify the output drive strength
		.IOSTANDARD("DEFAULT"), // Specify the output I/O standard
		.SLEW("SLOW") 				// Specify the output slew rate
	) OBUF_inst14 (
		.O(leds_out[5]), // Buffer output (connect directly to top-level port)
		.I(leds[5])      // Buffer input
	);
	
	// OBUF: Single-ended Output Buffer
	// All devices
	// Xilinx HDL Libraries Guide, version 11.2
	OBUF #(
		.DRIVE(12), 				// Specify the output drive strength
		.IOSTANDARD("DEFAULT"), // Specify the output I/O standard
		.SLEW("SLOW") 				// Specify the output slew rate
	) OBUF_inst15 (
		.O(leds_out[4]), // Buffer output (connect directly to top-level port)
		.I(leds[4])      // Buffer input
	);
	
	// OBUF: Single-ended Output Buffer
	// All devices
	// Xilinx HDL Libraries Guide, version 11.2
	OBUF #(
		.DRIVE(12), 				// Specify the output drive strength
		.IOSTANDARD("DEFAULT"), // Specify the output I/O standard
		.SLEW("SLOW") 				// Specify the output slew rate
	) OBUF_inst16 (
		.O(leds_out[3]), // Buffer output (connect directly to top-level port)
		.I(leds[3])      // Buffer input
	);
	
	// OBUF: Single-ended Output Buffer
	// All devices
	// Xilinx HDL Libraries Guide, version 11.2
	OBUF #(
		.DRIVE(12), 				// Specify the output drive strength
		.IOSTANDARD("DEFAULT"), // Specify the output I/O standard
		.SLEW("SLOW") 				// Specify the output slew rate
	) OBUF_inst17 (
		.O(leds_out[2]), // Buffer output (connect directly to top-level port)
		.I(leds[2])      // Buffer input
	);
	
	// OBUF: Single-ended Output Buffer
	// All devices
	// Xilinx HDL Libraries Guide, version 11.2
	OBUF #(
		.DRIVE(12), 				// Specify the output drive strength
		.IOSTANDARD("DEFAULT"), // Specify the output I/O standard
		.SLEW("SLOW") 				// Specify the output slew rate
	) OBUF_inst18 (
		.O(leds_out[1]), // Buffer output (connect directly to top-level port)
		.I(leds[1])      // Buffer input
	);
	
	// OBUF: Single-ended Output Buffer
	// All devices
	// Xilinx HDL Libraries Guide, version 11.2
	OBUF #(
		.DRIVE(12), 				// Specify the output drive strength
		.IOSTANDARD("DEFAULT"), // Specify the output I/O standard
		.SLEW("SLOW") 				// Specify the output slew rate
	) OBUF_inst19 (
		.O(leds_out[0]), // Buffer output (connect directly to top-level port)
		.I(leds[0])      // Buffer input
	);
	
	// OBUF: Single-ended Output Buffer
	// All devices
	// Xilinx HDL Libraries Guide, version 11.2
	OBUF #(
		.DRIVE(12), 				// Specify the output drive strength
		.IOSTANDARD("DEFAULT"), // Specify the output I/O standard
		.SLEW("SLOW") 				// Specify the output slew rate
	) OBUF_inst20 (
		.O(TX_out), // Buffer output (connect directly to top-level port)
		.I(TX)      // Buffer input
	);
	
endmodule
