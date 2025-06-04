

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
            vel_out		: out	std_logic_vector(7 downto 0));
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
    
    constant clk_period : time := 10 ns;  -- Assuming a 100 MHz clock
    
BEGIN
    
    uut : SCI_Processor PORT MAP (
    	clk 		=> 	clk,
        new_data	=>	new_data,
    	data_in		=>	data_in,
    	midi_chn	=>	midi_chn,
        power_on	=> 	power_on,
        tone_out	=>	tone_out,
        vel_out		=>	vel_out 
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
