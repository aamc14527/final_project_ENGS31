library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity shift_reg_tb is
end shift_reg_tb;

architecture test of shift_reg_tb is

    -- DUT signals
    signal clk        : std_logic := '0';
    signal data_in    : std_logic := '1';
    signal byte_out   : std_logic_vector(7 downto 0);
    signal byte_ready : std_logic;

    -- Constants
    constant CLOCK_PERIOD : time := 100 ns;  -- 10 MHz clock
    constant BAUD_PERIOD_CYCLES : integer := 320;
    constant BAUD_PERIOD : time := CLOCK_PERIOD * BAUD_PERIOD_CYCLES;

    -- Component declaration
    component shift_Reg
        port (
            clk        : in  std_logic;
            data_in    : in  std_logic;
            byte_out   : out std_logic_vector(7 downto 0);
            byte_ready : out std_logic
        );
    end component;

begin

    -- DUT instantiation
    DUT: shift_reg
        port map (
            clk        => clk,
            data_in    => data_in,
            byte_out   => byte_out,
            byte_ready => byte_ready
        );

    -- Clock generation
    clk_process : process
    begin
        while now < 10 ms loop
            clk <= '0';
            wait for CLOCK_PERIOD / 2;
            clk <= '1';
            wait for CLOCK_PERIOD / 2;
        end loop;
        wait;
    end process;

    -- Stimulus process
    stim_proc: process
        procedure send_serial_byte(b : std_logic_vector(7 downto 0)) is
        begin
            -- Start bit
            data_in <= '0';
            wait for BAUD_PERIOD;

            -- Data bits (LSB first)
            for i in 0 to 7 loop
                data_in <= b(i);
                wait for BAUD_PERIOD;
            end loop;

            -- Stop bit
            data_in <= '1';
            wait for BAUD_PERIOD;
        end procedure;
    begin
        wait for 1 us;  -- wait before starting

        -- Send a byte (e.g., '10101010')
        send_serial_byte("10101010");

        -- Wait to observe result
        wait for 5 * BAUD_PERIOD;

        -- Send another byte (e.g., '11001100')
        send_serial_byte("11001100");

        wait for 5 * BAUD_PERIOD;

        wait;
    end process;

end test;
