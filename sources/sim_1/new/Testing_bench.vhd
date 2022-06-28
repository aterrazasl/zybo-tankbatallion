
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity Testing_bench is
    --  Port ( );
end Testing_bench;

architecture Behavioral of Testing_bench is

    use work.tank_batallion_defs.all; 

    signal clock, clock_32M, i_reset : std_logic;
    signal VGA_out : VGA_output_ports;

begin

    ---- Clock Generation
    GENERATE_CLOCK6M: process
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
        wait for 1000 ns;
        i_reset <= '0';
        wait;
    end process;


    TANK_BAT : component TankBatallion_top
        port map(
            i_reset     => i_reset,
            i_clock     => clock,
            i_clock32M  => clock_32M,
            VGAports    => VGA_out,
            pl_start    => '1',
            coin_sw1    => '1',
            test_sw     => '1',
            serv_sw     => '1',
            i_up        => '1',
            i_down      => '1',
            i_left      => '1',
            i_right     => '1',
            i_shoot     => '1'
        );


end Behavioral;
