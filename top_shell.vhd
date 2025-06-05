library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity top_shell is
    port (
        clk         : in std_logic;
        Parallel_in : in std_logic_vector(7 downto 0);
        MISO        : in std_logic;
        MOSI        : out std_logic;
        SCLK        : out std_logic;
        CS          : out std_logic
    );
end top_shell;

architecture behavioral_architecture of top_shell is

    -- COMPONENT DECLARATIONS
    component SCI_receiver
        port (
            clk         : in  std_logic;
            Parallel_in : in  std_logic_vector(7 downto 0);
            Load        : in  std_logic;
            Tx          : out std_logic;
            Tx_done     : out std_logic
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

    component DDS
        port (
            clk        : in  std_logic;
            tone_sig   : in  std_logic_vector(7 downto 0);
            sin_sig    : out std_logic_vector(15 downto 0);
            data_valid : out std_logic
        );
    end component;

    component SPI_tx
        port (
            clk         : in  std_logic;
            Parallel_in : in  std_logic_vector(11 downto 0);
            New_data    : in  std_logic;
            MISO        : in  std_logic;
            MOSI        : out std_logic;
            SCLK        : out std_logic;
            CS          : out std_logic;
            Tx_done     : out std_logic
        );
    end component;

    -- INTERNAL SIGNALS
    signal load_in       : std_logic := '1';  -- simplified always-high (optional control logic)
    signal done_in       : std_logic;

    signal midi_channel  : std_logic_vector(3 downto 0);
    signal power_sig     : std_logic_vector(3 downto 0);
    signal tone_byte     : std_logic_vector(7 downto 0);
    signal velocity      : std_logic_vector(7 downto 0);

    signal sine_wave     : std_logic_vector(15 downto 0);
    signal data_valid    : std_logic; -- from DDS
    signal spi_done      : std_logic;
    

begin


    -- Connect SCI_receiver
    SCI_rec_tl: SCI_receiver
        port map (
            clk         => clk,
            Parallel_in => Parallel_in,   -- feed directly from input
            Load        => load_in,       -- trigger for reception
            Tx          => open,
            Tx_done     => done_in
        );

    -- Connect SCI_processor
    SCI_pro_tl: SCI_processor
        port map (
            clk       => clk,
            new_data  => done_in,         -- pulse from SCI_receiver
            data_in   => Parallel_in,     -- same input passed down
            midi_chn  => midi_channel,
            power_on  => power_sig,
            tone_out  => tone_byte,
            vel_out   => velocity
        );

    -- Connect DDS
    DDS_tl: DDS
        port map (
            clk        => clk,
            tone_sig   => tone_byte,
            sin_sig    => sine_wave,
            data_valid => data_valid      -- drives SPI trigger
        );

    -- Connect SPI_tx
    SPI_tl: SPI_tx
        port map (
            clk         => clk,
            Parallel_in => sine_wave(15 downto 4),  -- upper 12 bits
            New_data    => data_valid,              -- trigger from DDS
            MISO        => MISO,
            MOSI        => MOSI,
            SCLK        => SCLK,
            CS          => CS,
            Tx_done     => spi_done
        );

end behavioral_architecture;
