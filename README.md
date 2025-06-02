## Final Project

### SCI Receiver
Takes input from the MIDI (3 byte signals, each led by a start bit (LOW) and a stop bit (HIGH). Takes this input and sends 8 bits of information along with a data ready signal as an output.

#### SCI_Tx
ENTITY SCI_Tx IS 
PORT ( 	clk			: 	in 	STD_LOGIC;
		data_in		: 	in 	STD_LOGIC;
        byte_out	:	out STD_LOGIC_VECTOR(7 downto 0);
        byte_ready	:	out	STD_LOGIC);
end SCI_Tx;
