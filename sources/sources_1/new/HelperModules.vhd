
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
    signal reset_count : std_logic_vector (15 downto 0) := "1111111111111111";

begin
    -- Generates reset foor 15 clock cycles  --  
    reset <= '0'  or reset_count(15);
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


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.tank_batallion_defs.all;

entity peripheral_control is
    Port (
        i_reset      : in  std_logic;
        A            : in  std_logic_vector(2 downto 0);
        controls     : in  Zybo_CONTROLS;
        dip_switch   : in  Zybo_DIP_SWITCH;
        per_map      : in  PERIPHERAL_MAP;
        nmi_n        : out std_logic;
        cpudata_in  : in std_logic;
        dipsw_q      : out std_logic;
        in1_q        : out std_logic;
        in0_q        : out std_logic
    );
end peripheral_control;

architecture Behavioral of peripheral_control is
    signal outputs1 :std_logic_vector (7 downto 0);
    signal i_reset_n : std_logic;
begin

    i_reset_n <= not(i_reset);

    LOGIC_OUTPUTS1: component  LS74259
        Port MAP(
            clr_n         => i_reset_n,
            d             => cpudata_in,
            we_n          => per_map.nOUT1,
            add           => A(2 downto 0),
            dout          => outputs1
        );
    nmi_n <= outputs1(7);


    DIPSW_INPUT : component LS74251
        Port map(
            q            => dipsw_q,
            we_n         => per_map.nDIPSW,
            add          => A(2 downto 0),
            din          => "11" & dip_switch.num_tanks &  dip_switch.bonus & dip_switch.game_fee & '1' --"11111001" -- x"01"
        );

    IN1_INPUT : component LS74251
        Port map(
            q            => in1_q ,
            we_n         => per_map.nIN1,
            add          => A(2 downto 0) ,
            din          => controls.test_switch & '1' & controls.player1_start & "11111"
        );
    IN0_INPUT : component LS74251
        Port map(
            q            => in0_q ,
            we_n         => per_map.nIN0,
            add          => A(2 downto 0),
            din          => '1' & '1' & controls.coin_switch & controls.shoot & controls.right & controls.down  & controls.left & controls.up
        );

end Behavioral;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.tank_batallion_defs.all;

entity address_decoder is
    Port (
        cpu_r_w         : in std_logic;
        A               : in std_logic_vector (15 downto 0);
        nROM            : in std_logic ;
        h2              : in std_logic;
        rom_addr_static : in std_logic_vector (11 downto 0);
        per_map         : out  PERIPHERAL_MAP
    );
end address_decoder;

architecture Behavioral of address_decoder is

    signal C4_6 , C3_2_y, E4_3, D4_1_y : std_logic ;
    signal ic74ls42_4f_dout : std_logic_vector (9 downto 0);
    signal nWO : std_logic ;
begin

    C3_2_y <= '0' when ((A(13)='0') and (cpu_r_w ='1')) else '1';
    E4_3   <= nROM nand h2;
    C4_6   <= E4_3 and C3_2_y;  --not(nROM)

    per_map.nWRAM <= '0' when (A(10)='0' and A(11) ='0' and C4_6 ='0') else
 '0' when (A(10)='1' and A(11) ='0' and C4_6 ='0') else
 '1';

    per_map.nVRAM <= '0' when (A(10)='0' and A(11) ='1' and C4_6 ='0') else
 '1';

    nWO           <= '0' when ((A(13)='0') and (cpu_r_w ='0')) else '1';
    per_map.nWO   <= '0' when ((A(13)='0') and (cpu_r_w ='0')) else '1';

    per_map.nWRAM0_VA <= '1' when (rom_addr_static(11 downto 4) = "00000000") else
 '0';
    per_map.nVRAM_VA  <= '1' when (rom_addr_static(11 downto 10) = "10")      else
 '0';


    D4_1_y <= '0' when (A(10)='1') and (A(11)='1' and C4_6 ='0') else
 '1';


    ic74ls42_4f :component LS7442
        Port map (
            din  => D4_1_y & nWO & A(4) & A(3),
            dout => ic74ls42_4f_dout
        );


    per_map.F4_o9   <= ic74ls42_4f_dout(9);
    per_map.F4_o8   <= ic74ls42_4f_dout(8);
    per_map.nDIPSW  <= ic74ls42_4f_dout(7);
    per_map.F4_o6   <= ic74ls42_4f_dout(6);
    per_map.nIN1    <= ic74ls42_4f_dout(5);
    per_map.nIN0    <= ic74ls42_4f_dout(4);
    per_map.nWDR    <= ic74ls42_4f_dout(3);
    per_map.nINTACK <= ic74ls42_4f_dout(2);-- nand not( not(A(0)) and not(A(1)) and not(A(2)));
    per_map.nOUT1   <= ic74ls42_4f_dout(1);
    per_map.nOUT0   <= ic74ls42_4f_dout(0);


end Behavioral;





--library IEEE;
--use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;
--use work.tank_batallion_defs.all;

--entity peripheral_control is
--    Port (

--    );
--end peripheral_control;

--architecture Behavioral of peripheral_control is

--begin


--end Behavioral;