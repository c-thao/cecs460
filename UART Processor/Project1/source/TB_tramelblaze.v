`timescale 1ns / 1ns
//****************************************************************//
//  This document contains information proprietary to the         //
//  CSULB student that created the file - any reuse without       //
//  adequate approval and documentation is prohibited             //
//                                                                //
//  Class: <CECS 460>                                             //
//  Project name: <Project 1>                                     //
//  File name: <TB_tramelblaze.v>                                 //
//                                                                //
//  Created by <Chou Thao> on <2/16/17>.                          //
//  Copyright © 2016 <Chou Thao>. All rights reserved.            //
//                                                                //
//  Abstract: <This is a testbench which testes the functionality //
//             of a 16 bit counter.>                              //
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

module TB_tramelblaze;

	// Inputs
	reg clk;
	reg rst;
	reg sw;
	reg uphdwl;

	// Outputs
	wire [3:0] anode;
	wire [6:0] sev;

	// Instantiate the Unit Under Test (UUT)
	top_level uut (
		.clk(clk), 
		.rst(rst), 
		.sw(sw), 
		.uphdwl(uphdwl), 
		.anode(anode), 
		.sev(sev)
	);
	
	// set clk
	always #5 clk = ~clk;

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		sw = 0;
		uphdwl = 0;

		// Wait 100 ns for global reset to finish
		rst = 1;
		#100;
		rst = 0;
      
		/************************************
		All code that are in comments are for
		debugging purposes only.
		*************************************/
		
		
		// increment
			begin
			$display("\nI N C R E M E N T I N G  T E S T\n");
			@(posedge clk)
				sw = 1'b1;
				uphdwl = 1'b1;
				$display("Initial value of D_in=%d", uut.D_in);
			// once db is high for 30ms kill switch
			#30000000; // allow for debounce to stay high
			@(posedge clk)
				sw = 1'b0;
			/***********************************************************
			// intr high
			@(posedge uut.intr)
				#10;
				$display("intr=%b", uut.intr);
			// check if int_proc is high
			@(posedge uut.t_blaze.tramelblaze.int_proc)
				#10;
				$display("int_proc=%b", uut.t_blaze.tramelblaze.int_proc);
			// ack high
			@(posedge uut.ack)
				#10;
				$display("ack=%b", uut.ack);
			************************************************************/
			// once write[4] is high check output
			@(posedge uut.write[4])
				#20;
				$display("D_in=%d", uut.D_in);
			$stop;
			#30000000; // allow debounce to go low
			// decrement
			$display("\nD E C R E M E N T I N G  T E S T\n");
			@(posedge clk)
				sw = 1'b1;
				uphdwl = 1'b0;
			#30000000; // allow for debounce
			@(posedge clk)
				sw = 1'b0;
			/***********************************************************
			// intr high
			@(posedge uut.intr)
				#10;
				$display("intr=%b", uut.intr);
			// check if int_proc is high
			@(posedge uut.t_blaze.tramelblaze.int_proc)
				#10;
				$display("int_proc=%b", uut.t_blaze.tramelblaze.int_proc);
			// ack high
			@(posedge uut.ack)
				#10;
				$display("ack=%b", uut.ack);
			************************************************************/
			// once write[4] is high check output
			@(posedge uut.write[4])
				#20;
				$display("D_in=%d", uut.D_in);
			$stop;
			end
		$finish;
	end
      
endmodule

