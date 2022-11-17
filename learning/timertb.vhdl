library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity timertb is 
end entity;


architecture sim of timertb is 
    constant clf : integer := 10; -- 10Hz
    constant clp : time := 1000 ms / clf;
    signal clk : std_logic := '1';
    signal nrst : std_logic := '0';
    signal seconds : integer;
    signal minutes : integer;
    signal hours : integer;

begin

    i_timer : entity work.timer(rtl)
    generic map (clf => clf)
    port map (
        clk => clk,
        nrst => nrst,
        seconds => seconds,
        minutes => minutes,
        hours => hours);
        
-- Process for generating the clock
    clk <= not clk after clp/2;
    
    process
    begin
        wait until rising_edge(clk);
        wait until rising_edge(clk);

        -- take the device under testing out of reset 
        nrst <= '1';
        wait;
    end process;

end architecture;
