## Final Project

### SCI Receiver
Takes input from the MIDI (3 byte signals, each led by a start bit (LOW) and a stop bit (HIGH). Takes this input and sends 8 bits of information along with a data ready signal as an output.

#### SCI_Tx
inputs: clk (std_logic), data_in (std_logic)  
outputs: byte_out (std_logic_vector(7 downto 0)), byte_ready (std_logic)
