library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity portmaptb is 
end entity;

architecture sim of portmaptb is 

    signal sig1 : unsigned(7 downto 0) := x"AA";
    signal sig2 : unsigned(7 downto 0) := x"BB";
    signal sig3 : unsigned(7 downto 0) := x"CC";
    signal sig4 : unsigned(7 downto 0) := x"DD";

    signal sel : unsigned(1 downto 0) := (others => '0');

    signal output : unsigned(7 downto 0);

begin

    -- instantiate a mux module
    --              \/ name of the current library (work is default)
    i_mux   :   entity work.mux(behav) port map (
    --^name of the instance  ^name of the entity declared in 
    --                        mux.vhdl
    -- First sel is the port of the i_mux entity
    -- Second one is the local signal
    sel => sel, -- <- we separate with a comma
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
