library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
use work.tank_batallion_defs.all;

entity TankBatallion_VGA_Top is
    port (
        i_reset      : in   std_logic;
        i_clock      : in  std_logic;   -- 125Mhz input clock from L16
        i_enable     : in  std_logic;
        i_switch_1   : in  std_logic;
        i_switch_2   : in  std_logic;
        o_led_drive  : out std_logic;
        clock_enable : out std_logic;
        led1         : out std_logic;
        led2         : out std_logic;
        VGAports     : out VGA_output_ports
    );
end TankBatallion_VGA_Top;

architecture Behavioral of TankBatallion_VGA_Top is


    signal VGA : VGA_output_ports ;
    signal VGA2 : VGA_output_ports ;
    signal clock_6, clock_32 : std_logic ;
    signal r,b : std_logic_vector (5 downto 0) ;


begin

    CLOCK_32MHZ : component clk_wiz_1
        port map (
            clk_out1 => clock_6,
            clk_out2 => clock_32,
            clk_in1  => i_clock
        );

    TankBat : component TankBatallion_top
        port map (
            i_reset     => i_reset,
            i_clock     => clock_6,
            i_clock32M  => clock_32 ,
            VGAports    => VGA
        );

    Scandoubler_mod : component scandoubler
        port map (
            clk_sys     => clock_32,
            hs_in       => VGA.h_sync,
            vs_in       => VGA.v_sync,
            r_in        => '0' & VGA.red,
            g_in        => VGA.green,
            b_in        => '0' & VGA.blue, 
            hs_out      => VGA2.h_sync, 
            vs_out      => VGA2.v_sync, 
            r_out       => r,    
            g_out       => VGA2.green,  
            b_out       => b    
        );

VGAports.h_sync     <= VGA2.h_sync    when i_switch_1 = '1' else VGA.h_sync; 
VGAports.v_sync     <= VGA2.v_sync    when i_switch_1 = '1' else VGA.v_sync; 
VGAports.red        <= r(4 downto 0)  when i_switch_1 = '1' else VGA.red;
VGAports.green      <= VGA2.green     when i_switch_1 = '1' else VGA.green;  
VGAports.blue       <= b(4 downto 0)  when i_switch_1 = '1' else VGA.blue;


end Behavioral;


