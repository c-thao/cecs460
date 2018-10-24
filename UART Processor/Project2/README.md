# Transmit Engine
## Description
The second project focuses on the design and implementation of the transmit engine.

## Task
For the task of the second project the Nexys 3 will interact with a UART-compliant terminal. The Nexys 3 will transmit to the terminal CSULB CECS 460 - (Counter value)`<CR`>`<LF`> continously. Meanwhile, in the program's main, a one is periodically walked through the onboard LEDs. For this task the message is initially stored into the scratch ram and the counter value is stored in a register. The counter value, however, is a binary value and is converted into a hexadecimal value to transmit to the terminal.
