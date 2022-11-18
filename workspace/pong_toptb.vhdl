library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pongtoptb is 
end entity;

architecture sim of pongtoptb is 
    constant clf : integer := 100; -- 100hz
    constant clp : time := 1000 ms / clf;
    signal clk : std_logic := '1';
    signal nrst : std_logic := '0';
    signal p1up : std_logic := '1';
    signal p1down : std_logic := '0';
    signal p2up : std_logic := '0';
    signal p2down : std_logic := '1';
begin 
    i_pongtop : entity work.pongtop(behav)
    generic map (clf => clf)
    port map ( 
        clk => clk,
        nrst => nrst,
        
        p1up => p1up,
        p1down => p1down,
        
        p2up => p2up,
        p2down  => p2down
    );

    -- Generating the clock 
    clk <= not clk after clp/2;

    process is 
    begin
        wait until rising_edge(clk);
        wait until rising_edge(clk);

        -- take the device under testing out of reset 
        nrst <= '1';
        wait;
    end process;

    process is 
    begin 
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk); 
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);

        p1up <= not p1up;
        p1down <= not p1down;
        p2up <= not p2up;
        p2down <= not p2down;

        wait until rising_edge(clk); 
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);

        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        p1up <= not p1up;
        p1down <= not p1down;
        p2up <= not p2up;
        p2down <= not p2down;

        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk); 
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);

        p1up <= not p1up;
        p1down <= not p1down;
        p2up <= not p2up;
        p2down <= not p2down;

        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk); 
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);

        p1up <= not p1up;
        p1down <= not p1down;
        p2up <= not p2up;
        p2down <= not p2down;
        
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk); 
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);

        p1up <= not p1up;
        p1down <= not p1down;
        p2up <= not p2up;
        p2down <= not p2down;

        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk); 
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);

        p1up <= not p1up;
        p1down <= not p1down;
        p2up <= not p2up;
        p2down <= not p2down;

        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk); 
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);

        p1up <= not p1up;
        p1down <= not p1down;
        p2up <= not p2up;
        p2down <= not p2down;

        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk); 
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);

        p1up <= not p1up;
        p1down <= not p1down;
        p2up <= not p2up;
        p2down <= not p2down;


    end process;
end architecture;

