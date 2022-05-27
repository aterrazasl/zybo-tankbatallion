library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
use work.tank_batallion_defs.all;


entity TankBatallion_top is
    port (
        i_reset      : in   std_logic;
        i_clock      : in  std_logic;   -- 125Mhz input clock from L16
        VGAports     : out VGA_output_ports
    );
end TankBatallion_top;

architecture Behavioral of TankBatallion_top is

    use work.tank_batallion_defs.all;

    signal clock : std_logic;
    signal data_count, data_count2 : std_logic_vector (7 downto 0);

    signal h256, compsync, vblank : std_logic ;

    signal red, green, blue : std_logic ;



begin


clock <= i_clock ;
--    CLOCK_6MHZ : clk_wiz_0
--        port map (
--            clk_out1 => clock,
--            clk_in1  => i_clock
--        );


    ---- Timing sync generation    ---- 

    TimingSync_Module: component TimingSync
        Port map (
            clk           => clock,
            clr_n         => not (i_reset),
            hsync         => h256,
            vsync         => vblank, 
            compsync      => compsync,
            vblank        => open,
            low_count     => data_count,
            high_count    => data_count2
        );

    VGAports.h_sync  <= h256;
    VGAports.v_sync  <= vblank;
    
    red      <= data_count(3) and data_count2(3) and (data_count(7)) and vblank ;
    green    <= data_count(2) and data_count2(2) and (data_count(7)) and vblank ;
    blue     <= data_count(4) and data_count2(4) and (data_count(7)) and vblank ;
    VGAports.red    <= red & red & red & red & red;
    VGAports.green  <= green & green & green & green & green & green;
    VGAports.blue   <= blue & blue & blue  & blue  & blue;

end Behavioral;
