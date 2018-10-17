`timescale 1ns / 1ps
//****************************************************************//
//  This document contains information proprietary to the         //
//  CSULB student that created the file - any reuse without       //
//  adequate approval and documentation is prohibited             //
//                                                                //
//  Class: <CECS 460>                                             //
//  Project name: <Project 3>                                     //
//  File name: <dec_TB.v>                                         //
//                                                                //
//  Created by <Chou Thao> on <5/16/17>.                          //
//  Copyright © 2016 <Chou Thao>. All rights reserved.            //
//                                                                //
//  Abstract: <This test bench testes the funcitonality of the    //
//             the system's address decoder, dec, verifying the   //
//             behaviour works.>                                  //
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

module dec_TB;

	// Inputs
	reg read_strobe;
	reg write_strobe;
	reg [3:0] port_id;

	// Outputs
	wire [15:0] read;
	wire [15:0] write;
	
	// integers
	integer i;
	
	// Instantiate the Unit Under Test (UUT)
	dec uut (
		.read_strobe(read_strobe), 
		.write_strobe(write_strobe), 
		.port_id(port_id), 
		.read(read), 
		.write(write)
	);
	
	initial begin
		// Initialize Inputs
		read_strobe = 0;
		write_strobe = 0;
		port_id = 0;
        
		// Add stimulus here
		for(i=0;i<16;i=i+1) begin
			#10; // delay to show difference
			port_id = i;
			if ((i%2) == 0)
				{read_strobe, write_strobe} = 2'b10;
			else 
				{read_strobe, write_strobe} = 2'b01;
		end
		
	end
      
endmodule

