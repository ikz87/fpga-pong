library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity genericmaptb is 
end entity;

architecture sim of genericmaptb is 
    constant datawidth : integer := 2;

    signal sig1 : unsigned(datawidth-1 downto 0) := "00";
    signal sig2 : unsigned(datawidth-1 downto 0) := "01";
    signal sig3 : unsigned(datawidth-1 downto 0) := "10";
    signal sig4 : unsigned(datawidth-1 downto 0) := "11";

    signal sel : unsigned(1 downto 0) := (others => '0');

    signal output : unsigned(datawidth-1 downto 0);

begin

    i_mux   :   entity work.genericmux(behav) 
    generic map (datawidth => datawidth) 
    port map (
    sel => sel,
    sig1 => sig1,
    sig2 => sig2,
    sig3 => sig3,
    sig4 => sig4,
    output => output);

    -- Testbench process
    process is 
    begin
        wait for 10 ns;
        sel <= sel + 1; 
        wait for 10 ns;
        sel <= sel + 1; 
        wait for 10 ns;
        sel <= sel + 1; 
        wait for 10 ns;
        sel <= sel + 1; 
        wait for 10 ns;
        sel <= "UU"; 
        wait;
    end process;
end architecture;
