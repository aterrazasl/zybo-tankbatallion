
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.tank_batallion_defs.all;

entity TankBatallion_VGA_Top is
    port (
        i_clock      : in  std_logic;   -- 125Mhz input clock from L16
        controls_SW  : in  Zybo_CONTROLS;
        VGAports     : out Zybo_VGA_output_ports
    );
end TankBatallion_VGA_Top;

architecture Behavioral of TankBatallion_VGA_Top is
    
    signal VGA_TB, VGA_SD : VGA_output_ports ;
    signal controls_SW_n : Zybo_CONTROLS;
    signal dip_SW, dip_SW_n : Zybo_DIP_SWITCH;
    signal clock_6, clock_32, reset_gen : std_logic ;
    signal enable_scandoubler : std_logic := '1';   -- 1 enables scandoubler, 0 uses the signals from the tank batallion game --

begin

    -- dip switches default values --
    dip_SW.num_tanks <= '0';
    dip_SW.bonus	 <= "00";
    dip_SW.game_fee  <= "00";

    -- Clock generation 6Mhz and arlet_6502--
    -- 6Mhz is used in the tank batallion and 32Mhz for scandoubler --
    CLOCK_32MHZ : component clk_wiz_1
        port map (
            clk_out1 => clock_6,
            clk_out2 => clock_32,
            clk_in1  => i_clock
        );

    -- Generates reset foor 15 clock cycles  --  
    RESET_GENERATOR : component ResetGenerator
        Port map(
            clock  => clock_6,
            reset => reset_gen
        );

    INPUT_INVERTER : component signal_inverter
        Port map(
            controls        => controls_SW,
            dip_switch      => dip_SW,
            controls_n      => controls_SW_n,
            dip_switch_n    => dip_SW_n
        );

    -- Tank Batallion game core --
    TankBat : component TankBatallion_top
        port map (
            i_reset     => reset_gen,
            i_clock     => clock_6,
            i_clock32M  => clock_32 ,
            VGAports    => VGA_TB,
            controls    => controls_SW_n,
            dip_switch  => dip_SW_n
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


