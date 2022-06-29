-- Single-Port Block RAM Read-First Mode
-- rams_sp_rf.vhd
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MB8125 is
 port(
  clk  : in  std_logic;
  we   : in  std_logic;
  en   : in  std_logic;
  addr : in  std_logic_vector(9 downto 0);
  di   : in  std_logic;
  do   : out std_logic
 );
end MB8125;

architecture syn of MB8125 is
 type ram_type is array (1023 downto 0) of std_logic;
 signal RAM : ram_type;
begin
 process(clk)
 begin
  if clk'event and clk = '1' then
   if en = '0' then
    if we = '0' then
     RAM(to_integer(unsigned(addr))) <= di;
    end if;
    do <= RAM(to_integer(unsigned(addr)));
   end if;
  end if;
 end process;

end syn;
