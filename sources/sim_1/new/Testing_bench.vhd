
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
            fixed_tile  => x"CE" 
        );



--    TEST_TIMINGSYNC :block
--        ---- Timing sync generation    ---- 
--    begin
--        timing: component TimingSync
--            Port map (
--                clk           => clock,
--                clr_n         => not (i_reset),
--                hsync         => h256,
--                compsync      => compsync,
--                vblank        => vblank,
--                low_count     => data_count,
--                high_count    => data_count2
--            );
--    end block TEST_TIMINGSYNC;


--    TEST_ROM :block

--        signal rom_addr : std_logic_vector (10 downto 0);
--        signal rom_data : std_logic_vector (7 downto 0);
--        signal rom_data2 : std_logic_vector (3 downto 0);
--    begin

--        ---- Testing binary_read
--        ROM_TESTING: process
--        begin
--            wait for 1000 ns;
--            wait until falling_edge (clock);
--            rom_addr <= "000" & x"00";
--            wait until falling_edge (clock);
--            rom_addr <= "000" & x"08";
--            wait until falling_edge (clock);
--            rom_addr <= "000" & x"09";
--            wait until falling_edge (clock);
--            rom_addr <= "000" & x"0a";
--            wait until falling_edge (clock);
--            rom_addr <= "000" & x"0b";
--            wait until falling_edge (clock);
--            rom_addr <= "000" & x"0c";
--            wait until falling_edge (clock);
--            rom_addr <= "000" & x"0d";
--            wait until falling_edge (clock);
--            rom_addr <= "000" & x"0e";
--            wait until falling_edge (clock);
--            rom_addr <= "000" & x"0f";
--            wait;
--        end process;

--        ROM2716 : component  M2716
--            port map (
--                clk    => clock,
--                oe_n   => '0',
--                ce_n => '0',
--                addr   => rom_addr,
--                data   => rom_data
--            );

--        ROM7052 : component  IC7052
--            port map (
--                clk    => clock,
--                oe_n   => '0',
--                ce_n => '0',
--                addr   => rom_addr(7 downto 0),
--                data   => rom_data2
--            );


--    end block TEST_ROM;

--    TEST_DECODER :block

--        signal  oe_n   : std_logic;
--        signal  sel    : std_logic_vector(1 downto 0);
--        signal  y0     : std_logic;
--        signal  y1     : std_logic;
--        signal  y2     : std_logic;
--        signal  y3     : std_logic;

--    begin

--        ---- Testing binary_read
--        DECODER_TESTING: process
--        begin
--            wait for 1000 ns;
--            oe_n <= '1';
--            wait until falling_edge (clock);
--            oe_n <= '0';
--            sel <= "00";
--            wait until falling_edge (clock);
--            sel <= "01";
--            wait until falling_edge (clock);
--            sel <= "10";
--            wait until falling_edge (clock);
--            sel <= "11";
--            wait until falling_edge (clock);
--            sel <= "00";

--            wait;
--        end process;

--        LS74139_module : component  LS74139
--            port map (
--                oe_n  =>oe_n,
--                sel   =>sel,
--                y0    => y0,
--                y1    => y1,
--                y2    => y2,
--                y3    => y3
--            );
--    end block TEST_DECODER;


--    TEST_SHIFTER :block

--        signal  shift_load, qh   : std_logic;
--        signal  d    : std_logic_vector(7 downto 0);

--    begin

--        ---- Testing binary_read
--        SHIFTER_TESTING: process
--        begin
--            wait for 1000 ns;
--            d <= x"AD";
--            wait until falling_edge (clock);
--            shift_load <= '0';
--            wait until falling_edge (clock);
--            shift_load <= '1';
--            wait;
--        end process;

--        LS74166_module : component  LS74166
--            Port map (
--                clr_n           => not (i_reset),
--                clk             => clock,
--                clk_dis         => '0',
--                serial          => '0',
--                shift_load      => shift_load,
--                d               => d,
--                qh              => qh
--            );
--    end block TEST_SHIFTER;





end Behavioral;
