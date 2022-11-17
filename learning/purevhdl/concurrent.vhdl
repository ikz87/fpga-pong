library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity concurrenttb is 
end entity;

architecture sim of concurrenttb is 

    signal uns : unsigned(5 downto 0) := (others => '0'); 
    signal mult : unsigned(7 downto 0) := (others => '0'); 
    signal mult2 : unsigned(7 downto 0) := (others => '0'); 
    signal mult3 : unsigned(7 downto 0) := (others => '0'); 
begin

    process is 
    begin
        
        uns <= uns + 1;

        wait for 10 ns;
        
    end process;

    -- bit shifting examples
    process is 
    begin
        mult <= uns & "00";
        wait on uns;
    end process;

    process(uns) is 
    begin 
        mult2 <= uns & "00";
    end process;

    -- equivalent process using a concurrent statement
    -- Though it's outside of a process block, this assignment itself
    -- is a process. The compiler treats it as a process that is
    -- sensitive to every signal after the <= 
    -- In this case, our assignment is sensitive to the signal uns
    mult3 <= uns & "00"; 


end architecture;
