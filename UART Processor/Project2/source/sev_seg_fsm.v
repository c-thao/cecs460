`timescale 1ns / 1ps
//****************************************************************//
//  This document contains information proprietary to the         //
//  CSULB student that created the file - any reuse without       //
//  adequate approval and documentation is prohibited             //
//                                                                //
//  Class: <CECS 460>                                             //
//  Project name: <Project 2>                                     //
//  File name: <sev_seg_fsm.v>                                    //
//                                                                //
//  Created by <Chou Thao> on <9/14/16>.                          //
//  Copyright © 2016 <Chou Thao>. All rights reserved.            //
//                                                                //
//  Abstract: <This is a finite state machine which separates a   //
//             16 bit input into four 4 bit registers. Each 4 bit //
//             register is converted to a 7 bit value correspond- //
//             ing to a hex representation on a seven segment dis-//
//             play.>                                             //
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
module sev_seg_fsm(clk, rst, d_in, d_out, anode);
   input             clk, rst;
	input      [15:0] d_in;
	output reg  [6:0] d_out;
	output reg  [3:0] anode;
   
	reg   [1:0] p_state, n_state;
	reg   [3:0] number;
	reg  [18:0] count;
	wire        led_clk;
	
	// generate a led_clk pulse when
	// count reaches desired value
	assign led_clk = (count==399999);
	
	// if rst or led_clk is high reset
   //	count register to 19'b0 else
	// keep incrementing the count
	// register by 19'b1
	always@(posedge clk, posedge rst)
	   if(rst)
		   count <= 19'b0;
		else if(led_clk)
		   count <= 19'b0;
		else
		   count <= count + 19'b1;
	
   // dependent on a 4 bit register
	// number generate a 7 bit co-
	// respondant to the 4 bit value
	// in hex on a seven segment dis-
	// play
	always@(number)
	   case(number)
		   4'h0: d_out = 7'b0000001;
		   4'h1: d_out = 7'b1001111;
		   4'h2: d_out = 7'b0010010;
		   4'h3: d_out = 7'b0000110;
		   4'h4: d_out = 7'b1001100;
		   4'h5: d_out = 7'b0100100;
		   4'h6: d_out = 7'b0100000;
		   4'h7: d_out = 7'b0001101;
		   4'h8: d_out = 7'b0000000;
		   4'h9: d_out = 7'b0001100;
		   4'hA: d_out = 7'b0001000;
		   4'hB: d_out = 7'b1100000;
		   4'hC: d_out = 7'b0110001;
		   4'hD: d_out = 7'b1000010;
		   4'hE: d_out = 7'b0110000;
		   4'hF: d_out = 7'b0111000;
		endcase
	
	// if rst is high reset p_state
	// to 2'b00 (initial state) else
	// load p_state with n_state
	always@(posedge clk, posedge rst)
	   if(rst)
		   p_state = 2'b00;
		else if (led_clk)
		   p_state = n_state;
	
   // dependent on a 2 bit register
   // p_state switch the values
   // associated with 4 bit register
   // anode, 2 bit register n_state
   //	and 4 bit register number to
	// one of 4 predetermined values
	always@(*)
		case(p_state)
		   2'b00: {anode, n_state, number} = {4'b1110, 2'b01, d_in[3:0]}; 
		   2'b01: {anode, n_state, number} = {4'b1101, 2'b10, d_in[7:4]}; 
		   2'b10: {anode, n_state, number} = {4'b1011, 2'b11, d_in[11:8]}; 
		   2'b11: {anode, n_state, number} = {4'b0111, 2'b00, d_in[15:12]}; 
		endcase
	
endmodule
