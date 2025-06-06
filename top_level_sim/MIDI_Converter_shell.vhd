----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/05/2025 12:12:58 PM
-- Design Name: 
-- Module Name: Midi_Converter_Shell - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity top_shell is
    port (
        clk         : in std_logic;
        Data_in     : in std_logic;
        --MISO        : in std_logic;
        MOSI        : out std_logic;
        SCLK        : out std_logic;
        CS          : out std_logic;
        light_16    : out std_logic;--16 downto 9 will be the tone 
        light_15    : out std_logic;
        light_14    : out std_logic;
        light_13    : out std_logic;
        light_12    : out std_logic; 
        light_11    : out std_logic; 
        light_10    : out std_logic; 
        light_9    : out std_logic; 
        light_8   : out std_logic; --8 downto 4 will be the power
        light_7   : out std_logic;
        light_6   : out std_logic;
        light_5   : out std_logic;
        light_4   : out std_logic; --3 downto 1 is channel
        light_3   : out std_logic;
        light_2   : out std_logic;
        light_1   : out std_logic     
    );
end top_shell;

architecture behavioral_architecture of top_shell is

    -- COMPONENT DECLARATIONS
    component SCI_receiver
        port (
            clk         :   in  std_logic;
            data_in		: 	in 	STD_LOGIC;
            byte_out	:	out STD_LOGIC_VECTOR(7 downto 0);
            byte_ready	:	out	STD_LOGIC
        );
    end component;

    component SCI_processor
        port (
            clk       : in  std_logic;
            new_data  : in  std_logic;
            data_in   : in  std_logic_vector(7 downto 0);
            midi_chn  : out std_logic_vector(3 downto 0);
            power_on  : out std_logic_vector(3 downto 0);
            tone_out  : out std_logic_vector(7 downto 0);  
            vel_out   : out std_logic_vector(7 downto 0)
        );
    end component;

    component DDS_TopLevel
        port (
            clk        : in  std_logic;
            tone_sig   : in  std_logic_vector(7 downto 0);
            sin_sig    : out std_logic_vector(11 downto 0);
            data_valid : out std_logic
        );
    end component;

    component SPI_tx
        port (
            clk         : in  std_logic;
            Parallel_in : in  std_logic_vector(11 downto 0);
            New_data    : in  std_logic;
            Power       : in std_logic_vector(3 downto 0);
            --MISO        : in  std_logic;
            MOSI        : out std_logic;
            SCLK        : out std_logic;
            CS          : out std_logic;
            Tx_done     : out std_logic
            --note_on    : out std_logic             --note_on    

        );
    end component;

    -- INTERNAL SIGNALS
    signal load_in       : std_logic := '1';  -- simplified always-high (optional control logic)
    signal done_in       : std_logic;
    
    signal SCI_Byte      : std_logic_vector (7 downto 0);

    signal midi_channel  : std_logic_vector(3 downto 0);
    signal power_sig     : std_logic_vector(3 downto 0);
    signal tone_byte     : std_logic_vector(7 downto 0);
    signal velocity      : std_logic_vector(7 downto 0);

    signal sine_wave     : std_logic_vector(11 downto 0);
    signal data_valid_sig    : std_logic; -- from DDS
    signal spi_done      : std_logic;

               

begin

lights_proc : process(clk, tone_byte, power_sig, midi_channel) 
begin
    
    
    light_14    <= '0';
    light_13    <= '0';
    light_12    <= '0';
    light_11    <= '0';
    light_10    <= '0';
    light_9     <= '0';
    light_8     <= '0';
    light_7     <= '0';
    light_6     <= '0';
    light_5     <= '0';
    light_4     <= '0';
    light_3     <= '0';
    light_2     <= '0';
    light_1     <= '0';
    if tone_byte(7) = '1' then --tone bytes do indicate the tone of the note
        light_16 <= '1';
    else light_16    <= '0';
    end if;
    if tone_byte(6) = '1'  then
        light_15 <= '1';
    else light_15    <= '0';
    end if;
    if tone_byte(5) = '1' then
        light_14 <= '1';
    end if;
    if tone_byte(4) = '1' then
        light_13 <= '1';
    end if;
    if tone_byte(3) = '1' then
        light_12 <= '1';
    end if;
    if tone_byte(2) = '1' then
        light_11 <= '1';
    end if;
    if tone_byte(1) = '1' then
        light_10 <= '1';
    end if;
    if tone_byte(0) = '1' then
        light_9 <= '1';
    end if;
    if power_sig(3) = '1' then 
        light_8 <= '1';
    end if;
    if power_sig(2) = '1' then 
        light_7 <= '1';
    end if;
    if power_sig(1) = '1' then 
        light_6 <= '1';
    end if;
    if power_sig(0) = '1' then 
        light_5 <= '1';
    end if;
    if midi_channel(3) = '1' then 
        light_4 <= '1';
    end if;
    if midi_channel(2) = '1' then --always high when key is pressed
        light_3 <= '1';
    end if;
    if midi_channel(1) = '1' then 
        light_2 <= '1';
    end if;
    if midi_channel(0) = '1' then 
        light_1 <= '1';
    end if;
end process; 


    -- Connect SCI_receiver
    SCI_rec_tl: SCI_receiver
        port map (
            clk         => clk,
            Data_in     => Data_in,   -- feed directly from input
            byte_out    => SCI_Byte,
            byte_ready  => done_in
        );

    -- Connect SCI_processor
    SCI_pro_tl: SCI_processor
        port map (
            clk       => clk,
            new_data  => done_in,         -- pulse from SCI_receiver
            data_in   => SCI_Byte,     -- same input passed down
            midi_chn  => midi_channel, --goes nowhere, we are not using this for our use case
            power_on  => power_sig,     --also doesn't get used, NEEDS SECOND LOOK
            tone_out  => tone_byte,   
            vel_out   => velocity           
        );

    -- Connect DDS
    DDS_tl: DDS_TopLevel
        port map (
            clk        => clk,
            tone_sig   => tone_byte,
            sin_sig    => sine_wave,
            data_valid => data_valid_sig      -- drives SPI trigger
        );

    -- Connect SPI_tx
    SPI_tl: SPI_tx
        port map (
            clk         => clk,
            Parallel_in => sine_wave,
            New_data    => data_valid_sig,              -- trigger from DDS, this is from the clock divider in there
            Power       => power_sig,
            --MISO        => MISO,
            MOSI        => MOSI,
            SCLK        => SCLK,
            CS          => CS,
            Tx_done     => spi_done         --not useful, will keep because further development of this project could find this helpful
            --note_on     => light_on
        );

end behavioral_architecture;

