library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity signedunsignedtb is 
end entity;

architecture sim of signedunsignedtb is 

    signal unscnt : unsigned(7 downto 0) := (others => '0'); 
    signal sigcnt : signed(7 downto 0) := (others => '0'); 

    signal uns4 : unsigned(3 downto 0) := "0100"; 
    signal sig4 : signed(3 downto 0) := "0100";

    signal uns8 : unsigned(7 downto 0) := (others => '0'); 
    signal sig8 : signed(7 downto 0) := (others => '0'); 
begin

    process is 
    begin
        
        wait for 10 ns;

        -- wrapping counter
        unscnt <= unscnt + 1;
        sigcnt <= sigcnt + 1;
        
        -- Adding signals 
        uns8 <= uns8 + uns4;
        sig8 <= sig8 + sig4;
           
    end process;
end architecture;
