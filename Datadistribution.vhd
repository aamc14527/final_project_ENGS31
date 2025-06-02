-- Code your design here
library IEEE;
use IEEE.std_logic_1164.all;

ENTITY DATA_dist
port (   Byte_ready : in  STD_LOGIC;
		 clk        : in  STD_LOGIC;
         pow_en     : in  STD_LOGIC;
         tone_en    : in  STD_LOGIC;
         velo_en    : in  STD_LOGIC;
         status_note: out STD_LOGIC_VECTOR (3 downto 0);
         Midi_chan  : out STD_LOGIC_VECTOR (3 downto 0);
         Note_value : out STD_LOGIC_VECTOR (7 downto 0);
         Note_velo  : out STD_LOGIC_VECTOR (7 downto 0);
      );
         
end DATA_dist; 

architecture behavior of DATA_dist is
type state_type is (idle,Spower_in,Stone_in,Svelo_in);
Signal cs, ns: state_type;

Signal power_byte_ready : STD_LOGIC;
Signal tone_byte_ready  : STD_LOGIC;
Signal velo_byte_ready  : STD_LOGIC; 

signal power_out        : STD_LOGIC_VECTOR(7 downto 0);
signal tone_out         : STD_LOGIC_VECTOR(7 downto 0);
signal velo_out         : STD_LOGIC_VECTOR(7 downto 0);

signal power_reg : STD_LOGIC_VECTOR(7 downto 0) := (others => '1');
signal tone_reg  : STD_LOGIC_VECTOR(7 downto 0) := (others => '1');
signal velo_reg  : STD_LOGIC_VECTOR(7 downto 0) := (others => '1');

signal tone_count: STD_LOGIC_VECTOR(7 downto 0); 

begin

	if rising_edge(clk_port) then 
        	cs <= ns;
        end if;
    end process StateUpdate;
    
	NextStateLogic: process(cs,power_byte_ready,tone_byte_ready,velo_byte_ready)
	begin
    	
    	
        ns <= cs;
        
    	case(cs) is 
        
        	when Idle => 
            	if power_byte_ready = '1' then 
                	ns <= Spower_in;
                end if;
            when Spower_in => 
            	if tone_byte_ready = '1' then 
                	pow_en <= '1';
                	ns <= Stone_in;
                end if;
            when Stone_in => 
            	if velo_byte_ready = '1' then 
                    tone_en <= '1';
                	ns <= Svelo_in;
                end if; 
            when Svelo_in =>
            	velo_en <= '1';
            	ns <= Idle; 
	when others => 
		ns <= idle; 
        end case;
end process; 

register_proc process : (clk) 
begin

	if pow_en = '1' then 
    	power_reg <= power_out; 
    end if; 
    
    if tone_en = '1' then 
    	tone_reg <= tone_out;
    end if; 
    -- if velo_en = '1' then 
    	-- velo_reg <= velo_out; 
    -- end if;
end process; 
 end behavior;                    
                 
    
    
    

     
	
