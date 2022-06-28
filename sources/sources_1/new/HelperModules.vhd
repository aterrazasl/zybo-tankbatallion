
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ResetGenerator is
    Port ( clock : in std_logic;
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
