
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.tank_batallion_defs.all;


entity TankBatallion_top is
    port (
        i_reset      : in   std_logic;
        i_clock      : in   std_logic;   -- 6Mhz input clock required
        i_clock32M   : in   std_logic;
        VGAports     : out  VGA_output_ports;
        controls     : in   Zybo_CONTROLS;
        dip_switch   : in   Zybo_DIP_SWITCH
    );
end TankBatallion_top;

architecture Behavioral of TankBatallion_top is

    use work.tank_batallion_defs.all;

    signal data_count, data_count2 : std_logic_vector (7 downto 0);

    signal h256, compsync, vblank, vsync : std_logic ;

    signal red,red2, green, blue : std_logic ;

    signal rom_addr : std_logic_vector (10 downto 0);
    signal rom_data : std_logic_vector (7 downto 0);

    signal h1,v1, h256_out, h256_ast_out: std_logic ;
    signal y0,y1,y2,y3 : std_logic ;

    signal ic74ls166_4D_1_qh : std_logic ;
    signal ic74ls174_3J_1_q : std_logic_vector(5 downto 0) ;
    signal color_data : std_logic_vector (3 downto 0);

    signal tile, tile_to_display : std_logic_vector (7 downto 0);

    signal rom_addr_static : std_logic_vector (11 downto 0);



    --cpu signal
    signal cpu_clken : std_logic ;
    signal A : std_logic_vector (15 downto 0);
    signal cpudata_in, cpudata_out, romdata_out, ramdata_out, ramVdata_out : std_logic_vector (7 downto 0);
    signal r_w, nIRQ : std_logic ;
    signal nROM : std_logic ;

    signal vCount, hCount : std_logic_vector (8 downto 0);
    signal bullet_out : std_logic ;
    signal nmi_n : std_logic ;

    signal dipsw_q, in1_q, in0_q : std_logic ;

    signal per_map : PERIPHERAL_MAP;
    signal i_reset_n : std_logic;
