
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity SPI_Tx is
port(
    clk			: in  std_logic;
	Parallel_in	: in  std_logic_vector(11 downto 0);
    New_data	: in  std_logic; --is this the size of the power signature
    MISO		: in  std_logic;
	MOSI		: out std_logic;
    SCLK        : out std_logic;
    CS			: out std_logic;
	Tx_done     : out std_logic   
	);        
end SPI_Tx;

architecture behavior of SPI_Tx is

--FSM states
type state_type is (idle, shifting, done);
signal cst, ns	: state_type := idle;

--Shift register
signal SPI_reg 	: std_logic_vector(11 downto 0) := (others => '0');
signal shift_en	: std_logic;

--bit counter
constant BIT_CNT_MAX	: integer := 12;
signal bit_cnt 			: integer range 0 to BIT_CNT_MAX := 0;
signal bit_cnt_en 		: std_logic;
signal bit_cnt_clr 		: std_logic;
signal bit_cnt_tc		: std_logic;

--sclk counter
constant SCLK_CNT_MAX 		: integer := 10; --10 mhz main clock, what do we want the output to be (this is for 1 MHz rn)
constant SCLK_CNT_TOGGLE	: integer := SCLK_CNT_MAX/2;

signal SCLK_cnt 	: integer range 0 to SCLK_CNT_MAX;
signal SCLK_cnt_en	: std_logic;
signal SCLK_cnt_clr : std_logic;

begin 

stateUpdate	: process(clk)
begin
	if rising_edge(clk) then 
		cst <= ns;
	end if;
end process stateUpdate;


--somehow going to need logic to interpret the power signal 
nextStateLogic : process(cst, New_data, bit_cnt_tc)
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
			if New_data = '1' then 
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
		if New_data = '1' then 
			SPI_reg <= Parallel_in;
		elsif shift_en = '1' then 
			SPI_reg <= SPI_reg(10 downto 0) & '0';
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
MOSI <= SPI_reg(11);

end behavior;
