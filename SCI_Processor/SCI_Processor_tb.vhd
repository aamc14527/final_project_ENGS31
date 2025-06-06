


library IEEE;
use IEEE.std_logic_1164.all;


entity SCI_Processor_tb is
end SCI_Processor_tb;

architecture testbench of SCI_Processor_tb is

	COMPONENT SCI_Processor 
    PORT ( 	clk			: in	std_logic;
            new_data 	: in 	std_logic;
            data_in		: in 	std_logic_vector(7 downto 0);
            midi_chn	: out	std_logic_vector(3 downto 0);
            power_on	: out	std_logic_vector(3 downto 0);
            tone_out 	: out	std_logic_vector(7 downto 0);
            vel_out		: out	std_logic_vector(7 downto 0);
            light_16    : out std_logic;--16 downto 9 will be the tone 
        light_15    : out std_logic;
        light_14    : out std_logic;
        light_13    : out std_logic;
        light_12    : out std_logic; 
        light_11    : out std_logic; 
        light_10    : out std_logic; 
        light_9    : out std_logic; 
        light_8   : out std_logic; --8 downto 4 will be the power
        light_7   : out std_logic;
        light_6   : out std_logic;
        light_5   : out std_logic;
        light_4   : out std_logic; --3 downto 1 is channel
        light_3   : out std_logic;
        light_2   : out std_logic;
        light_1   : out std_logic     
        );
    end COMPONENT;
    
    --in signals
    signal clk			:	std_logic := '0';
    signal new_data 	:  	std_logic := '0';
    signal data_in		:  	std_logic_vector(7 downto 0) := (others => '0');
    --out signals
    signal midi_chn		: 	std_logic_vector(3 downto 0) := (others => '0');
    signal power_on		: 	std_logic_vector(3 downto 0) := (others => '0');
    signal tone_out 	: 	std_logic_vector(7 downto 0) := (others => '0');
    signal vel_out		: 	std_logic_vector(7 downto 0) := (others => '0');
    signal light_16    : std_logic;--16 downto 9 will be the tone 
    signal  light_15    :  std_logic;
     signal   light_14    :  std_logic;
    signal    light_13    :  std_logic;
      signal  light_12    :  std_logic; 
       signal light_11    :  std_logic; 
     signal   light_10    :  std_logic; 
      signal  light_9    :  std_logic; 
       signal light_8   :  std_logic; --8 downto 4 will be the power
      signal  light_7   :  std_logic;
      signal  light_6   :  std_logic;
      signal  light_5   :  std_logic;
      signal  light_4   :  std_logic; --3 downto 1 is channel
      signal  light_3   :  std_logic;
     signal   light_2   :  std_logic;
     signal   light_1   :  std_logic;   
    
    constant clk_period : time := 100 ns;  -- Assuming a 100 MHz clock
    
BEGIN
    
    uut : SCI_Processor PORT MAP (
    	clk 		=> 	clk,
        new_data	=>	new_data,
    	data_in		=>	data_in,
    	midi_chn	=>	midi_chn,
        power_on	=> 	power_on,
        tone_out	=>	tone_out,
        vel_out		=>	vel_out, 
        light_16    => light_16,
        light_15    => light_15,
        light_14    => light_14,
        light_13    => light_13,
        light_12    => light_12,
        light_11    => light_11,
        light_10    => light_10,
        light_9     => light_9,
        light_8     => light_8,
        light_7     => light_7,
        light_6     => light_6,
        light_5     => light_5,
        light_4     => light_4,
        light_3     => light_3,
        light_2     => light_2,
        light_1     => light_1

    );
    
    -- Clock process definitions
    clk_process : process
    begin
        clk <= '1';
        wait for clk_period/2;
        clk <= '0';
        wait for clk_period/2;
    end process;
    
    -- Stimulus process
    stim_proc: process
    begin
    	--initialize inputs
        new_data <= '0';
        data_in <= (others => '0');
        
        wait for clk_period*5; 
        
        --sci receive signal and sends it in three parts
        --part one: on/off and channel byte
        new_data <= '1'; 
        data_in <= "10001001";
        
        --reset
        wait for clk_period;        
        new_data <= '0';

        wait for clk_period;
        
        --part two: tone byte
        new_data <= '1'; 
        data_in <= "10101010";
        
        --reset
        wait for clk_period;
        new_data <= '0';
        wait for clk_period;
    
    	--part three: velocity byte
        new_data <= '1'; 
        data_in <= "11001100";
    
    	--reset
        wait for clk_period;
        new_data <= '0';


		wait;
	end process stim_proc;
end testbench;