begin

    i_reset_n <= not(i_reset);
    ---- Timing sync generation    ---- 

    TimingSync_Module: component TimingSync
        Port map (
            clk           => i_clock,
            clr_n         => i_reset_n,
            hsync         => h256,
            vsync         => vsync,
            compsync      => compsync,
            vblank        => vblank,
            h1_out        => h1,
            v1_out        => v1,
            h256_out      => h256_out,
            h256_ast_out  => h256_ast_out,
            low_count     => data_count,
            high_count    => data_count2,
            nIRQ          => nIRQ,
            nINTACK       => per_map.nINTACK,
            v_out         => vCount,
            h_out         => hCount
        );

    VGAports.h_sync  <= h256;
    VGAports.v_sync  <= vsync;


    ic74ls139_4D : component LS74139
        Port map(
            oe_n   =>  not(data_count(1) and data_count(0) and h1),
            sel    =>  h256_out & h256_ast_out,
            y0     =>  y0,
            y1     =>  y1,
            y2     =>  y2,
            y3     =>  y3
        );

    ic74ls166_4D : component LS74166
        Port map(
            clr_n           => i_reset_n,
            clk             => i_clock,
            clk_dis         => '0',
            serial          => '0',
            shift_load      => y0 and y1,
            d               => rom_data,
            qh              => ic74ls166_4D_1_qh
        );

    CHARACTER_ROM_2716_2K : component  M2716
        port map (
            clk    => i_clock32M,
            oe_n   => '0',
            ce_n   => '0',
            addr   => tile & data_count2(1) & data_count2(0) & v1, --x"CE" & data_count2(1) & data_count2(0) & v1,
            data   => rom_data
        );
    --        //rom_addr <= x"CE";      ---Update me

    ic74ls174_3J : component LS74174
        Port map(
            clr_n   => i_reset_n,
            clk     => i_clock, --i_clock32M,
            d       => tile(7 downto 2), --"110011",
            q       => ic74ls174_3J_1_q,
            enable  =>y0 and y1
        );

    COLOR_ROM_ic7052_3L : component IC7052
        port map(
            clk     => i_clock32M,
            oe_n    => vblank,
            ce_n    => vblank,
            addr    => ic74ls174_3J_1_q & bullet_out & ic74ls166_4D_1_qh,
            data    => color_data  --blue & green & red & red2
        );

    VGAports.blue   <= color_data(3) & color_data(3) & color_data(3) & color_data(3) & color_data(3) & color_data(3);
    VGAports.green  <= color_data(2) & color_data(2) & color_data(2) & color_data(2) & color_data(2) & color_data(2);
    VGAports.red    <= color_data(1) & color_data(1) & color_data(1) & color_data(1) & color_data(1) & color_data(1);




    --    ic_static_frame_mux_1 : component  LS74157
    --        Port map(
    --            sel          => '1',
    --            en_n         => '1' and  (h256_out) ,
    --            d0           => "0000",
    --            d1           => '1' & '0' & data_count2(6) & data_count2(5),
    --            z            => rom_addr_static (11 downto 8)
    --        );

    --    ic_static_frame_mux_2 : component  LS74157
    --        Port map(
    --            sel          => '1',
    --            en_n         => '1' and  (h256_out) ,
    --            d0           => "0000",
    --            d1           => data_count2(4) & data_count2(3) &  data_count2(2) & data_count(6),
    --            z            => rom_addr_static (7 downto 4)
    --        );

    --    ic_static_frame_mux_3 : component  LS74157
    --        Port map(
    --            sel          => '1',
    --            en_n         => '0'  ,
    --            d0           => "0000",
    --            d1           => data_count(5) & data_count(4) & data_count(3) & data_count(2),
    --            z            => rom_addr_static (3 downto 0)
    --        );


    -- Video address mapping --
    rom_addr_static <=   '1' & '0' & data_count2(6) & data_count2(5) &  data_count2(4) & data_count2(3) &  data_count2(2) & data_count(6)& data_count(5) & data_count(4) & data_count(3) & data_count(2);



    ic74ls274_2L: component LS74273
        Port map(
            clr_n   => i_reset_n,
            clk     => data_count(1),  --h4
            d       => tile_to_display,
            q       => tile ,
            enable  => '1'
        );

    -- CPU 6502 module --
    CPU_CLOCK_MOD : component cpu_clock
        Port map (
            clk         => i_clock32M,
            rst_n       => i_reset_n,
            Phi2        => data_count(1) ,
            cpu_clken   => cpu_clken
        );

    CPU_6502 : component  arlet_6502
        Port map (
            clk             => i_clock32M,
            enable          => cpu_clken,
            rst_n           => i_reset_n,
            ab              => A,
            dbi             => cpudata_in,
            dbo             => cpudata_out,
            we              => r_w,
            irq_n           => nIRQ,
            nmi_n           => nmi_n nand vblank , --'1',
            ready           => cpu_clken,
            pc_monitor   =>  open
        );

    nROM <= not (A(13));

    cpudata_in <= romdata_out               when nROM  = '0' else
 ramdata_out               when per_map.nWRAM  ='0' else
 ramdata_out               when per_map.nVRAM  ='0' else
 dipsw_q & "0000000"       when per_map.nDIPSW ='0' else
 in1_q   & "0000000"       when per_map.nIN1   ='0' else
 in0_q   & "0000000"       when per_map.nIN0   ='0' else
 x"ff";

    PROGRAM_MEMORY : component M2716_rom
        port map(
            clk    => i_clock32M,
            oe_n   => nROM,
            ce_n   => nROM,
            addr   => A(12 downto 0),
            data   => romdata_out
        );

    RAM_MEMORY : component game_ram
        port map(
            clka    => i_clock32M,
            clkb    => i_clock32M,
            ena     => '1',
            enb     => '1',
            wea     => (not(per_map.nWO) and not(per_map.nWRAM)) or (not(per_map.nWO) and not(per_map.nVRAM)),
            web     => '0',
            addra   => A(11 downto 0),
            addrb   => rom_addr_static,
            dia     => cpudata_out,
            dib     => x"00",
            doa     => ramdata_out ,
            dob     => ramVdata_out
        );

    ADDRESS_DECODING : component address_decoder
        Port map(
            cpu_r_w          => r_w,
            A                => A,
            nROM             => nROM,
            h2               => hCount(1),
            rom_addr_static  => rom_addr_static,
            per_map          => per_map
        );

    tile_to_display <= ramVdata_out when (per_map.nWRAM0_VA ='1' or per_map.nVRAM_VA  = '1' )else x"FF";

    -- Renders bullet --
    BULLET_RENDER:  component BulletRender
        Port map(
            clk              =>  i_clock ,
            clk_32M          =>  i_clock32M ,
            clr_n            =>  i_reset_n,
            hCount           =>  hCount ,
            vCount           =>  vCount,
            h256_out         =>  h256_out ,
            h256_ast_out     =>  h256_ast_out ,
            data_in          =>  tile,
            load_count       =>  y3,
            clear_count      =>  y1,
            data_out         =>  bullet_out
        );

    -- Peripheal module to handle inputs and outputs from the system --
    PERIPHERAL_LOGIC : component peripheral_control
        Port map(
            i_reset      => i_reset,
            A            => A(2 downto 0),
            controls     => controls,
            dip_switch   => dip_switch,
            per_map      => per_map,
            nmi_n        => nmi_n,
            cpudata_in   => cpudata_out(0),
            dipsw_q      => dipsw_q,
            in1_q        => in1_q,
            in0_q        => in0_q
        );

end Behavioral;
