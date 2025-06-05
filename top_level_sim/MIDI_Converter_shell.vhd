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
        CS          : out std_logic
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
            --MISO        : in  std_logic;
            MOSI        : out std_logic;
            SCLK        : out std_logic;
            CS          : out std_logic;
            Tx_done     : out std_logic
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
            vel_out   => velocity      --goes nowhere, we are also not using this
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
            New_data    => data_valid_sig,              -- trigger from DDS
            --MISO        => MISO,
            MOSI        => MOSI,
            SCLK        => SCLK,
            CS          => CS,
            Tx_done     => spi_done         --not useful, will keep because further development of this project could find this helpful
        );

end behavioral_architecture;

