library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity impfuncttb is 
end entity;


architecture sim of impfuncttb is 
    constant clf : integer := 100; -- 10Hz
    constant clp : time := 1000 ms / clf;
    signal clk : std_logic := '1';
    signal nrst : std_logic := '0';
	signal northred : std_logic;
	signal northyellow : std_logic;
	signal northgreen : std_logic;
	signal westred : std_logic;
	signal westyellow : std_logic;
	signal westgreen : std_logic;
begin
    i_trafficlights : entity work.impfuncttl(rtl)
    generic map(clf => clf)
    port map(
        clk => clk,
        nrst => nrst,
	    northred => northred,
	    northyellow => northyellow,
	    northgreen => northgreen, 
	    westred => westred,
	    westyellow => westyellow,
	    westgreen => westgreen
    );


-- Process for generating the clock
    clk <= not clk after clp/2;
    
    process is 
    begin
        wait until rising_edge(clk);
        wait until rising_edge(clk);

        -- take the device under testing out of reset 
        nrst <= '1';
        wait;
    end process;

end architecture;
