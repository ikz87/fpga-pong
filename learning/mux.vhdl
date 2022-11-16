library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux is 
    port(
        -- Inputs
    sig1 : in unsigned(7 downto 0);
    sig2 : in unsigned(7 downto 0);
    sig3 : in unsigned(7 downto 0);
    sig4 : in unsigned(7 downto 0);

    sel : in unsigned(1 downto 0);

    output : out unsigned(7 downto 0));
end entity;

architecture behav of mux is 
begin
    -- Mux using case
    process(sel, sig1, sig2, sig3, sig4) is 
    begin
        case sel is
            when "00" => 
                output <= sig1;
            when "01" =>
                output <= sig2;
            when "10" =>
                output <= sig3;
            when "11" =>
                output <= sig4;
            when others => 
                output <= (others => 'X');
        end case;
    end process;
end architecture;
