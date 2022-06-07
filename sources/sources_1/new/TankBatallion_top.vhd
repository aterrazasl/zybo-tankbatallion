library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
use work.tank_batallion_defs.all;


entity TankBatallion_top is
    port (
        i_reset      : in   std_logic;
        i_clock      : in  std_logic;   -- 125Mhz input clock from L16
        i_clock32M   : in std_logic ;
        VGAports     : out VGA_output_ports;
        fixed_tile   : in std_logic_vector (2 downto 0)
    );
end TankBatallion_top;

architecture Behavioral of TankBatallion_top is

    use work.tank_batallion_defs.all;

    signal clock : std_logic;
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
    signal nROM, nWO, nWRAM, nVRAM : std_logic ;
    signal nWRAM0_VA,nVRAM_VA : std_logic ;
    signal D4_1_y : std_logic ;
    signal F4_o9,F4_o8,nDIPSW,F4_o6,nIN1,nIN0,nWDR,nINTACK,nOUT1,nOUT0 : std_logic;
    signal ic74ls42_4f_dout : std_logic_vector (9 downto 0);
    signal C4_6 , C3_2_y: std_logic ;
    
    signal vCount, hCount : std_logic_vector (8 downto 0);
    signal bullet_out : std_logic ;

begin


    --tile_to_display <= x"A" & '0' & fixed_tile;

    clock <= i_clock ;
    --    CLOCK_6MHZ : clk_wiz_0
    --        port map (
    --            clk_out1 => clock,
    --            clk_in1  => i_clock
    --        );


    ---- Timing sync generation    ---- 

    TimingSync_Module: component TimingSync
        Port map (
            clk           => clock,
            clr_n         => not (i_reset),
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
            nINTACK       => nINTACK,
            v_out         => vCount,
            h_out         => hCount
        );

    VGAports.h_sync  <= h256;
    VGAports.v_sync  <= vsync;



    --    TEST_PATTERN :block
    --    begin
    --        red      <= data_count(3) and data_count2(3) and (data_count(7)) and vblank ;
    --        green    <= data_count(2) and data_count2(2) and (data_count(7)) and vblank ;
    --        blue     <= data_count(4) and data_count2(4) and (data_count(7)) and vblank ;
    --        VGAports.red    <= red & red & red & red & red;
    --        VGAports.green  <= green & green & green & green & green & green;
    --        VGAports.blue   <= blue & blue & blue  & blue  & blue;

    --    end block TEST_PATTERN;


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
            clr_n           => not (i_reset),
            clk             => clock,
            clk_dis         => '0',
            serial          => '0',
            shift_load      => y0 and y1,
            d               => rom_data,
            qh              => ic74ls166_4D_1_qh
        );




    ROM2716 : component  M2716
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
            clr_n   => not(i_reset ),
            clk     => clock, --i_clock32M,
            d       => tile(7 downto 2), --"110011",
            q       => ic74ls174_3J_1_q,
            enable  =>y0 and y1
        );

    ic7052_3L : component IC7052
        port map(
            clk     => i_clock32M,
            oe_n    => not(vblank),
            ce_n    => not(vblank),
            addr    => ic74ls174_3J_1_q & bullet_out & ic74ls166_4D_1_qh,
            data    => color_data  --blue & green & red & red2
        );

    VGAports.blue   <= color_data(3) & color_data(3) & color_data(3) & color_data(3) & color_data(3);
    VGAports.green  <= color_data(2) & color_data(2) & color_data(2) & color_data(2) & color_data(2) & color_data(2);
    VGAports.red    <= color_data(1) & color_data(1) & color_data(1) & color_data(1) & color_data(1);




    ic_static_frame_mux_1 : component  LS74157
        Port map(
            sel          => '1',
            en_n         => '1' and  (h256_out) ,
            d0           => "0000",
            d1           => '1' & '0' & data_count2(6) & data_count2(5),
            z            => rom_addr_static (11 downto 8)
        );

    ic_static_frame_mux_2 : component  LS74157
        Port map(
            sel          => '1',
            en_n         => '1' and  (h256_out) ,
            d0           => "0000",
            d1           => data_count2(4) & data_count2(3) &  data_count2(2) & data_count(6),
            z            => rom_addr_static (7 downto 4)
        );

    ic_static_frame_mux_3 : component  LS74157
        Port map(
            sel          => '1',
            en_n         => '0'  ,
            d0           => "0000",
            d1           => data_count(5) & data_count(4) & data_count(3) & data_count(2),
            z            => rom_addr_static (3 downto 0)
        );



    icStatic_frame: component LS74273
        Port map(
            clr_n   => not(i_reset ),
            clk     => data_count(1),  --h4
            d       => tile_to_display,
            q       => tile ,
            enable  => '1'
        );


    --    isM2716_static : component  M2716_static_frame
    --        port map(
    --            clk    => i_clock32M,
    --            oe_n   => '0' ,
    --            ce_n   => '0',
    --            addr   => rom_addr_static(10 downto 0),
    --            data   => tile_to_display
    --        );




    CPU_CLOCK_MOD : component cpu_clock
        Port map (
            clk         => i_clock32M,
            rst_n       => not(i_reset),
            Phi2        => data_count(1) ,
            cpu_clken   => cpu_clken
        );


    CPU_6502 : component  arlet_6502
        Port map (
            clk             => i_clock32M,
            enable          => cpu_clken,
            rst_n           => not(i_reset),
            ab              => A,
            dbi             => cpudata_in,
            dbo             => cpudata_out,
            we              => r_w,
            irq_n           => not(nIRQ),
            nmi_n           => '1',
            ready           => cpu_clken,
            pc_monitor   =>  open
        );

    nROM <= not (A(13));

    ROM_MEMORY : component M2716_rom
        port map(
            clk    => i_clock32M,
            oe_n   => nROM,
            ce_n   => nROM,
            addr   => A(12 downto 0),
            data   => romdata_out
        );
    
    
    C3_2_y <= '0' when ((A(13)='0') and (r_w ='1')) else '1';
    C4_6  <= not(nROM) and C3_2_y;

    nWRAM <= '0' when (A(10)='0' and A(11) ='0' and C4_6 ='0') else
             '0' when (A(10)='1' and A(11) ='0' and C4_6 ='0') else
             '1';

    nVRAM <= '0' when (A(10)='0' and A(11) ='1' and C4_6 ='0') else
             '1';

    nWO   <= '0' when ((A(13)='0') and (r_w ='0')) else '1';

    RAM_MEMORY : component game_ram
        port map(
            clka    => i_clock32M,
            clkb    => i_clock32M,
            ena     => '1',
            enb     => '1',
            wea     => (not(nWO) and not(nWRAM)) or (not(nWO) and not(nVRAM)),
            web     => '0',
            addra   => A(11 downto 0),
            addrb   => rom_addr_static,
            dia     => cpudata_out,
            dib     => x"00",
            doa     => ramdata_out ,
            dob     => ramVdata_out
        );



    cpudata_in <= romdata_out when nROM = '0' else
                 ramdata_out when nWRAM ='0' else
                 ramdata_out when nVRAM ='0' else
                 x"ff" when nDIPSW ='0' else
                 x"ff";




    nWRAM0_VA <= '1' when (rom_addr_static(11 downto 4) = "00000000") else
                '0';
    nVRAM_VA  <= '1' when (rom_addr_static(11 downto 10) = "10")      else
                '0';

    tile_to_display <= ramVdata_out when (nWRAM0_VA ='1' or nVRAM_VA  = '1' )else
                        x"FF";



    D4_1_y <= '0' when (A(10)='1') and (A(11)='1' and C4_6 ='0') else
                '1';


    ic74ls42_4f :component LS7442
        Port map (
            din           => D4_1_y & nWO & A(4) & A(3),
            dout          => ic74ls42_4f_dout
        );


F4_o9   <= ic74ls42_4f_dout(9);
F4_o8   <= ic74ls42_4f_dout(8);
nDIPSW  <= ic74ls42_4f_dout(7);
F4_o6   <= ic74ls42_4f_dout(6);
nIN1    <= ic74ls42_4f_dout(5);
nIN0    <= ic74ls42_4f_dout(4);
nWDR    <= ic74ls42_4f_dout(3);
nINTACK <= ic74ls42_4f_dout(2);
nOUT1   <= ic74ls42_4f_dout(1);
nOUT0   <= ic74ls42_4f_dout(0);





    BULLET_RENDER:  component BulletRender 
        Port map(
            clk              =>  clock ,
            clk_32M          =>  i_clock32M ,
            clr_n            =>  not (i_reset),
            hCount           =>  hCount ,
            vCount           =>  vCount,
            h256_out         =>  h256_out ,
            h256_ast_out     =>  h256_ast_out ,
            data_in          =>  tile,
            load_count       =>  y3,
            clear_count      =>  y1,
            data_out         =>  bullet_out
        );


end Behavioral;
