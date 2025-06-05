
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY DDS_toplevel_tb is
END DDS_toplevel_tb;

architecture behavior of DDS_toplevel_tb is

component DDS_TopLevel 
  port ( clk      : in std_logic;
       tone_sig : in std_logic_vector(7 downto 0);
       sin_sig  : out std_logic_vector(11 downto 0);
       data_valid : OUT STD_LOGIC 
);
end component;
  signal   clk      : std_logic;
  signal   tone_sig : std_logic_vector(7 downto 0);
  signal   sin_sig  : std_logic_vector(11 downto 0);
  signal data_valid : STD_LOGIC; 

  constant clk_period : time := 10 ns; --10 MHz clock
  constant slow_clk_period : time := 62.5 us; --16 kHz clock

begin 

uut: DDS_TopLevel port map (
  clk      => clk,
  tone_sig => tone_sig,
  sin_sig  => sin_sig, 
  data_valid => data_valid
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
    wait for 20ns;

    tone_sig <= x"45"; 
    wait for 10000 * slow_clk_period;

    tone_sig <= x"3C"; 
    wait for 10000 * slow_clk_period;

    tone_sig <= x"32"; 
    wait for 10000 * slow_clk_period;

    tone_sig <= x"47"; 
    wait for 10000 * slow_clk_period;
    
    tone_sig <= x"01"; 
    wait for 10000 * slow_clk_period;
      
    wait;
  end process stim_proc; 
end behavior; 
  
  
