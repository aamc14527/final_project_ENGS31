-- Code your design here
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity spi_dac_driver is
    Port (
        clk         : in  std_logic;               -- System clock
        reset       : in  std_logic;
        start       : in  std_logic;               -- Trigger to send data
        digital_in  : in  std_logic_vector(7 downto 0); -- 8-bit data

        sclk        : out std_logic;
        mosi        : out std_logic;
        cs          : out std_logic;
        done        : out std_logic                 -- Done signal
    );
end spi_dac_driver;

architecture Behavioral of spi_dac_driver is
    type state_type is (IDLE, LOAD, SHIFT, FINISH);
    signal state : state_type := IDLE;

    signal shift_reg : std_logic_vector(7 downto 0);
    signal bit_cnt   : integer range 0 to 7 := 0;

    signal sclk_int  : std_logic := '0';
    signal clk_div   : integer range 0 to 3 := 0; -- Adjust for slower SCLK
begin

    -- SCLK generation (divide sys clk by 4)
    process(clk, reset)
    begin
        if reset = '1' then
            clk_div <= 0;
            sclk_int <= '0';
        elsif rising_edge(clk) then
            if state = SHIFT then
                clk_div <= clk_div + 1;
                if clk_div = 3 then
                    clk_div <= 0;
                    sclk_int <= not sclk_int;
                end if;
            else
                sclk_int <= '0';
            end if;
        end if;
    end process;
    sclk <= sclk_int;

    -- SPI transmission state machine
    process(clk, reset)
    begin
        if reset = '1' then
            state <= IDLE;
            cs <= '1';
            done <= '0';
            mosi <= '0';
        elsif rising_edge(clk) then
            case state is
                when IDLE =>
                    done <= '0';
                    cs <= '1';
                    if start = '1' then
                        state <= LOAD;
                    end if;

                when LOAD =>
                    cs <= '0';
                    shift_reg <= digital_in;
                    bit_cnt <= 7;
                    state <= SHIFT;

                when SHIFT =>
                    if clk_div = 0 and sclk_int = '0' then
                        -- Shift on falling edge
                        mosi <= shift_reg(bit_cnt);
                    elsif clk_div = 0 and sclk_int = '1' then
                        -- Decrement bit count after rising edge
                        if bit_cnt = 0 then
                            state <= FINISH;
                        else
                            bit_cnt <= bit_cnt - 1;
                        end if;
                    end if;

                when FINISH =>
                    cs <= '1';
                    done <= '1';
                    state <= IDLE;

                when others =>
                    state <= IDLE;
            end case;
        end if;
    end process;

end Behavioral;


	
