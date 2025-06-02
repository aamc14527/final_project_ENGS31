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

signal clk_counter : integer range 0 to 320 := 0;

--signal baud_tc 	: std_logic 	:= '0';
--signal bit_tc 	: std_logic 	:= '0';

BEGIN

stateUpdate : process(clk)
BEGIN
	if rising_edge(clk) then 
		current_state <= next_state;
	end if;
end process stateUpdate;

nextStateLogic : process(cs, data_in) 
BEGIN
	--defaults go here
	ns <= cs;
	data_ready <= '0';
	
	case cs is 
		when sidle =>
			if data_in = '0' then 
				clk_counter <= HALF_BAUD;
				ns <= sstart;
			end if;
		when sstart =>
			if clk_counter = 0 then 
				bit_cnt <= (others => '0');
				shift_reg <= data_in & shift_reg(9 downto 1); --right shifting into the register
				clk_counter <= BAUD_PERIOD;
				ns <= sread;
			else 
				clk_counter <= clk_counter - 1; --decrementing the counter
			end if;
		when sread =>
			if clk_counter = 0 then 
				bit_cnt <=  bit_cnt + 1;
				shift_reg <= data_in & shift_reg(9 downto 1);
				clk_counter <= BAUD_PERIOD;
				
				if bit_cnt = 8 then 
					ns <= sstop;
				end if;
			else 
				clk_counter <= clk_counter - 1;
			end if;
		when sstop =>
			if clk_counter = 0 then 
				byte_out <= shift_reg(8 downto 1);
				data_ready <= '1';
				ns <= sidle;
			else 
				clk_counter <= clk_counter - 1;
			end if;
		when others => 
			ns <= sidle;
		end case;
end process nextStateLogic;


end behavior;
           
