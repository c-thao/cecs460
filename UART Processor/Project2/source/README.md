# Transmit Engine
## Project contents
To deviate from the first project this will only cover new files introduced with designing the transmit engine.</br>
Project Contents:</br>
TX.v - The transmit engine implementation.</br>
UART.v - Top level UART processor with an instantiation of the newly created transmit engine.</br>
trans_test.v - A testbench to check the integrity of the transmit engine to ensure its behavior.</br>
transmit_test.v - A testbench to ensure the transmit engine functions correctly from enclosure of the UART processor.<br>
proj2.tba - An assembly file to configure the behavior of the TramelBlaze when interfacing with the transmit engine.</br>
proj2.coe - A coefficient file to load into the TramelBlaze's memory when programmed onto a Spartan 6 Nexys 3 FPGA.</br>
