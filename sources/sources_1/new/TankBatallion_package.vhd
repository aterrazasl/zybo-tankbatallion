library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Package Declaration Section
package tank_batallion_defs is

    constant ClockPeriod_3M  : TIME := 333 ns;
    constant ClockPeriod_6M  : TIME := 166.66666666 ns; --333 ns;
    constant ClockPeriod_32M : TIME := 31.25 ns;

    type VGA_output_ports is record
        h_sync			: std_logic;
        v_sync			: std_logic;
        red             : std_logic_vector (5 downto 0);
        green           : std_logic_vector (5 downto 0);
        blue            : std_logic_vector (5 downto 0);
    end record;

    -- Type used in the top VHDL from Zybo board, difference is that blue and red uses 5 bits insted of 6 like in green -- 
    type Zybo_VGA_output_ports is record
        h_sync			: std_logic;
        v_sync			: std_logic;
        red             : std_logic_vector (4 downto 0);
        green           : std_logic_vector (5 downto 0);
        blue            : std_logic_vector (4 downto 0);
    end record;

    type Zybo_DIP_SWITCH is record
        num_tanks   	: std_logic;
        bonus			: std_logic_vector (1 downto 0);
        game_fee        : std_logic_vector (1 downto 0);
    end record;

    type Zybo_CONTROLS is record
        up   	        : std_logic;
        left	        : std_logic;
        down            : std_logic;
        right           : std_logic;
        shoot           : std_logic;
        player1_start   : std_logic;
        coin_switch     : std_logic;
        test_switch     : std_logic;
    end record;

    type PERIPHERAL_MAP is record
        nWO       : std_logic;
        nWRAM0_VA : std_logic;
        nVRAM_VA  : std_logic;
        nVRAM     : std_logic;
        nWRAM	  : std_logic;
        nDIPSW    : std_logic;
        nIN0      : std_logic;
        nIN1      : std_logic;
        nOUT0     : std_logic;
        nOUT1     : std_logic;
        nWDR      : std_logic;
        nINTACK   : std_logic;
        F4_o9     : std_logic; -- not used
        F4_o8     : std_logic; -- not used
        F4_o6     : std_logic; -- not used
    end record;

    component ResetGenerator is
        Port (
            clock : in std_logic;
            reset : out std_logic
        );
    end component ResetGenerator;

    component signal_inverter is
        Port (
            controls       : in   Zybo_CONTROLS;
            dip_switch     : in   Zybo_DIP_SWITCH;
            controls_n     : out  Zybo_CONTROLS;
            dip_switch_n   : out  Zybo_DIP_SWITCH
        );
    end component signal_inverter;

    component peripheral_control is
        Port (
            i_reset      : in  std_logic;
            A            : in  std_logic_vector(2 downto 0);
            controls     : in  Zybo_CONTROLS;
            dip_switch   : in  Zybo_DIP_SWITCH;
            per_map      : in  PERIPHERAL_MAP;
            nmi_n        : out std_logic;
            cpudata_in   : in std_logic;
            dipsw_q      : out std_logic;
            in1_q        : out std_logic;
            in0_q        : out std_logic
        );
    end component peripheral_control;

    component address_decoder is
        Port (
            cpu_r_w         : in std_logic;
            A               : in std_logic_vector (15 downto 0);
            nROM            : in std_logic ;
            h2              : in std_logic;
            rom_addr_static : in std_logic_vector (11 downto 0);
            per_map         : out  PERIPHERAL_MAP
        );
    end component address_decoder;

    component LS74161
        port (
            clr_n         : in std_logic;
            load_n        : in std_logic;
            clk           : in std_logic;
            enp           : in std_logic;
            ent           : in std_logic;
            data_input    : in std_logic_vector (7 downto 0);
            data_output   : out std_logic_vector (7 downto 0);
            rco           : out std_logic
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
            q       : out std_logic_vector(7 downto 0);
            enable  : in std_logic
        );
    end component LS74273;

    component LS74174 is
        Port (
            clr_n   : in std_logic;
            clk     : in std_logic;
            d       : in std_logic_vector(5 downto 0);
            q       : out std_logic_vector(5 downto 0);
            enable  : in std_logic
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

    component  LS74157 is
        Port (
            sel          :  in std_logic;
            en_n         :  in std_logic;
            d0           :  in std_logic_vector(3 downto 0);
            d1           :  in std_logic_vector(3 downto 0);
            z            : out std_logic_vector(3 downto 0)
        );
    end component LS74157;

    component LS7442 is
        Port (
            din           :  in std_logic_vector(3 downto 0);
            dout          :  out std_logic_vector(9 downto 0)
        );
    end component LS7442;

    component  M2716 is
        port(
            clk    : in  std_logic;
            oe_n   : in  std_logic;
            ce_n   : in  std_logic;
            addr   : in  std_logic_vector(10 downto 0);
            data   : out std_logic_vector(7 downto 0)
        );
    end component M2716;

    component  M2716_static_frame is
        port(
            clk    : in  std_logic;
            oe_n   : in  std_logic;
            ce_n   : in  std_logic;
            addr   : in  std_logic_vector(10 downto 0);
            data   : out std_logic_vector(7 downto 0)
        );
    end component  M2716_static_frame;

    component IC7052 is
        port(
            clk    : in  std_logic;
            oe_n   : in  std_logic;
            ce_n   : in  std_logic;
            addr   : in  std_logic_vector(7 downto 0);
            data   : out std_logic_vector(3 downto 0)
        );
    end component IC7052;

    component TimingSync is
        Port (
            clk           : in std_logic;
            clr_n         : in std_logic;
            hsync         : out std_logic;
            vsync         : out std_logic;
            compsync      : out std_logic;
            vblank        : out std_logic;
            h1_out        : out std_logic;
            v1_out        : out std_logic;
            h256_out      : out std_logic;
            h256_ast_out  : out std_logic;
            low_count     : out std_logic_vector (7 downto 0);
            high_count    : out std_logic_vector (7 downto 0);
            nIRQ          : out std_logic;
            nINTACK       : in std_logic;
            v_out         : out std_logic_vector (8 downto 0);
            h_out         : out std_logic_vector (8 downto 0)
        );
    end component TimingSync;

    component TankBatallion_top is
        port (
            i_reset      : in   std_logic;
            i_clock      : in   std_logic;   -- 6Mhz input clock required
            i_clock32M   : in   std_logic;
            VGAports     : out  VGA_output_ports;
            controls     : in   Zybo_CONTROLS;
            dip_switch   : in   Zybo_DIP_SWITCH
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

    component cpu_clock is
        Port (
            clk         : in std_logic;
            rst_n       : in std_logic ;
            Phi2        : in std_logic ;
            cpu_clken   : out std_logic
        );
    end component cpu_clock;

    component arlet_6502
        port (
            clk             : in std_logic ;
            enable          : in std_logic ;
            rst_n           : in std_logic ;
            ab              : out std_logic_vector (15 downto 0);
            dbi             : in std_logic_vector (7 downto 0);
            dbo             : out std_logic_vector (7 downto 0);
            we              : out std_logic;
            irq_n           : in std_logic ;
            nmi_n           : in std_logic ;
            ready           : in std_logic ;
            pc_monitor      : out std_logic_vector (15 downto 0)
        );
    end component;

    component M2716_rom is
        port(
            clk    : in  std_logic;
            oe_n   : in  std_logic;
            ce_n   : in  std_logic;
            addr   : in  std_logic_vector(12 downto 0);
            data   : out std_logic_vector(7 downto 0)
        );
    end component M2716_rom;

    component game_ram is
        port(
            clka  : in  std_logic;
            clkb  : in  std_logic;
            ena   : in  std_logic;
            enb   : in  std_logic;
            wea   : in  std_logic;
            web   : in  std_logic;
            addra : in  std_logic_vector(11 downto 0);
            addrb : in  std_logic_vector(11 downto 0);
            dia   : in  std_logic_vector(7 downto 0);
            dib   : in  std_logic_vector(7 downto 0);
            doa   : out std_logic_vector(7 downto 0);
            dob   : out std_logic_vector(7 downto 0)
        );
    end component game_ram;

    component MB8125 is
        port(
            clk  : in  std_logic;
            we   : in  std_logic;
            en   : in  std_logic;
            addr : in  std_logic_vector(9 downto 0);
            di   : in  std_logic;
            do   : out std_logic
        );
    end component MB8125;

    component BulletRender is
        Port (
            clk             : in std_logic;
            clk_32M         : in std_logic ;
            clr_n           : in std_logic;
            hCount          : in std_logic_vector (8 downto 0) ;
            vCount          : in std_logic_vector (8 downto 0) ;
            h256_out        : in std_logic ;
            h256_ast_out    : in std_logic ;
            data_in         : in std_logic_vector(7 downto 0);
            load_count      : in std_logic ;
            clear_count     : in std_logic ;
            data_out        : out std_logic
        );
    end component BulletRender;

    component  LS74259 is
        Port (
            clr_n         : in std_logic ;
            d             : in std_logic ;
            we_n          : in std_logic ;
            add           :  in std_logic_vector(2 downto 0);
            dout          :  out std_logic_vector(7 downto 0)
        );
    end component LS74259;

    component LS74251 is
        Port (
            q             : out std_logic ;
            we_n          : in std_logic ;
            add           :  in std_logic_vector(2 downto 0);
            din           :  in std_logic_vector(7 downto 0)
        );
    end component LS74251;

end package tank_batallion_defs;













