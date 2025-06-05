library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top_shell_tb is
end top_shell_tb;

architecture behavior of top_shell_tb is

    component top_shell
        port (
            clk         : in std_logic;
            Parallel_in : in std_logic_vector(7 downto 0);
            MISO        : in std_logic;
            MOSI        : out std_logic;
            SCLK        : out std_logic;
            CS          : out std_logic
        );
    end component;

    -- signals
    signal clk         : std_logic := '0';
    signal Parallel_in : std_logic_vector(7 downto 0) := (others => '0');
    signal MISO        : std_logic := '0';
    signal MOSI        : std_logic;
    signal SCLK        : std_logic;
    signal CS          : std_logic;

    constant clk_period : time := 10 ns;

begin

    -- DUT instantiation
    uut: top_shell
        port map (
            clk         => clk,
            Parallel_in => Parallel_in,
            MISO        => MISO,
            MOSI        => MOSI,
            SCLK        => SCLK,
            CS          => CS
        );

    -- Clock process
    clk_process : process
    begin
        while now < 500 ns loop  -- Run sim for 500 ns max
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
        wait;
    end process;

    -- Stimulus process
    stim_proc : process
    begin
        -- Wait for reset/setup
        wait for 20 ns;

        -- Send 3 bytes
        Parallel_in <= "10011001";
        wait for clk_period * 2;

        Parallel_in <= "11111000";
        wait for clk_period * 2;

        Parallel_in <= "00011011";
        wait for clk_period * 2;

        -- Idle
        wait for 200 ns;

        wait;
    end process;

end behavior;
