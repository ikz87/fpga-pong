library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clockedprocesstb is 
end entity;


architecture sim of clockedprocesstb is 
    -- Frequency of the clock
    constant clf : integer := 100e6; -- 100 MHz

    -- Period of the clock 
    constant clp : time := 1000 ms / clf;

    -- Clock value
    signal clk : std_logic := '1';

    signal nrst : std_logic := '1';
    signal input : std_logic := '1';
    signal output : std_logic;

begin

    myflipflop : entity work.flipflop(rtl)
        port map (
            clk => clk,
            input => input,
            nrst => nrst,
            output => output
        );
    
-- Process for generating the clock
    clk <= not clk after clp/2;
    
    process
    begin
        wait for 20 ns;
        input <= '0';
        wait for 8 ns;
        input <= '1';
        wait for 5 ns;
        input <= '0';
        wait for 10 ns;
        input <= '1';
        wait for 20 ns;
        nrst <= '0';
    end process;

end architecture;
