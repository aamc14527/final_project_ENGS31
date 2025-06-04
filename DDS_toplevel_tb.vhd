LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY DDS_toplevel_tb is
END DDS_toplevel_tb;

architecture behavior of DDS_toplevel_tb is

component DDS_TopLevel 
  port ( clk      : in std_logic;
       tone_sig : in std_logic_vector(7 downto 0);
       sin_sig  : out std_logic_vector(15 downto 0)
);
end component;
  signal   clk      : in std_logic;
  signal   tone_sig : in std_logic_vector(7 downto 0);
  signal   sin_sig  : out std_logic_vector(15 downto 0);

  constant clk_period : time := 100 ns; --10 MHz clock

begin 

uut: DDS_TopLevel portmap (
  clk      => clk,
  tone_sig => tone_sig,
  sin_sig  => sin_sig 
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
    wait for 2 * clk_period;

    tone_sig <= x"3C"; 
    wait for 2 * clk_period;

    tone_sig <= x"32"; 
    wait for 2 * clk_period;

    tone_sig <= x"47"; 
    wait for 2 * clk_period;
      
    wait;
  end process stim_proc; 
  end behavior; 
  

