

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY SPI_Tx_tb is
--no ports for a testbench ENTITY
END SPI_Tx_tb;

architecture behavior of SPI_Tx_tb is

component SPI_Tx 
port (
	clk 			: in std_logic;
	Parallel_in 	: in std_logic_vector(11 downto 0);
	New_data		: in std_logic;
	Power           : in std_logic_vector(3 downto 0);
	--MISO			: in std_logic;
	MOSI 			: out std_logic;
	SCLK			: out std_logic;
	CS 				: out std_logic;
	Tx_done 		: out std_logic
	);
end component;

signal clk 			: std_logic := '0';
signal Parallel_in 	: std_logic_vector(11 downto 0) := (others => '0');
signal New_data 	: std_logic := '0';
signal Power        : std_logic_vector(3 downto 0) := (others => '0');
--signal MISO 		: std_logic := '0';

signal MOSI			: std_logic;
signal SCLK			: std_logic;
signal CS 			: std_logic;
signal Tx_done 		: std_logic;

constant clk_period : time := 10 ns; --100 MHz clock

begin

uut: SPI_Tx port map (
	clk 		=> clk, 
	Parallel_in => Parallel_in, 
	New_data 	=> New_data,
	Power       => Power,
	--MISO 		=> MISO,
	MOSI 		=> MOSI,
	SCLK		=> SCLK,
	CS 			=> CS,
	Tx_done		=> Tx_done
	);
	
clk_proc : process
begin
	clk <= '0';
	wait for clk_period/2;
	clk <= '1';
	wait for clk_period/2;
end process;

stim_proc : process
begin	
	Parallel_in <= "101010101010";
	New_data <= '0';
	wait for clk_period*10; --wait for system to stabilize
	
	--stimulate the spi with new data
	New_data <= '1'; --set new data
	wait for clk_period; --minimal pulse width
	New_data <= '0';
	
	wait for clk_period*100;
	
	wait for 10 us;
	
	-- Initialize Inputs
    Parallel_in <= "111111000000";
    -- Stimulate the SPI_Tx with new data
    New_data <= '1';  -- Set new data
    wait for clk_period;  -- Minimal pulse width
    New_data <= '0';
        
    wait;
end process stim_proc;

end behavior;
