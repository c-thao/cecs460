`timescale 1ns / 1ps
//****************************************************************//
//  This document contains information proprietary to the         //
//  CSULB student that created the file - any reuse without       //
//  adequate approval and documentation is prohibited             //
//                                                                //
//  Class: <CECS 460>                                             //
//  Project name: <Project 3>                                     //
//  File name: <RX_TB.v>                                          //
//                                                                //
//  Created by <Chou Thao> on <4/27/17>.                          //
//  Copyright © 2016 <Chou Thao>. All rights reserved.            //
//                                                                //
//  Abstract: <This test bench testes the receive engine RX to    //
//             verify the functionality when receiving data and   //
//             errors.>                                           //
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

module RX_TB;

	// Inputs
	reg clk;
	reg rst;
	reg read;
	reg [18:0] max;
	reg RX;
	reg EIGHT;
	reg PEN;
	reg OHEL;

	// Outputs
	wire [2:0] RX_STATUS;
	wire RXRDY;
	wire [7:0] UART_RDATA;
	
	// integers
	integer i, j, k;
	
	// buffer input register
	reg [11:0] buff;
	reg  [7:0] data; 

	// Instantiate the Unit Under Test (UUT)
	RX uut (
		.clk(clk), 
		.rst(rst), 
		.read(read), 
		.max(max), 
		.RX(RX), 
		.EIGHT(EIGHT), 
		.PEN(PEN), 
		.OHEL(OHEL), 
		.RX_STATUS(RX_STATUS), 
		.RXRDY(RXRDY), 
		.UART_RDATA(UART_RDATA)
	);
	
	// set up clock
	always #5 clk=~clk;
	
	// update output
	always @(posedge RXRDY) begin
		case({EIGHT,PEN})
			2'b00 : $display("DATA RECEIVED=%b",buff[9:0]);
			2'b01 : $display("DATA RECEIVED=%b",buff[10:0]);
			2'b10 : $display("DATA RECEIVED=%b",buff[10:0]);
			2'b11 : $display("DATA RECEIVED=%b",buff[11:0]);
		endcase
	end
	
	// parity error
	always@(posedge RX_STATUS[0]) begin
		$display("Parity error encountered");
	end
	
	// framing error
	always@(posedge RX_STATUS[1]) begin
		$display("Framing error encountered");
	end
	
	// overflow error
	always@(posedge RX_STATUS[2]) begin
		$display("Overflow has occured");
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
		read = 0;
		max = 109;
		RX = 1'b1;
		EIGHT = 0;
		PEN = 0;
		OHEL = 0;
		buff = 11'b0;
		data = 8'b0;

		// Wait 100 ns for global reset to finish
		#10;
		rst = 1'b1;
		#100;
      rst = 1'b0; 
		
		@(posedge clk)
		max = 109;
		RX = 1'b1;
		
		// regular data
		for(i=10;i<16;i=i+1) begin
			@(posedge clk)
			$display("\nNew Data Byte Incoming");
			data = i;
			// determine EIGHT,PEN,OHEL
			if(i < 8)
				{EIGHT,PEN,OHEL} = i;
			else
				{EIGHT,PEN,OHEL} = i-8;
			$display("{EIGHT,PEN,OHEL}=%b",{EIGHT,PEN,OHEL});
			// recieve data one at a time
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
			if (i < 13) begin
				@(posedge clk)
				read = 1'b1; // read data receive to turn off RXRDY flag
				@(posedge clk)
				read = 1'b0;
			end
			$display("VALUE OF DATA=%b",UART_RDATA);
			$stop;
			//$finish;
		end
	end
      
endmodule

