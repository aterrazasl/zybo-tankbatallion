--Implementation of 74LS161
--.
--.
--.
--.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity LS74161 is
    Port (
        clr_n         : in std_logic;
        load_n        : in std_logic;
        clk           : in std_logic;
        enp           : in std_logic; -- count enable
        ent           : in std_logic;  -- Carry enable
        data_input    : in std_logic_vector (7 downto 0);
        data_output   : out std_logic_vector (7 downto 0);
        rco           : out std_logic
    );
end LS74161;

architecture Behavioral of LS74161 is

    signal count : unsigned (7 downto 0);

begin

    data_output <= std_logic_vector (count);
    rco <= '1' when (count = (to_unsigned(255, count'length) ) and (ent = '1')) else '0';

    process (clk,clr_n)
    begin
        if (clr_n ='0') then
            count <= to_unsigned(0, count'length);
        elsif (rising_edge (clk) ) then
            if enp='1' then
                if load_n='0' then
                    count <= unsigned(data_input);
                else
                    count <= count + to_unsigned(1, count'length);
                end if;
            end if;
        end if;
    end process;
end Behavioral;


--Implementation of 74LS74
--.
--.
--.
--.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity LS7474 is
    Port (
        clr_n   : in std_logic;
        pr_n    : in std_logic;
        clk     : in std_logic;
        d       : in std_logic;
        q       : out std_logic;
        q_n     : out std_logic
    );
end LS7474;

architecture Behavioral of LS7474 is
    signal q_temp : std_logic;
begin

    q   <=     q_temp;
    q_n <= not(q_temp);

    process (clk,clr_n, pr_n )
    begin
        if (clr_n ='0') then
            q_temp <= '0';
        elsif (pr_n = '0') then
            q_temp <= '1';
        elsif (rising_edge (clk) ) then
            q_temp <= d;
        end if;
    end process;
end Behavioral;



--Implementation of 74LS273
--.
--.
--.
--.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity LS74273 is
    Port (
        clr_n   : in std_logic;
        clk     : in std_logic;
        d       : in std_logic_vector(7 downto 0);
        q       : out std_logic_vector(7 downto 0)
    );
end LS74273;

architecture Behavioral of LS74273 is
    signal q_temp : std_logic_vector(7 downto 0);
begin

    q   <=     q_temp;

    process (clk,clr_n )
    begin
        if (clr_n ='0') then
            q_temp <= x"00";
        elsif (rising_edge (clk) ) then
            q_temp <= d;
        end if;
    end process;
end Behavioral;











