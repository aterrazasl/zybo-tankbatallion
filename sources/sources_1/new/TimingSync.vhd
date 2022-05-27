library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

entity TimingSync is
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
end TimingSync;

architecture Behavioral of TimingSync is

    use work.tank_batallion_defs.all; --.LS74161;

    signal data_count, data_count2 : std_logic_vector (7 downto 0);
    signal rco : std_logic ;

    signal q_n_loop :std_logic;
    signal q_loop :std_logic;
    
    signal h1, h2, h4, h8, h16, h32, h64, h128, h256, h256_n  : std_logic;
    signal v1, v2, v4, v8, v16, v32, v64, v128, v256          : std_logic;
    
    signal ic74ls74_5A_2_q, ic74ls74_5A_2_q_n, ic74ls74_5D_1_q_n, ic74ls74_5D_1_q, ic74ls161_6D_1_rco :std_logic;


begin
    vsync <= data_count2(7);
    compsync <= data_count2(7) and ic74ls74_5A_2_q_n;
    low_count  <= data_count;    -- Exposing 1H to 256H
    high_count <= data_count2;   -- Exposing 1V to 256V
    hsync <= ic74ls74_5A_2_q_n; --data_count(7);     -- Exposing 256H
    h1    <=  q_loop;
    h2    <=  data_count(0);
    h4    <=  data_count(1);
    h8    <=  data_count(2);
    h16   <=  data_count(3);
    h32   <=  data_count(4);
    h64   <=  data_count(5);
    h128  <=  data_count(6);
    h256_n  <=  not(data_count(7));
    h256    <=  data_count(7);

    v1    <=  ic74ls74_5D_1_q;
    v2    <=  data_count2(0);
    v4    <=  data_count2(1);
    v8    <=  data_count2(2);
    v16   <=  data_count2(3);
    v32   <=  data_count2(4);
    v64   <=  data_count2(5);
    v128  <=  data_count2(6);
    v256  <=  data_count2(7);  

    ic74ls74_5A_1: component LS7474
        Port map (
            clr_n  => clr_n,
            pr_n   => '1',
            clk    => clk,
            d      => q_n_loop,
            q      => q_loop,
            q_n    => q_n_loop
        );

    ic74ls161_6B: component LS74161
        port map (
            clr_n    => clr_n,
            load_n    => not(rco),
            clk       => clk,
            enp      => q_loop,
            ent        =>q_loop,
            data_input  => x"40", --"01000000",
            data_output => data_count,
            rco        => rco
        );

    ic74ls74_5A_2: component LS7474
        Port map (
            clr_n  => h256_n,
            pr_n   => '1',
            clk    => h16,
            d      => (not(h64) and h32),
            q      => ic74ls74_5A_2_q,
            q_n    => ic74ls74_5A_2_q_n
        );
        
    ic74ls74_5D_1: component LS7474
        Port map (
            clr_n  => clr_n,
            pr_n   => '1',
            clk    => ic74ls74_5A_2_q_n,
            d      => ic74ls74_5D_1_q_n,
            q      => ic74ls74_5D_1_q,
            q_n    => ic74ls74_5D_1_q_n
        );

    ic74ls161_6D: component LS74161
        port map (
            clr_n    => clr_n,
            load_n    => not(ic74ls161_6D_1_rco),
            clk       => ic74ls74_5A_2_q_n,
            enp      => ic74ls74_5D_1_q,
            ent        =>ic74ls74_5D_1_q,
            data_input  => x"7c", --"01111100",
            data_output => data_count2,
            rco        => ic74ls161_6D_1_rco
        );

    ic74ls74_5F_1: component LS7474
        Port map (
            clr_n  => clr_n,
            pr_n   => '1',
            clk    => v16,
            d      => not(v128 and v64 and v32),
            q      => vblank,
            q_n    => open
        );

end Behavioral;
