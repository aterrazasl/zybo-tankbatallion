

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;



entity BulletRender is
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
        clear_count      : in std_logic ;
        data_out        : out std_logic
    );
end BulletRender;

architecture Behavioral of BulletRender is
    use work.tank_batallion_defs.all;

    signal zigma, address : std_logic_vector (7 downto 0);
    signal f3_out, e4_out , e5_out, c5_out, e3_q_n_out, d2_out : std_logic ;

begin


    -- Vertical delay ------------------------------------------

    zigma <=std_logic_vector ( unsigned(data_in) + unsigned (vCount (7 downto 0)));
    e4_out <= not(zigma(0) and zigma(1));

    f3_out <= not(h256_out and zigma(7)and zigma(6)and zigma(5)and zigma(4)and zigma(3)and zigma(2) and e4_out );

    ic74ls74_3E_1: component LS7474
        Port map (
            clr_n  => clr_n,
            pr_n   => '1',
            clk    => hCount(3),
            d      => f3_out,
            q      => open,
            q_n    => e3_q_n_out
        );

    e5_out <= not (e3_q_n_out and (not(hCount(2)) and not(hCount(2))) and (not(hCount(0) and hCount(1))) );


    -- Horizontal Delay------------------------------------------

    ic74ls161_2F: component LS74161
        port map (
            clr_n    => clear_count,
            load_n    => load_count,
            clk       => clk,
            enp      => '1',
            ent        =>'1',
            data_input  => data_in,
            data_output => address,
            rco        => open
        );


    c5_out <= h256_ast_out and e5_out;

    icMB8125_2D: component MB8125
        port map(
            clk    => clk_32M,
            we     => clk ,
            en     => c5_out,
            addr   => '0' & '0' & address,
            di     => h256_ast_out,
            do     => d2_out
        );


    ic74ls74_3E_2: component LS7474
        Port map (
            clr_n  => not(h256_ast_out),
            pr_n   => '1',
            clk    => not(clk),
            d      => d2_out,
            q      => data_out,
            q_n    => open
        );




end Behavioral;
