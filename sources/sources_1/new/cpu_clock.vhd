library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

entity cpu_clock is
    Port (
        clk         : in std_logic;
        rst_n       : in std_logic ;
        Phi2        : in std_logic ;
        cpu_clken   : out std_logic
    );
end cpu_clock;

architecture Behavioral of cpu_clock is

    use work.tank_batallion_defs.all; --.LS74161;
    signal ff1_out, int1 : std_logic ;
begin



    icLS74 : component LS7474
        Port map(
            clr_n   => rst_n,
            pr_n    => '1',
            clk     => clk,
            d       => Phi2,
            q       => ff1_out,
            q_n     => open
        );

     int1 <= (Phi2 xor ff1_out);
     cpu_clken <= (Phi2 and int1);


end Behavioral;
