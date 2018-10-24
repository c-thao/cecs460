# Receive Engine/UART Processor
## Description
This third project focuses on the design and implementation of the receive engine. It also involves integrating the transmit and receive engine into the UART processor.

## Task
The task of the third project is to interact with a UART-compliant terminal using the UART processor. This task encompasses the full UART design incorporating into the interface the newly added receive engine. The program this time will transmit a banner and a prompt initialize in the scratch ram upon start-up/reset. It will then wait for a user's input/reponse from the terminal. If it detects an input/reponse, it will perform one of the following; print the hometown if it detects *; print line of characters stored from previous inputs/responses if it detects @; generate a on screen backspace if it detects BS; print a new prompt if it detects <CR>; otherwise it will echo back the input/response form the terminal up to the 40th character where it will await for one of the other four character inputs. The main program will continously walk a one through the onboard LEDs during this process.
