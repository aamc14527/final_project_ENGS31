

library IEEE;
use IEEE.std_logic_1164.all;

Entity SCI_Processor is 
PORT ( 	clk			: in	std_logic;
		new_data 	: in 	std_logic; 
        data_in		: in 	std_logic_vector(7 downto 0);
        midi_chn	: out	std_logic_vector(3 downto 0);
        power_on	: out	std_logic_vector(3 downto 0);
        tone_out 	: out	std_logic_vector(7 downto 0);
        vel_out		: out	std_logic_vector(7 downto 0));
end SCI_Processor;
        
architecture behavior of SCI_Processor is

type state_type is (idle, on_receive, tone_receive, vel_receive);
signal cs	: state_type := idle; 
signal ns 	: state_type := idle; 

signal power		: std_logic_vector(3 downto 0);
signal channel		: std_logic_vector(3 downto 0);
signal tone			: std_logic_vector(7 downto 0);
signal velocity		: std_logic_vector(7 downto 0);

signal Power_en	:	std_logic := '0';
signal tone_en	:	std_logic := '0';
signal vel_en	:	std_logic := '0';

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

	case cs is
    
    	when idle => 
        
        when on_receive =>
        	power <= data_in(7 downto 4);
            channel <= data_in(3 downto 0);
            
        when tone_receive =>
        	tone <= data_in;
        
        when vel_receive =>
			velocity <= data_in;
            
    end case; 

end process out_logic; 

power_on <= power;
midi_chn <= channel;
tone_out <= tone;
vel_out <= velocity;

end behavior;
