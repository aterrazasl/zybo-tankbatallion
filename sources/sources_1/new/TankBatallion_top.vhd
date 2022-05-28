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

    signal tile_to_display : std_logic_vector (7 downto 0);

begin


    tile_to_display <= x"A" & '0' & fixed_tile;
    
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
            high_count    => data_count2
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
            addr   => tile_to_display & data_count2(1) & data_count2(0) & v1, --x"CE" & data_count2(1) & data_count2(0) & v1,
            data   => rom_data
        );
    --        //rom_addr <= x"CE";      ---Update me

    ic74ls174_3J : component LS74174
        Port map(
            clr_n   => not(i_reset ),
            clk     => y0 and y1,
            d       => tile_to_display(7 downto 2), --"110011",
            q       => ic74ls174_3J_1_q
        );

    ic7052_3L : component IC7052
        port map(
            clk     => i_clock32M,
            oe_n    => not(vblank),
            ce_n    => not(vblank),
            addr    => ic74ls174_3J_1_q & '0' & ic74ls166_4D_1_qh,
            data    => color_data  --blue & green & red & red2
        );

    VGAports.blue   <= color_data(3) & color_data(3) & color_data(3) & color_data(3) & color_data(3);
    VGAports.green  <= color_data(2) & color_data(2) & color_data(2) & color_data(2) & color_data(2) & color_data(2);
    VGAports.red    <= color_data(1) & color_data(1) & color_data(1) & color_data(1) & color_data(1);

end Behavioral;
