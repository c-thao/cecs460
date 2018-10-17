`timescale 1ns / 1ps
//****************************************************************//
//  This document contains information proprietary to the         //
//  CSULB student that created the file - any reuse without       //
//  adequate approval and documentation is prohibited             //
//                                                                //
//  Class: <CECS 460>                                             //
//  Project name: <Project 1>                                     //
//  File name: <Adb_fsm.v>                                        //
//                                                                //
//  Created by <Pong Chu>                                         //
//  Modified by <Chou Thao> on <9/14/16>.                         //
//  Copyright © 2016 <Chou Thao>. All rights reserved.            //
//                                                                //
//  Abstract: <This is a debounce finite state machine which sees //
//             if an input sw is stablize. The following is       //
//             achieved through a series of states indicative of  //
//             the assertion and deassertion of an input sw. The  //
//             initial state is zero and moves on if sw is assert-//
//             ed. Then the three following states hold their     //
//             states until a tick(m_tick) is generated when a re-//
//             gister q_reg reaches a desired value. After the    //
//             above states go into state one, it will assert out-//
//             put db and it waits until the deassertion of sw.   //
//             The following three states after one are to hold   //
//             their states until a tick(m_tick) is generated once//
//             q_reg reaches a desired value. Then it will restart//
//             from state zero.>                                  //
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
module db_fsm(clk, rst, sw, db);
   input  clk, rst, sw;
	output db;
	reg    db;
	
	// symbolic state
	localparam [2:0]
	           zero    = 3'b000,
				  wait1_1 = 3'b001,
				  wait1_2 = 3'b010,
				  wait1_3 = 3'b011,
				  one     = 3'b100,
				  wait0_1 = 3'b101,
				  wait0_2 = 3'b110,
				  wait0_3 = 3'b111;
	
	// number of counter bits (2^N * 20ns = 10ms tick)
	localparam N=20;
	
	// signal declaration
	reg  [N-1:0] q_reg;
	wire [N-1:0] q_next;
   wire          m_tick;
	reg  [2:0]   state_reg, state_next;
	
	// body
	
	//=================================================
	// counter to generate 10 ms tick
	//=================================================
	always@(posedge clk, posedge rst)
		if (rst)
		   q_reg <= 20'b0;
		else if (m_tick)
		   q_reg <= 20'b0;
		else
	      q_reg <= q_next;
			
	// next_state logic
	assign q_next = q_reg + 20'b1;
	// output tick
	assign m_tick = (q_reg==999999) ? 1'b1 : 1'b0;
	
	//=================================================
	// debouncing FSM
	//=================================================
	// state register
	always@(posedge clk, posedge rst)
	   if(rst)
		   state_reg <= zero;
		else
		   state_reg <= state_next;
			
	// next-state logic and output logic
	always@(*)
	begin
	   state_next = state_reg;
		db = 1'b0;
		case(state_reg)
		   zero:
			   if(sw)			
				   state_next = wait1_1;
			wait1_1:
			   if(~sw)
				   state_next = zero;
			   else
				   if(m_tick)
					   state_next = wait1_2;
			wait1_2:
			   if(~sw)
				   state_next = zero;
				else
				   if(m_tick)
					   state_next = wait1_3;
			wait1_3:
			   if(~sw)
				   state_next = zero;
			   else
				   if(m_tick)
					   state_next = one;
			one:
			   begin
				   db = 1'b1;
					if(~sw)
					   state_next = wait0_1;
               else
                  state_next = one;					
				end
			wait0_1:
			   begin
				   db = 1'b1;
					if(sw)
					   state_next = one;
					else
					   if(m_tick)
						   state_next = wait0_2;
			   end
			wait0_2:
			   begin
				   db = 1'b1;
					if(sw)
					   state_next = one;
					else
					   if(m_tick)
						   state_next = wait0_3;
				end
			wait0_3:
			   begin
				   db = 1'b1;
					if(sw)
					   state_next = one;
					else
					   if(m_tick)
						   state_next = zero;
				end
			default: state_next = zero;
		endcase
	end
	
endmodule
