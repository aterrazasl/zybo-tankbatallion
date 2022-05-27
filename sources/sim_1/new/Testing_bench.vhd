----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/24/2022 12:53:35 PM
-- Design Name: 
-- Module Name: Testing_bench - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Testing_bench is
    --  Port ( );
end Testing_bench;

architecture Behavioral of Testing_bench is


    use work.tank_batallion_defs.all; --.LS74161;
    
    signal clock : std_logic;
    signal data_count, data_count2 : std_logic_vector (7 downto 0);
    signal i_reset, i_enable, i_load :std_logic ;
    
    signal h256, compsync, vblank : std_logic ;

begin

    ---- Clock Generation
    GENERATE_CLOCKCK: process
    begin
        wait for (ClockPeriod / 2);
        clock <= '1';
        wait for (ClockPeriod / 2);
        clock <= '0';
    end process;

    RESET_PROCESS: process
    begin
        i_reset   <= '1';
        i_enable <= '1';
        wait for 1000 ns;
        i_reset <= '0';
        wait;
    end process;

    LOAD_PROCESS: process
    begin
        i_load<= '1';
        wait for 1800 ns;
        i_load<= '0';
        wait for 4 * (ClockPeriod / 2);
        i_load<= '1';
        wait;
    end process;



    ---- Timing sync generation    ---- 
    
    timing: component TimingSync
        Port map (
            clk           => clock,
            clr_n         => not (i_reset),
            hsync         => h256,
            compsync      => compsync,
            vblank        => vblank,
            low_count     => data_count,
            high_count    => data_count2
        );




end Behavioral;
