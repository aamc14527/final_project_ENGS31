

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity SPI_Tx is
port(
    	clk		: in  std_logic;
	   Parallel_in	: in  std_logic_vector(11 downto 0);
    	New_data	: in  std_logic;
    	Power      : in std_logic_vector(3 downto 0);
    	--MISO		: in  std_logic; --not used, probably redundant in this implementation
	    MOSI		: out std_logic;
    	SCLK        	: out std_logic;
    	CS		: out std_logic;
	    Tx_done     	: out std_logic 
	    --note_on    : out std_logic --for debugging, turns right most light on when a note is presssed

	);        
end SPI_Tx;

architecture behavior of SPI_Tx is

--FSM states
type state_type is (idle, shifting, done, wait_low, wait_high, pulse);
signal cst, ns : state_type := idle;

type states is (wait_low, wait_high, pulse);
signal current_state, next_state : states := (wait_high);


--Shift register
signal SPI_reg 	: std_logic_vector(15 downto 0) := (others => '0');
signal shift_en	: std_logic;

--bit counter
constant BIT_CNT_MAX	: integer := 16;
signal bit_cnt 			: integer range 0 to BIT_CNT_MAX := 0;
signal bit_cnt_en 		: std_logic;
signal bit_cnt_clr 		: std_logic;
signal bit_cnt_tc		: std_logic;

--sclk counter
constant SCLK_CNT_MAX 		: integer := 100; --100 MHz clock, this is to divide into a 1 MHz clock
constant SCLK_CNT_TOGGLE	: integer := SCLK_CNT_MAX/2;

signal SCLK_cnt 	: integer range 0 to SCLK_CNT_MAX;
signal SCLK_cnt_en	: std_logic;
signal SCLK_cnt_clr : std_logic;

signal new_data_sig : std_logic := '0';


begin 


stateUpdate	: process(clk)
begin
	if rising_edge(clk) then 
		cst <= ns;
	end if;
end process stateUpdate;


--somehow going to need logic to interpret the power signal 
nextStateLogic : process(cst, new_data_sig, bit_cnt_tc)
begin
	--defaults
	ns <= cst;
	SCLK_cnt_clr <= '0';
	SCLK_cnt_en <= '0';
	bit_cnt_clr <= '0';
	CS <= '1';
	Tx_done <= '0';
	
	case cst is 
		when idle => 
			bit_cnt_clr <= '1';
			SCLK_cnt_clr <= '1';
			if new_data_sig = '1' then 
				ns <= shifting;
			end if;
			
		when shifting =>
			CS <= '0';
			SCLK_cnt_en <= '1';
			if bit_cnt_tc = '1' then 
				ns <= done;
			end if;
		
		when done =>
			Tx_done <= '1';
			ns <= idle;
		
		when others => 
			ns <= idle;
		
	end case;
end process nextStateLogic;

--Datapath
shift_reg : process(clk) 
begin
	if rising_edge(clk) then 
		if new_data_sig = '1' then 
			SPI_reg <= "0000" & Parallel_in;
		elsif shift_en = '1' then 
			SPI_reg <= SPI_reg(14 downto 0) & '0';
		end if;
	end if;
end process shift_reg;


counters : process(clk, bit_cnt, SCLK_cnt, bit_cnt_en)
begin
	--keep track of the number of bits
	if rising_edge(clk) then 
		if bit_cnt_clr = '1' then  
			bit_cnt <= 0;
		elsif bit_cnt_en = '1' then 
			if bit_cnt < BIT_CNT_MAX-1 then 
				bit_cnt <= bit_cnt + 1;
			else 
				bit_cnt <= 0;
			end if;
		end if; 
	end if;

	--asynchronous tc for the bit counter, makes sure that it only goes high for a single clock cycle
	bit_cnt_tc <= '0';
	if bit_cnt = BIT_CNT_MAX-1 and bit_cnt_en = '1' then 
		bit_cnt_tc <= '1';
	end if;
	
	--generate sclk
	if rising_edge(clk) then 
		if SCLK_cnt_clr = '1' then 
			SCLK_cnt <= 0;
		elsif SCLK_cnt_en = '1' then 
			SCLK_cnt <= SCLK_cnt + 1;
			if SCLK_cnt = SCLK_CNT_MAX-1 then 
				SCLK_cnt <= 0;
			end if;
		end if;
	end if;
	
	--asynchronous generation of SCLK signal
	SCLK <= '0';
	if SCLK_cnt >= SCLK_CNT_TOGGLE-1 then 
		SCLK <= '1';
	end if;
	
	--asynchronous tc signals that enable the shift register and enable the bit counter
	bit_cnt_en <= '0';
	shift_en <= '0';
	if SCLK_cnt = SCLK_CNT_MAX-1 then 
		bit_cnt_en <= '1';
		shift_en <= '1';
	end if;
	
end process counters;

stateUpdate2 : process(clk)
begin
    if rising_edge(clk) then
        current_state <= next_state;
    end if;
end process stateUpdate2;

-- STATES: wait_low, pulse, wait high
process (current_state, New_data)
begin
        new_data_sig <= '0';
        next_state <= current_state;
        
        case current_state is

            when wait_low =>
                if New_data = '1' then 
                    next_state <= pulse;
                end if;
            when pulse => 
                new_data_sig <= '1';
                next_state <= wait_high;
            when wait_high => 
                if New_data = '0' then 
                    next_state <= wait_low;
                end if;
        end case; 
end process;
power_proc : process(Power)
begin   
    if Power = "1001" then 
        MOSI <= SPI_reg(15);
    end if;
end process power_proc;
end behavior;
