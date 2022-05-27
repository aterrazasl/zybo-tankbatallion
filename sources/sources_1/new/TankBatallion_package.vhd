library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Package Declaration Section
package tank_batallion_defs is

    constant ClockPeriod : TIME := 166.66666666 ns; --333 ns;

    type VGA_output_ports is record
        h_sync			: std_logic;
        v_sync			: std_logic;
        red             : std_logic_vector (4 downto 0);
        green           : std_logic_vector (5 downto 0);
        blue            : std_logic_vector (4 downto 0);
        --clock25Mhz      : std_logic;
    end record;

    component LS74161
        port (
            clr_n         : in std_logic;
            load_n        : in std_logic;
            clk           : in std_logic;
            enp         : in std_logic;
            ent        : in std_logic;
            data_input    : in std_logic_vector (7 downto 0);
            data_output   : out std_logic_vector (7 downto 0);
            rco         : out std_logic
        );
    end component LS74161;


    component LS7474 is
        Port (
            clr_n   : in std_logic;
            pr_n    : in std_logic;
            clk     : in std_logic;
            d       : in std_logic;
            q       : out std_logic;
            q_n     : out std_logic
        );
    end component LS7474;


    component LS74273 is
        Port (
            clr_n   : in std_logic;
            clk     : in std_logic;
            d       : in std_logic_vector(7 downto 0);
            q       : out std_logic_vector(7 downto 0)
        );
    end component LS74273;


    component LS74174 is
        Port (
            clr_n   : in std_logic;
            clk     : in std_logic;
            d       : in std_logic_vector(5 downto 0);
            q       : out std_logic_vector(5 downto 0)
        );
    end component LS74174;


    component LS74139 is
        Port (
            oe_n   : in std_logic;
            sel    : in std_logic_vector(1 downto 0);
            y0     : out std_logic;
            y1     : out std_logic;
            y2     : out std_logic;
            y3     : out std_logic
        );
    end component LS74139;


    component LS74166 is
        Port (
            clr_n           : in std_logic;
            clk             : in std_logic;
            clk_dis          : in std_logic;
            serial          : in std_logic;
            shift_load      : in std_logic;
            d               : in std_logic_vector(7 downto 0);
            qh              : out std_logic
        );
    end component LS74166;

    component  M2716 is
        port(
            clk  : in  std_logic;
            oe_n   : in  std_logic;
            ce_n   : in  std_logic;
            addr : in  std_logic_vector(10 downto 0);
            data : out std_logic_vector(7 downto 0)
        );
    end component M2716;

    component IC7052 is
        port(
            clk  : in  std_logic;
            oe_n   : in  std_logic;
            ce_n   : in  std_logic;
            addr : in  std_logic_vector(7 downto 0);
            data : out std_logic_vector(3 downto 0)
        );
    end component IC7052;


    component TimingSync is
        Port (
            clk       : in std_logic;
            clr_n     : in std_logic;
            hsync     : out std_logic;
            vsync     : out std_logic;
            compsync  : out std_logic;
            vblank    : out std_logic;
            low_count : out std_logic_vector (7 downto 0);
            high_count: out std_logic_vector (7 downto 0)
        );
    end component TimingSync;


    component TankBatallion_top is
        port (
            i_reset      : in   std_logic;
            i_clock      : in  std_logic;   -- 125Mhz input clock from L16
            VGAports     : out VGA_output_ports
        );
    end component TankBatallion_top;

    -- Clock generation for 32Mhz scandoubler and 6Mhz for TankBatallion 
    component clk_wiz_1
        port (
            clk_out1 : out std_logic;
            clk_out2 : out std_logic;
            clk_in1  : in  std_logic
        );
    end component clk_wiz_1;


    --    component clk_wiz_0
    --        port (
    --            clk_out1 : out std_logic;
    --            clk_in1  : in  std_logic
    --        );
    --    end component clk_wiz_0;    

    component scandoubler
        port (
            clk_sys   : in std_logic ;
            hs_in     : in std_logic ;
            vs_in     : in std_logic ;
            r_in      : in std_logic_vector (5 downto 0);
            g_in      : in std_logic_vector (5 downto 0);
            b_in      : in std_logic_vector (5 downto 0);
            hs_out    : out std_logic ;
            vs_out    : out std_logic ;
            r_out     : out std_logic_vector (5 downto 0);
            g_out     : out std_logic_vector (5 downto 0);
            b_out     : out std_logic_vector (5 downto 0)
        );
    end component scandoubler;

end package tank_batallion_defs;













