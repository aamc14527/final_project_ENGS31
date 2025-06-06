

library IEEE;
use IEEE.std_logic_1164.all;

Entity SCI_Processor is 
PORT ( 	clk			: in	std_logic;
		new_data 	: in 	std_logic; 
        data_in		: in 	std_logic_vector(7 downto 0);
        midi_chn	: out	std_logic_vector(3 downto 0);
        power_on	: out	std_logic_vector(3 downto 0);
        tone_out 	: out	std_logic_vector(7 downto 0);
        vel_out		: out	std_logic_vector(7 downto 0)
        --light_16    : out std_logic;--16 downto 9 will be the tone 
       -- light_15    : out std_logic;
       -- light_14    : out std_logic;
       -- light_13    : out std_logic;
      --  light_12    : out std_logic; 
      --  light_11    : out std_logic; 
      --  light_10    : out std_logic; 
    --    light_9    : out std_logic; 
       -- light_8   : out std_logic; --8 downto 4 will be the power
     --   light_7   : out std_logic;
     --   light_6   : out std_logic;
      --  light_5   : out std_logic;
     --   light_4   : out std_logic; --3 downto 1 is channel
      --  light_3   : out std_logic;
     --   light_2   : out std_logic;
      --  light_1   : out std_logic     
        );
end SCI_Processor;
        
architecture behavior of SCI_Processor is

type state_type is (idle, on_receive, tone_receive, vel_receive);
signal cs	: state_type := idle; 
signal ns 	: state_type := idle; 

signal power		: std_logic_vector(3 downto 0);
signal channel		: std_logic_vector(3 downto 0);
signal tone			: std_logic_vector(7 downto 0);
signal velocity		: std_logic_vector(7 downto 0);

signal update_on_reg : std_logic  := '0';
signal update_tone_reg : std_logic  := '0';
signal update_velocity_reg : std_logic  := '0';

BEGIN



state_update : process (clk)
begin
	if rising_edge(clk) then
    	cs <= ns;
    end if;
end process state_update;

next_state_logic : process (cs, new_data)
begin
	ns<=cs;

	case (cs) is
    
    	when idle =>
        	if(new_data = '1') then
            	ns <= on_receive;
            end if;
        
        when on_receive =>
        	if(new_data = '1') then
            	ns <= tone_receive;
            end if;
        
        when tone_receive =>
        	if(new_data = '1') then
            	ns <= vel_receive;
            end if;
        
        when vel_receive =>
        	ns <= idle; 
     end case; 
end process next_state_logic; 

out_logic : process (cs)
begin
   update_on_reg <= '0';
   update_tone_reg <= '0';
   update_velocity_reg <= '0';
   
	case cs is
    
    	when idle => 

        
        when on_receive =>
            update_on_reg <= '1';
        	
            
        when tone_receive =>
        	update_tone_reg <= '1';
        
        when vel_receive =>
			update_velocity_reg <= '1';
            
    end case; 

end process out_logic; 

update_registers : process(clk)
begin
    if rising_edge(clk) then
        if update_on_reg = '1' then
            power <= data_in(7 downto 4);
            channel <= data_in(3 downto 0);
        end if;
        if update_tone_reg = '1' then
            tone <= data_in;
        end if;
        if update_velocity_reg = '1' then
            velocity <= data_in;
        end if;
    end if;
end process update_registers;

power_on <= power;
midi_chn <= channel;
tone_out <= tone;
vel_out <= velocity;



end behavior;
