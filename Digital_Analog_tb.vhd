-- Code your testbench here
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_spi_dac_driver is
end tb_spi_dac_driver;

architecture behavior of tb_spi_dac_driver is

    -- Component declaration
    component spi_dac_driver
        Port (
            clk         : in  std_logic;
            reset       : in  std_logic;
            start       : in  std_logic;
            digital_in  : in  std_logic_vector(11 downto 0);
            sclk        : out std_logic;
            mosi        : out std_logic;
            cs          : out std_logic;
            done        : out std_logic
        );
    end component;

    -- Testbench signals
    signal clk         : std_logic := '0';
    signal reset       : std_logic := '0';
    signal start       : std_logic := '0';
    signal digital_in  : std_logic_vector(11 downto 0) := (others => '0');
    signal sclk        : std_logic;
    signal mosi        : std_logic;
    signal cs          : std_logic;
    signal done        : std_logic;

    -- Clock generation: 10 ns period (100 MHz)
    constant clk_period : time := 10 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: spi_dac_driver
        port map (
            clk         => clk,
            reset       => reset,
            start       => start,
            digital_in  => digital_in,
            sclk        => sclk,
            mosi        => mosi,
            cs          => cs,
            done        => done
        );

    -- Clock process
    clk_process :process
    begin
        clk <= '0';
        wait for clk_period / 2;
        clk <= '1';
        wait for clk_period / 2;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- Initialize
        reset <= '1';
        wait for 2 * clk_period;
        reset <= '0';

        -- Wait and apply input
        wait for 20 ns;
        digital_in <= "101010101010";
        start <= '1';
        wait for 4* clk_period;
        start <= '0';

        -- Wait for transaction to complete
        wait until done = '1';

        -- Insert delay and end
        wait for 100 ns;
        digital_in <= "110011001100";
        start <= '1';
        wait for 3 * clk_period;
        start <= '0';

        wait until done = '1';
        wait for 100 ns;

        assert false report "Simulation complete." severity failure;
    end process;

end behavior;


        assert false report "Simulation complete." severity failure;
    end process;

end behavior;
