# TSI
# Description
This fourth project introduces the concept of a Technology Specific Instantiation (TSI). In this project instantiations of I/O buffers of the target technology, Spartan 6, were created in a separate TSI file removing the overhead introduced by allowing xilinx to compensate and create the I/O buffers itself.


## Task
The task of the fourth project is the same as the task of the third project. This time, however, the task requires ensuring that the previous project's task still perform correctly with the inclusion of a TSI file and no changes to the core assembly files created previously.<br><br>
For reference:<br>
The previous project task was to interact with a UART-compliant terminal using the UART processor. This task encompasses the full UART design incorporating into the interface the newly added receive engine. The program this time will transmit a banner and a prompt initialize in the scratch ram upon start-up/reset. It will then wait for a user's input/reponse from the terminal. If it detects an input/reponse, it will perform one of the following; print the hometown if it detects *; print line of characters stored from previous inputs/responses if it detects @; generate a on screen backspace if it detects `<BS`>; print a new prompt if it detects `<CR`>; otherwise it will echo back the input/response form the terminal up to the 40th character where it will await for one of the other four character inputs. The main program will continously walk a one through the onboard LEDs during this process.
