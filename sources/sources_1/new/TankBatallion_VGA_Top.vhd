
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.tank_batallion_defs.all;

entity TankBatallion_VGA_Top is
    port (
        i_left       : in  std_logic;
        i_right      : in  std_logic;
        i_up         : in  std_logic;
        i_down       : in  std_logic;
        i_clock      : in  std_logic;   -- 125Mhz input clock from L16
        i_switch_0   : in  std_logic;
        i_switch_1   : in  std_logic;
        i_switch_2   : in  std_logic;
        i_switch_3   : in  std_logic ;
        VGAports     : out Zybo_VGA_output_ports
    );
end TankBatallion_VGA_Top;

architecture Behavioral of TankBatallion_VGA_Top is

    signal VGA_TB, VGA_SD : VGA_output_ports ;
    signal clock_6, clock_32, reset_gen : std_logic ;
    signal reset_count : std_logic_vector (15 downto 0) := "1111111111111111";
    signal enable_scandoubler : std_logic := '1';   -- 1 enables scandoubler, 0 uses the signals from the tank batallion game --

begin

    -- Clock generation 6Mhz and arlet_6502--
    -- 6Mhz is used in the tank batallion and 32Mhz for scandoubler --
    CLOCK_32MHZ : component clk_wiz_1
        port map (
            clk_out1 => clock_6,
            clk_out2 => clock_32,
            clk_in1  => i_clock
        );

    -- Generates reset foor 15 clock cycles  --  
    reset_gen <= '0'  or reset_count(15);
    process (clock_6 )
    begin
        if (rising_edge (clock_6) ) then
            reset_count <= reset_count(14 downto 0) & '0';
        end if;
    end process;


    -- Tank Batallion game core --
    TankBat : component TankBatallion_top
        port map (
            i_reset     => reset_gen,
            i_clock     => clock_6,
            i_clock32M  => clock_32 ,
            VGAports    => VGA_TB,
            pl_start    => not(i_switch_0),
            coin_sw1    => not(i_switch_1),
            test_sw     => not(i_switch_3),
            serv_sw     => '1',
            i_up        => not(i_up),
            i_down      => not(i_down),
            i_left      => not(i_left),
            i_right     => not(i_right),
            i_shoot     => not(i_switch_2)
        );

    -- Scandoubler generates signals for VGA --
    Scandoubler_mod : component scandoubler
        port map (
            clk_sys     => clock_32,
            hs_in       => VGA_TB.h_sync,
            vs_in       => VGA_TB.v_sync,
            r_in        => VGA_TB.red,
            g_in        => VGA_TB.green,
            b_in        => VGA_TB.blue,
            hs_out      => VGA_SD.h_sync,
            vs_out      => VGA_SD.v_sync,
            r_out       => VGA_SD.red,
            g_out       => VGA_SD.green,
            b_out       => VGA_SD.blue
        );


    -- Maps VGA ports for red and blue only 5 bits for Zybo board --
    -- Also maps VGA signals from Tankbatallion game or scandoubler --  
    VGAports.h_sync     <= VGA_SD.h_sync            when enable_scandoubler = '1' else VGA_TB.h_sync;
    VGAports.v_sync     <= VGA_SD.v_sync            when enable_scandoubler = '1' else VGA_TB.v_sync;
    VGAports.green      <= VGA_SD.green             when enable_scandoubler = '1' else VGA_TB.green;
    VGAports.red        <= VGA_SD.red (4 downto 0)  when enable_scandoubler = '1' else VGA_TB.red(4 downto 0);
    VGAports.blue       <= VGA_SD.blue(4 downto 0)  when enable_scandoubler = '1' else VGA_TB.blue(4 downto 0);

end Behavioral;


