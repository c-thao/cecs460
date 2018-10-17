`timescale 1ns / 1ps
//****************************************************************//
//  This document contains information proprietary to the         //
//  CSULB student that created the file - any reuse without       //
//  adequate approval and documentation is prohibited             //
//                                                                //
//  Class: <CECS 460>                                             //
//  Project name: <Project 3>                                     //
//  File name: <UART_TB.v>                                        //
//                                                                //
//  Created by <Chou Thao> on <4/27/17>.                          //
//  Copyright © 2016 <Chou Thao>. All rights reserved.            //
//                                                                //
//  Abstract: <This test bench verifies the behaviour of the UART //
//             system with integration of the receive engine, RX. //
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

module UART_TB;

	// Inputs
	reg clk;
	reg rst;
	reg load;
	reg [1:0] read;
	reg RX;
	reg EIGHT;
	reg PEN;
	reg OHEL;
	reg [3:0] BAUD;
	reg [7:0] OUT_PORT;

	// Outputs
	wire UART_INTR;
	wire TX;
	wire [7:0] IN_PORT;
	
	// integers
	integer i, j, k;
	
	// buffer input register
	reg [11:0] buff;
	reg  [7:0] data; 

	// Instantiate the Unit Under Test (UUT)
	UART uut (
		.clk(clk), 
		.rst(rst), 
		.load(load), 
		.read(read), 
		.RX(RX), 
		.EIGHT(EIGHT), 
		.PEN(PEN), 
		.OHEL(OHEL), 
		.BAUD(BAUD), 
		.OUT_PORT(OUT_PORT), 
		.UART_INTR(UART_INTR), 
		.TX(TX), 
		.IN_PORT(IN_PORT)
	);
	
	// set up clock
	always #5 clk=~clk;
	
	// check data received
	always @(posedge uut.RXRDY) begin
		case({EIGHT,PEN})
			2'b00 : $display("DATA RECEIVED=%b",buff[9:0]);
			2'b01 : $display("DATA RECEIVED=%b",buff[10:0]);
			2'b10 : $display("DATA RECEIVED=%b",buff[10:0]);
			2'b11 : $display("DATA RECEIVED=%b",buff[11:0]);
		endcase
	end
	
	// update buffer register for RX
	always @(posedge clk, posedge rst) begin
		buff[8:0] = {data[6:0],1'b0,1'b1}; // initial data bits always
		// generate upper bits of buffer
		if (i < 8)
			// correct upper bits
			case({EIGHT,PEN,OHEL})
				3'b000 : buff[11:9] <= 3'b111;
				3'b001 : buff[11:9] <= 3'b111;
				3'b010 : buff[11:9] <= {2'b11, ^data[6:0]};
				3'b011 : buff[11:9] <= {2'b11, ~(^data[6:0])};
				3'b100 : buff[11:9] <= {2'b11, data[7]};
				3'b101 : buff[11:9] <= {2'b11, data[7]};
				3'b110 : buff[11:9] <= {1'b1, ^data[7:0], data[7]};
				3'b111 : buff[11:9] <= {1'b1, ~(^data[7:0]), data[7]};
			endcase
		else
			// mixed upper bits
			case({EIGHT,PEN,OHEL})
				3'b000 : buff[11:9] <= {3'b110}; // incorrect stop bit
				3'b001 : buff[11:9] <= {3'b111};
				3'b010 : buff[11:9] <= {2'b11, ~(^data[6:0])}; // wrong parity bit
				3'b011 : buff[11:9] <= {2'b11, ^data[6:0]};    // wrong parity bit
				3'b100 : buff[11:9] <= {2'b11, data[7]};
				3'b101 : buff[11:9] <= {2'b10, data[7]};       // incorrect stop bit
				3'b110 : buff[11:9] <= {1'b1, ~(^data[7:0]), data[7]}; // wrong parity bit
				3'b111 : buff[11:9] <= {1'b1, ^data[7:0], data[7]};    // wrong parity bit
			endcase
	end
	

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		load = 0;
		read = 0;
		RX = 1'b1;
		EIGHT = 0;
		PEN = 0;
		OHEL = 0;
		BAUD = 0;
		OUT_PORT = 0;
		data = 0;

		// Wait 100 ns for global reset to finish
		#10;
		rst = 1'b1;
		#100;
      rst = 1'b0; 
		
		@(posedge clk)
		BAUD = 4'b1011;
		RX = 1'b1;
		
		// regular data
		for(i=0;i<16;i=i+1) begin
			@(posedge clk)
			$display("\nNew Data Byte Incoming");
			data = i;
			// determine EIGHT,PEN,OHEL
			if(i < 8)
				{EIGHT,PEN,OHEL} = i;
			else
				{EIGHT,PEN,OHEL} = i-8;
			$display("{EIGHT,PEN,OHEL}=%b",{EIGHT,PEN,OHEL});
			
			// recieve data
			for(k=0;k<14;k=k+1) begin
				// clk delay
				for(j=0;j<109;j=j+1) begin
					@(posedge clk);
				end
				if (k<12) begin
					RX = buff[k]; // recieve next bit
					$display("Incoming bit=%b",buff[k]);
				end
				else begin
					RX=1'b1;
					$display("Incoming bit=%b",RX);
				end
			end
			$stop;
			
			
			// update OUT_PORT with errors
			@(posedge clk)
			read = 2'b10;
			@(posedge clk)
			OUT_PORT <= uut.reciever.RM;
			read = 2'b00;
			
			// transmit error status
			@(posedge clk)
			load = 1'b1;
			// disable load
			@(posedge clk)
			load = 1'b0;
			$display("\nNew Transmission of Error LSB->MSB");
			$display("{EIGHT,PEN,OHEL}=%b  {OVF,FERR,PERR}=%b ", {EIGHT,PEN,OHEL}, OUT_PORT[2:0]);
			// check each transmission of data
			for(k=0;k<11;k=k+1) begin
				@(posedge uut.transmit.BTU)
				#11;
				$display("TX=%b", TX);
			end
			// check for parity on transmission
			if(PEN) begin
				if(EIGHT) begin
					if(OHEL)
						// display parity odd
						$display("odd parity bit=%b",(~^OUT_PORT));
					else
						// display parity even
						$display("even parity bit=%b",(^OUT_PORT));
				end
				else begin
					if(OHEL)
						// display parity odd
						$display("odd parity bit=%b",(~^OUT_PORT[6:0]));
					else
						// display parity even
						$display("even parity bit=%b",(^OUT_PORT[6:0]));
				end
			end
			$stop;
			
			// read data receive to turn off RXRDY flag
			if (i < 14) begin
				@(posedge clk)
				read = 2'b01;
				@(posedge clk)
				read = 2'b00;
				$display("VALUE OF DATA RECEIVED=%b",IN_PORT[7:0]);
			end
			$stop;
		end
	end
      
endmodule

