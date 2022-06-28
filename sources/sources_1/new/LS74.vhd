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
begin

    process (clk, pr_n, clr_n )
    begin


        --        if (clr_n ='0') then
        --            q_temp <= '0';
        --        elsif (pr_n = '0') then
        --            q_temp <= '1';
        --        elsif (rising_edge (clk) ) then
        --            q_temp <= d;
        --        end if;

        if (pr_n = '0') then
            q  <= '1';
            q_n <='0';
        elsif (clr_n ='0') then
            q  <= '0';
            q_n <='1';
        elsif (rising_edge (clk) ) then
            q  <= d;
            q_n <=not(d);
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
        q       : out std_logic_vector(7 downto 0);
        enable  : in std_logic
    );
end LS74273;

architecture Behavioral of LS74273 is
begin

    process (clr_n, clk) is
    begin
        if clr_n = '0' then
            q <= x"00";
        elsif rising_edge(clk) then
            if enable = '1' then
                q <= d;
            end if;
        end if;
    end process;
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
        q       : out std_logic_vector(5 downto 0);
        enable  : in std_logic
    );
end LS74174;

architecture Behavioral of LS74174 is
    signal q_temp : std_logic_vector(5 downto 0);
begin


    process (clr_n, clk) is
    begin
        if clr_n = '0' then
            q <= "000000";
        elsif rising_edge(clk) then
            if enable = '0' then
                q <= d;
            end if;
        end if;
    end process;

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



--Implementation of 74LS42
--.
--.
--.
--.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity LS7442 is
    Port (
        din           :  in std_logic_vector(3 downto 0);
        dout          :  out std_logic_vector(9 downto 0)
    );
end LS7442;

architecture Behavioral of LS7442 is
begin
    with din select
 dout <= "1111111110" when "0000",
        "1111111101" when "0001",
        "1111111011" when "0010",
        "1111110111" when "0011",
        "1111101111" when "0100",
        "1111011111" when "0101",
        "1110111111" when "0110",
        "1101111111" when "0111",
        "1011111111" when "1000",
        "0111111111" when "1001",
        "1111111111" when others;

end Behavioral;






--Implementation of 74LS259
--.
--.
--.
--.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity LS74259 is
    Port (
        clr_n         : in std_logic ;
        d             : in std_logic ;
        we_n          : in std_logic ;
        add           :  in std_logic_vector(2 downto 0);
        dout          :  out std_logic_vector(7 downto 0)
    );
end LS74259;

architecture Behavioral of LS74259 is
    signal dtemp :   std_logic_vector(7 downto 0);
    signal q0,q1,q2,q3,q4,q5,q6,q7 : std_logic ;
begin

    dout <= q7 & q6 & q5 & q4 & q3 & q2 & q1 & q0;--  when clr_n ='0' else x"00";


    process (we_n, clr_n)
    begin
        if (clr_n = '0') then
            q0 <= '0';
            q1 <= '0';
            q2 <= '0';
            q3 <= '0';
            q4 <= '0';
            q5 <= '0';
            q6 <= '0';
            q7 <= '0';
        elsif (we_n ='0') then
            case add is
                when "000" =>
                    q0 <= d;
                when "001" =>
                    q1 <= d;
                when "010" =>
                    q2 <= d;
                when "011" =>
                    q3 <= d;
                when "100" =>
                    q4 <= d;
                when "101" =>
                    q5 <= d;
                when "110" =>
                    q6 <= d;
                when "111" =>
                    q7 <= d;
                when others =>
                    q0 <= q0;
                    q1 <= q1;
                    q2 <= q2;
                    q3 <= q3;
                    q4 <= q4;
                    q5 <= q5;
                    q6 <= q6;
                    q7 <= q7;
            end case;
        else
            q0 <= q0;
            q1 <= q1;
            q2 <= q2;
            q3 <= q3;
            q4 <= q4;
            q5 <= q5;
            q6 <= q6;
            q7 <= q7;

        end if;
    end process;

end Behavioral;





--Implementation of 74LS251
--.
--.
--.
--.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity LS74251 is
    Port (
        q             : out std_logic ;
        we_n          : in std_logic ;
        add           :  in std_logic_vector(2 downto 0);
        din           :  in std_logic_vector(7 downto 0)
    );
end LS74251;

architecture Behavioral of LS74251 is
    signal dtemp :   std_logic;
begin

    q <= dtemp when (we_n='0') else '0';

    with add select
 dtemp <= din(0) when "000",
        din(1) when "001",
        din(2) when "010",
        din(3) when "011",
        din(4) when "100",
        din(5) when "101",
        din(6) when "110",
        din(7) when "111",
        '0' when others;

end Behavioral;