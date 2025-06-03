## Final Project

### SCI Receiver
Takes input from the MIDI (3 byte signals, each led by a start bit (LOW) and a stop bit (HIGH). Takes this input and sends 8 bits of information along with a data ready signal as an output. byte_ready flag is only high for one clock cycle.

#### SCI_Tx
inputs: clk (std_logic), data_in (std_logic) <br>
outputs: byte_out (std_logic_vector(7 downto 0)), byte_ready (std_logic) <br>

### SCI Processor
Takes bytes from SCI Receiver and sends them to apropriate registers to store on/off, channel, tone, and velocity. It expects new_data flag to only be high for one clock cycle and for data_in value to remain constant until new_data is toggled again. 

#### SCI_Processor
inputs: clk (std_logic), data_in (std_logic_vector(7 downto 0)), new_data (std_logic) <br>
outputs: midi_chn (std_logic_vector(3 downto 0)), power_on (std_logic_vector(3 downto 0)), tone_out (std_logic_vector(7 downto 0)), vel_out (std_logic_vector(7 downto 0)) <br>


### Digital to Analog Converter
Final step in the datapath. This takes outputs from() and () in order to convert the digital signals to analog 

#### Digital_Analog
inputs: clk (std_logic), reset (std_logic), start (std_logic) digital_in (std_logic_vector(7 downto 0)) <br>
outputs: sclk (std_logic) mosi (std_logic), cs (std_logic), done (std_logic) <br> 
