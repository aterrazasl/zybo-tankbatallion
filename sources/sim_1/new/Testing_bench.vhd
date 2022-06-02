
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;


entity Testing_bench is
    --  Port ( );
end Testing_bench;

architecture Behavioral of Testing_bench is

    use work.tank_batallion_defs.all; --.LS74161;

    signal clock, clock_32M : std_logic;
    signal data_count, data_count2 : std_logic_vector (7 downto 0);
    signal i_reset, i_enable, i_load :std_logic ;

    signal h256, compsync, vblank : std_logic ;

    signal VGA_out : VGA_output_ports;



begin

    ---- Clock Generation
    GENERATE_CLOCKCK: process
    begin
        wait for (ClockPeriod_6M / 2);
        clock <= '1';
        wait for (ClockPeriod_6M / 2);
        clock <= '0';
    end process;

    ---- Clock Generation
    GENERATE_CLOCK32M: process
    begin
        wait for (ClockPeriod_32M / 2);
        clock_32M <= '1';
        wait for (ClockPeriod_32M / 2);
        clock_32M <= '0';
    end process;

    RESET_PROCESS: process
    begin
        i_reset   <= '1';
        i_enable <= '1';
        wait for 1000 ns;
        i_reset <= '0';
        wait;
    end process;

    LOAD_PROCESS: process
    begin
        i_load<= '1';
        wait for 1800 ns;
        i_load<= '0';
        wait for 4 * (ClockPeriod_6M / 2);
        i_load<= '1';
        wait;
    end process;


    TANK_BAT : component TankBatallion_top
        port map(
            i_reset     => i_reset,
            i_clock     => clock,
            i_clock32M  => clock_32M,
            VGAports    => VGA_out,
            fixed_tile  => "000"
        );


end Behavioral;
