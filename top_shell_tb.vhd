LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY top_shell_tb is
END top_shell_tb;

architecture behavior of top_shell_tb is

component top_level
PORT (  clk         : in std_logic;
        Parallel_in : in  std_logic_vector(7 downto 0);
        MOSI        : out std_logic;
        SCLK        : out std_logic;
        CS          : out std_logic):
END COMPONENT; 

SIGNAL clk         : std_logic;
SIGNAL Parallel_in : std_logic_vector(7 downto 0);
SIGNAL MOSI        : std_logic;
SIGNAL SCLK        : std_logic;
SIGNAL CS          : std_logic;

constant clk_period : time := 10 ns; --10 MHz clock

uut:  top_level port map( 
    clk         => clk,
    Parallel_in => Parallel_in,
    MOSI        => MOSI,
    SCLK        => SCLK,
    CS          => CS ); 


clk_proc : process
begin
	  clk <= '0';
	  wait for clk_period/2;
	  clk <= '1';
	  wait for clk_period/2;
end process;


stim_proc : process
begin	
    wait for 20ns;

    parallel_in => "10011001"
    wait for 2 * clk_period;

    parallel_in => "11111000"
    wait for 2 * clk_period;

    parallel_in => "00011011"
    wait for 2 * clk_period;

    wait; 
end process stim_proc; 
end behavior; 
