library ieee;
use ieee.std_logic_1164.all;

entity logicvectortb is 
end entity;

architecture sim of logicvectortb is 
    -- Declaration of an 8bit vector
    signal sigvec1 : std_logic_vector(7 downto 0);

    -- Another declaration, now with all bits initialized as 0 
    signal sigvec2 : std_logic_vector(7 downto 0) := (others => '0');
    
    -- Now with all bits initialized as 1
    signal sigvec3 : std_logic_vector(7 downto 0) := (others => '1');

    -- Now we initialize the vector as hex (not recommended as it is 
    -- dependant on the vector's length)
    signal sigvec4 : std_logic_vector(7 downto 0) := x"AA";

    -- Similar as hex, but in binary
    signal sigvec5 : std_logic_vector(7 downto 0) := "10101010";

    -- When declaring vectors, downto means descending order,
    -- to means ascending order. This basically inverts the
    -- indexing of the bits inside the vector. This is considered
    -- non standard.
    signal sigvec6 : std_logic_vector(0 to 7) := "11101010";

    signal sigvec7 : std_logic_vector(7 downto 0) := "00000001";
    
begin

    -- Shift register
    process is 
    begin
        
        wait for 10 ns;
        -- Remember that for iterations include the limit
        -- of the range.
        
        for i in sigvec7'left downto sigvec7'right + 1 loop
            -- Basically standard "array notation"
            -- but we use () instead of []
            sigvec7(i) <= sigvec7(i-1); 
        end loop;

        sigvec7(sigvec7'right) <= sigvec7(sigvec7'left);
            
    end process;
end architecture;
