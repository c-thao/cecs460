`timescale 1ns / 1ps
//****************************************************************//
//  This document contains information proprietary to the         //
//  CSULB student that created the file - any reuse without       //
//  adequate approval and documentation is prohibited             //
//                                                                //
//  Class: <CECS 460>                                             //
//  Project name: <Project 3>                                     //
//  File name: <top_level_TB.v>                                   //
//                                                                //
//  Created by <Chou Thao> on <4/27/17>.                          //
//  Copyright © 2016 <Chou Thao>. All rights reserved.            //
//                                                                //
//  Abstract: <This test bench testes the funcitonality of the    //
//             the system's UART, verifying the behaviour of both //
//             the UART's receive and transmit engine.>           //
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

module top_level_TB;

	// Inputs
	reg clk;
	reg rst;
	reg EIGHT;
	reg PEN;
	reg OHEL;
	reg [3:0] BAUD;
	reg RX;

	// Outputs
	wire [3:0] anode;
	wire [6:0] sev;
	wire TX;
	wire [7:0] leds;
	
	// integers
	integer i, j, k, c;
	
	// buffer input register
	reg [11:0] buff, buffer;
	reg  [7:0] data;
	
	
	// Instantiate the Unit Under Test (UUT)
	top_level uut (
		.clk(clk), 
		.rst(rst), 
		.anode(anode), 
		.sev(sev), 
		.EIGHT(EIGHT), 
		.PEN(PEN), 
		.OHEL(OHEL), 
		.BAUD(BAUD), 
		.TX(TX), 
		.RX(RX), 
		.leds(leds)
	);

	// initialize clock
	always #5 clk=~clk;
	
	// each transmission add TX output to buff
	always@(posedge uut.uart_rxtx.transmit.BTU)begin
		#11;
		//$display("TX=%b ",TX);
		buffer[c] = TX;
		if (c == 10)
			c = 0;
		else
			c = c + 1;
	end
	
	// for each led update check output
	always@(posedge uut.write[1]) begin
		#11;
		$display("leds=%b",leds);
	end
	
	// for each ptr per output
	always@(posedge uut.write[0]) begin
		#11;
		$display("PTR is %h",uut.t_blaze.tramelblaze.regfile[1]);
	end	
	
	always@(posedge uut.uart_rxtx.TXRDY) begin
		#1;
		$display("Serial data transmitted=%b", buffer); // display tranmission
		$display("data transmitted=%h  %c",buffer[7:1], buffer[7:1]); // display data transmitted
		//$stop;
	end
	
   // check data received
	always @(posedge uut.read[0]) begin
		case({EIGHT,PEN})
			2'b00 : $display("DATA RECEIVED=%b",buff[9:0]);
			2'b01 : $display("DATA RECEIVED=%b",buff[10:0]);
			2'b10 : $display("DATA RECEIVED=%b",buff[10:0]);
			2'b11 : $display("DATA RECEIVED=%b",buff[11:0]);
		endcase
	end
	
	// update buffer register for RX
	always @(posedge clk, posedge rst) begin
		// transmission setup
		if (uut.t_blaze.tramelblaze.regfile[5] == 40)
			buff[8:2] = 7'h40;
		else if (i == 21 || i == 51)
		   buff[8:2] = 7'hd;
		else if (i == 29 || i == 32)
			buff[8:2] = 7'h8;
		else if (i == 35)
			buff[8:2] = 7'h2A;			
		else
			buff[8:2] = i;

		buff[1:0] = {1'b0,1'b1}; 
		
		// correct upper 3 bits for transmission buff
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
	end
	
	initial begin
		// Initialize Inputs
		clk = 1'b0;
		rst = 1'b1;
		EIGHT = 1'b0;
		PEN = 1'b0;
		OHEL = 1'b0;
		BAUD = 4'b0;
		RX = 1'b1;
		c = 0;
		buff = 11'b0;
		buffer = 11'b0;

		// Wait 100 ns for global reset to finish
		#100;
		rst = 1'b0;
        
		// Add stimulus here
		@(posedge clk)
			BAUD = 4'b1011; // quickest baud rate
			$display("Initial");
		   $display("leds=%b",leds);
		
		// data receival
		for(i=0;i<150;i=i+1) begin
			@(posedge clk)
			$display("\nNew Data Byte Incoming for i=%d", i);
			data = i;
			// determine EIGHT,PEN,OHEL
			if(i < 8)
				{EIGHT,PEN,OHEL} = i;
			else
				{EIGHT,PEN,OHEL} = 0;
			$display("{EIGHT,PEN,OHEL}=%b",{EIGHT,PEN,OHEL});
			
			// recieve data
			for(k=0;k<24;k=k+1) begin
				// clk delay
				for(j=0;j<109;j=j+1) begin
					@(posedge clk);
				end
				if (k<12) begin
					RX = buff[k]; // recieve next bit
					//$display("Incoming bit=%b",buff[k]);
				end
				else begin
					RX=1'b1;
					//$display("Incoming bit=%b",RX);
				end
			end
			if (i > 115) begin
				$stop;
			end
		end
		$stop;
	end
      
endmodule

