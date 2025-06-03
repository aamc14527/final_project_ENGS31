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

#### DDS
DDS will take the tone value given by the SCI Processor and pass it to a ROM holding a sine wave to pass the desired pitch to the DAC. The DDS contains three key components: first, a clock divider that determines the sampling rate (of the sine wave from the ROM). This sampling rate is the speed at which an incrementer counts. The incrementer will count by m to N-1. N is equal to the size of the ROM (in bit count) and m is what determines at what interval the counter moves. The output of the counter is sent at the sampling rate to determine when the ROM is read and at what address.

#### DDS_toplevel
inputs: tone_sig (std_logic(7 downto 0)) <br> 
outputs: sin_addr (std_logic()) <br>

### Digital to Analog Converter
Final step in the datapath. This takes outputs from() and () in order to convert the digital signals to analog 

#### Digital_Analog
inputs: clk (std_logic), reset (std_logic), start (std_logic) digital_in (std_logic_vector(7 downto 0)) <br>
outputs: sclk (std_logic) mosi (std_logic), cs (std_logic), done (std_logic) <br> 
