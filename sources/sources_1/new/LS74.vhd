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

    --    process (clk, clr_n )
    --    begin
    --        if (clr_n  ='0') then
    --            q_temp <= x"00";
    --        elsif  (rising_edge (clk) ) then
    --            if clk = '1' then
    --                q <= d;
    --                q_temp <= d;
    --            end if;

    --            q <= q_temp;
    --        end if;
    --    end process;


end Behavioral;






--Implementation of 74LS174
--.
--.
--.
--.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity LS74174 is
    Port (
        clr_n   : in std_logic;
        clk     : in std_logic;
        d       : in std_logic_vector(5 downto 0);
        q       : out std_logic_vector(5 downto 0)
    );
end LS74174;

architecture Behavioral of LS74174 is
    signal q_temp : std_logic_vector(5 downto 0);
begin

    --q   <=     q_temp2(7 downto 2);

    process (clk )
    begin
        if  (rising_edge (clk) ) then
            if clk = '1' then
                q <= d;
                q_temp <= d;
            else
                q <= q_temp;
            end if;

            q <= q_temp;
        end if;
    end process;



    --        process (clk, clr_n )
    --    begin
    --        if (clr_n  ='0') then
    --            q_temp <= "000000";
    --        elsif  (rising_edge (clk) ) then
    --            if clk = '1' then
    --                q <= d;
    --                q_temp <= d;
    --            end if;

    --            q <= q_temp;
    --        end if;
    --    end process;

end Behavioral;


--Implementation of 74LS139
--.
--.
--.
--.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity LS74139 is
    Port (
        oe_n   : in std_logic;
        sel    : in std_logic_vector(1 downto 0);
        y0     : out std_logic;
        y1     : out std_logic;
        y2     : out std_logic;
        y3     : out std_logic
    );
end LS74139;

architecture Behavioral of LS74139 is
    signal temp : std_logic_vector (3 downto 0);
begin

    y0 <= temp(0) when oe_n='0' else '1';
    y1 <= temp(1) when oe_n='0' else '1';
    y2 <= temp(2) when oe_n='0' else '1';
    y3 <= temp(3) when oe_n='0' else '1';


    with sel select
 temp <= "1101" when "01",
        "1011" when "10",
        "0111" when "11",
        "1110" when others;

end Behavioral;



--Implementation of 74LS166
--.
--.
--.
--.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity LS74166 is
    Port (
        clr_n           : in std_logic;
        clk             : in std_logic;
        clk_dis          : in std_logic;
        serial          : in std_logic;
        shift_load      : in std_logic;
        d               : in std_logic_vector(7 downto 0);
        qh              : out std_logic
    );
end LS74166;

architecture Behavioral of LS74166 is
    signal q_temp : std_logic_vector(7 downto 0);
begin

    qh   <=     q_temp(7);

    process (clk,clr_n, shift_load )
    begin
        if (clr_n ='0') then
            q_temp <= x"00";
        elsif (rising_edge (clk) ) then

            if(clk_dis ='0' and shift_load ='0') then
                q_temp <= d;
            elsif (clk_dis ='0' and shift_load ='1') then
                q_temp <= q_temp (6 downto 0) & serial;
            else
                q_temp <= q_temp;

            end if;
        end if;
    end process;
end Behavioral;





--Implementation of 74LS157
--.
--.
--.
--.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity LS74157 is
    Port (
        sel          :  in std_logic;
        en_n         :  in std_logic;
        d0           :  in std_logic_vector(3 downto 0);
        d1           :  in std_logic_vector(3 downto 0);
        z            : out std_logic_vector(3 downto 0)
    );
end LS74157;

architecture Behavioral of LS74157 is
    signal q_temp : std_logic_vector(3 downto 0);
begin

    q_temp    <= d0     when  sel = '0' else d1;

    z         <= q_temp when en_n = '0' else "0000";

end Behavioral;



