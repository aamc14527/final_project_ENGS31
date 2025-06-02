-- Code your design here
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

ENTITY SCI_Tx IS 
PORT ( 	clk			: 	in 	STD_LOGIC;
		data_in		: 	in 	STD_LOGIC;
        byte_out	:	out STD_LOGIC_VECTOR(7 downto 0);
        byte_ready	:	out	STD_LOGIC);
end SCI_Tx;

ARCHITECTURE behavior of SCI_Tx is

--Datapath elements
type state_type is (sidle, sstart, sread, sstop);
signal cs, ns : state_type := sidle;


constant BAUD_PERIOD : integer := 320; --for a 10 MHz clock, the baud period is 320, 10000000/31250
constant HALF_BAUD 	: integer := BAUD_PERIOD / 2;
constant NUM_BITS 	: integer := 10; --number of bits being read at a time

signal shift_reg 	: std_logic_vector(9 downto 0) := (others => '1'); --in the example, others are initialized to 1
signal baud_cnt : unsigned(8 downto 0) := (others => '0'); --9 bits for 320, subject to change
signal bit_cnt 	: unsigned(3 downto 0) := (others => '0'); --4 bits to represent 10

signal baud_tc 	: std_logic 	:= '0';
signal bit_tc 	: std_logic 	:= '0';

BEGIN

stateUpdate : process(clk)
BEGIN
	if rising_edge(clk) then 
		current_state <= next_state;
	end if;
end process nextStateLogic;

nextStateLogic : process(cs, ) 
BEGIN
	--defaults go here
	
	case cs is 
		when sidle =>
			if data_in = '0' then 
				
	
end process nextStateLogic;

datapath : process(clk)
begin
	--baud counter 
	if rising_edge(clk) then 
    	baud_cnt <= baud_cnt + 1;
        if baud_cnt = BAUD_PERIOD-1 or Load = '1' then 
        	baud_cnt <= (others => '0');
        end if;
    end if;
    --Asynchronous tc signal
    baud_tc <= '0';
    if baud_cnt = BAUD_PERIOD-1 then 
    	baud_tc <= '1';
    end if;
    
    --bit counter 
    if rising_edge(clk) then 
    	if Load = '1' then 
        	bit_cnt <= (others => '0');
        elsif baud_tc = '1' then 
        	bit_cnt <= bit_cnt + 1;
            if bit_cnt = NUM_BITS-1 then 
            	bit_cnt <= (others => '0');
            end if;
        end if;
    end if;
    
    --shift reg
    if rising_edge(clk) then 
    	if Load = '1' then 
        	shift_reg <= '1' & Data_in & '0'; --Concatenate the start and stop bits
        elsif baud_tc = '1' then 
        	shift_reg <= '1' & shift_reg(9 downto 1); --shift the bits and add an idle bit to the MSB
       	end if;
   	end if;
end process datapath;

Tx <= shift_reg(0);
Tx_done <= bit_tc and baud_tc;

end behavior;
           
