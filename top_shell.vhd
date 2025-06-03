library IEEE;
use IEEE.std_logic_1164.all;



ARCHITECTURE behavior of top_shell IS

Entity top_shell is 
port ( 
	 ) 
end top_shell; 

architecture behavioral_architecture of top_shell is

	COMPONENT SCI_Tx
port(   clk			: 	in 	STD_LOGIC;
		Parallel_in	: 	in 	STD_LOGIC_VECTOR(7 downto 0);
        Load 	 	:	in	STD_LOGIC;
        Tx			:	out STD_LOGIC;
        Tx_done		:	out	STD_LOGIC);
    end COMPONENT;
    
    COMPONENT SCI_processor
PORT( 	clk			: in	std_logic;
		new_data 	: in 	std_logic; 
        data_in		: in 	std_logic_vector(7 downto 0);
        midi_chn	: out	std_logic_vector(3 downto 0);
        power_on	: out	std_logic_vector(3 downto 0);
        tone_out 	: out	std_logic_vector(7 downto 0);
        vel_out		: out	std_logic_vector(7 downto 0));
end COMPONENT; 

	COMPONENT DDS
PORT(




	);
end COMPONENT; 

	COMPONENT D2A_converter 
Port (  clk         : in  std_logic;               -- System clock
        reset       : in  std_logic;
        start       : in  std_logic;               -- Trigger to send data
        digital_in  : in  std_logic_vector(7 downto 0); -- 8-bit data

        sclk        : out std_logic;
        mosi        : out std_logic;
        cs          : out std_logic;
        done        : out std_logic);
end component; 



begin



end behavioral_architecture;
