
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ResetGenerator is
    Port (
        clock : in std_logic;
        reset : out std_logic
    );
end ResetGenerator;

architecture Behavioral of ResetGenerator is
    signal reset_gen : std_logic ;
    signal reset_count : std_logic_vector (15 downto 0) := "1111111111111111";

begin
    -- Generates reset foor 15 clock cycles  --  
    reset_gen <= '0'  or reset_count(15);
    process (clock )
    begin
        if (rising_edge (clock) ) then
            reset_count <= reset_count(14 downto 0) & '0';
        end if;
    end process;

end Behavioral;



library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.tank_batallion_defs.all;

entity signal_inverter is
    Port (
        controls       : in   Zybo_CONTROLS;
        dip_switch     : in   Zybo_DIP_SWITCH;
        controls_n     : out  Zybo_CONTROLS;
        dip_switch_n   : out  Zybo_DIP_SWITCH
    );
end signal_inverter;

architecture Behavioral of signal_inverter is

begin


    controls_n.up   	       <= not(controls.up);
    controls_n.left	           <= not(controls.left);
    controls_n.down            <= not(controls.down);
    controls_n.right           <= not(controls.right);
    controls_n.shoot           <= not(controls.shoot);
    controls_n.player1_start   <= not(controls.player1_start);
    controls_n.coin_switch     <= not(controls.coin_switch);
    controls_n.test_switch     <= not(controls.test_switch);

    dip_switch_n.num_tanks     <= not(dip_switch.num_tanks);
    dip_switch_n.bonus		   <= not(dip_switch.bonus	  );
    dip_switch_n.game_fee      <= not(dip_switch.game_fee );

end Behavioral;