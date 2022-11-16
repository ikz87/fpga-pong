library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity casewhentb is 
end entity;

architecture sim of casewhentb is 

    signal sig1 : unsigned(7 downto 0) := x"AA";
    signal sig2 : unsigned(7 downto 0) := x"BB";
    signal sig3 : unsigned(7 downto 0) := x"CC";
    signal sig4 : unsigned(7 downto 0) := x"DD";

    signal sel : unsigned(1 downto 0) := (others => '0');

    signal output1 : unsigned(7 downto 0);
    signal output2 : unsigned(7 downto 0);

    -- We are creating a multiplexer, that looks like this
    --                 sel 
    --                  |
    --                  |
    --      sig1 ----|--\
    --               |   --\
    --      sig2 ----|      --\
    --               |         >--- output
    --      sig3 ----|      --/
    --               |   --/
    --      sig4 ----|--/
    -- 
    -- Where output takes the value of one of the 4 input signals 
    -- depending on the value of sel
    
begin

    -- Basically a testbench for the multiplexer
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

    -- Mux using if-then-else
    process(sel, sig1, sig2, sig3, sig4) is 
    begin
        if sel = "00" then
            output1 <= sig1;
        elsif sel = "01" then
            output1 <= sig2;
        elsif sel = "10" then
            output1 <= sig3;
        elsif sel = "11" then
            output1 <= sig4;
        else
            output1 <= (others => 'X');
        end if;
    end process;

    -- Mux using case
    process(sel, sig1, sig2, sig3, sig4) is 
    begin
        case sel is
            when "00" => 
                output2 <= sig1;
            when "01" =>
                output2 <= sig2;
            when "10" =>
                output2 <= sig3;
            when "11" =>
                output2 <= sig4;
            when others => 
                output2 <= (others => 'X');
        end case;
    end process;



end architecture;
