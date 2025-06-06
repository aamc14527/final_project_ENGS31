
-- Code your design here
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

ENTITY SCI_Receiver IS 
PORT ( 	clk		: 	in 	STD_LOGIC;
	data_in		: 	in 	STD_LOGIC;
        byte_out	:	out STD_LOGIC_VECTOR(7 downto 0);
        byte_ready	:	out	STD_LOGIC;
        baud_term   : out std_logic -- for debugging
     );
end SCI_Receiver;

ARCHITECTURE behavior of SCI_Receiver is

--Datapath elements
type state_type is (sidle, sstart, sread, sstop);
signal cs, ns : state_type := sidle;


constant BAUD_PERIOD 	: integer := 3200; --for an 100 MHz clock, the baud period is 3200, 100000000/31250
constant HALF_BAUD 	: integer := BAUD_PERIOD / 2;

signal shift_reg 	: std_logic_vector(9 downto 0) := (others => '1'); --in the example, others are initialized to 1
signal baud_cnt : unsigned(11 downto 0) := (others => '0'); --9 bits for 320, subject to change
signal bit_cnt 	: unsigned(3 downto 0) := (others => '0'); --4 bits to represent 10

signal data_ready : std_logic := '0';

signal baud_tc 	: std_logic 	:= '0';
signal bit_tc 	: std_logic 	:= '0';

BEGIN

stateUpdate : process(clk)
BEGIN
	if rising_edge(clk) then 
		cs <= ns;
	end if;
end process stateUpdate;

nextStateLogic : process(cs, data_in, baud_tc, bit_cnt) 
BEGIN
	--defaults go here
	ns <= cs;
	data_ready <= '0';
	
	case cs is 
		when sidle =>
			if data_in = '0' then --first bit ready
				ns <= sstart;
			end if;
		when sstart =>
			if baud_tc = '1' then --first bit read at midpoint
				ns <= sread;
			end if;
		when sread =>
			if baud_tc = '1' then 
				if bit_cnt = 8 then --8 bits received
					ns <= sstop;
				end if;
			end if;
		when sstop =>
			if baud_tc = '1' then 
				data_ready <= '1';
				ns <= sidle;
			end if;
		when others => 
			ns <= sidle;
		end case;
end process nextStateLogic;

baudRateClock : process(clk) 
BEGIN
	if rising_edge(clk) then 
      if cs = sidle and data_in = '0' then --starts the baud counter
          baud_cnt <= to_unsigned(HALF_BAUD-1, 12); --setting the baud cnt to HALF_BAUD
          baud_tc <= '0';
      elsif baud_cnt = 0 then 
          baud_cnt <= to_unsigned(BAUD_PERIOD-1, 12); --non midpoint
          baud_tc <= '1';
      else 
          baud_cnt <= baud_cnt - 1;
          baud_tc <= '0';
      end if;
    end if;
end process baudRateClock;
		
receiver : process(clk) 
BEGIN
	if rising_edge(clk) then 
	    	if cs = sread and baud_tc = '1' then 
	        	shift_reg <= data_in & shift_reg(9 downto 1);
	          	bit_cnt <= bit_cnt + 1;
	      	elsif cs = sidle then --back to default params
	         	shift_reg <= (others => '1');
	         	bit_cnt <= (others => '0');
	      	end if;
	
	      	if cs = sstop and baud_tc = '1' then 
	          	byte_out <= shift_reg(8 downto 1); --remove the start and stop bits from the output
	      	end if;
 	end if;
end process receiver;

byte_ready <= data_ready;
baud_term <= baud_tc;
end behavior;
           
