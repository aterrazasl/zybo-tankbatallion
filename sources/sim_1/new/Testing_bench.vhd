
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

    signal clock : std_logic;
    signal data_count, data_count2 : std_logic_vector (7 downto 0);
    signal i_reset, i_enable, i_load :std_logic ;

    signal h256, compsync, vblank : std_logic ;

begin

    ---- Clock Generation
    GENERATE_CLOCKCK: process
    begin
        wait for (ClockPeriod / 2);
        clock <= '1';
        wait for (ClockPeriod / 2);
        clock <= '0';
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
        wait for 4 * (ClockPeriod / 2);
        i_load<= '1';
        wait;
    end process;



    ---- Timing sync generation    ---- 

    timing: component TimingSync
        Port map (
            clk           => clock,
            clr_n         => not (i_reset),
            hsync         => h256,
            compsync      => compsync,
            vblank        => vblank,
            low_count     => data_count,
            high_count    => data_count2
        );



    TEST_ROM :block

        signal rom_addr : std_logic_vector (10 downto 0);
        signal rom_data : std_logic_vector (7 downto 0);
    begin

        ---- Testing binary_read
        ROM_TESTING: process
        begin
            wait for 1000 ns;
            wait until falling_edge (clock);
            rom_addr <= "000" & x"00";
            wait until falling_edge (clock);
            rom_addr <= "000" & x"08";
            wait until falling_edge (clock);
            rom_addr <= "000" & x"09";
            wait until falling_edge (clock);
            rom_addr <= "000" & x"0a";
            wait until falling_edge (clock);
            rom_addr <= "000" & x"0b";
            wait until falling_edge (clock);
            rom_addr <= "000" & x"0c";
            wait until falling_edge (clock);
            rom_addr <= "000" & x"0d";
            wait until falling_edge (clock);
            rom_addr <= "000" & x"0e";
            wait until falling_edge (clock);
            rom_addr <= "000" & x"0f";
            wait;
        end process;

        ROM2716 : component  M2716
            port map (
                clk    => clock,
                oe_n   => '0',
                ce_n => '0',
                addr   => rom_addr,
                data   => rom_data
            );
    end block TEST_ROM;



end Behavioral;
