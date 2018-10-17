# 16 bit counter project contents
The files inside:</br>
AISO.v - Asynchronous In Synchronous Out (AISO) reset which sychronizes an asychronous reset to bring all synchronous logic clock signals to a known state to eliminate any possible issues with the clock and reset.</br>
db_fsm.v - A debounce finite state machine which ensures the stabalization of an input assertion/deassertion.</br>
pulse_maker.v - A edge detector which sends a one clock wide output when the detection of an input goes high.</br>
dec.v - A decoder which determines which address to write/read to.</br>
sev_seg_fsm.v - A finite state machine to handle the logic of displaying a hexadecimal number onto a seven segment display.</br>
