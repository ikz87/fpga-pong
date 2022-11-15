library ieee;
use ieee.std_logic_1164.all;

entity stdlogictb is 
end entity;

architecture sim of stdlogictb is 
    -- Note that when assigning to values to std logic 
    -- we use single quotation marks
    signal signal1 : std_logic := '0';
    signal signal2 : std_logic;
    signal signal3 : std_logic;
begin
    process is 
    begin
        wait for 10 ns;
        signal1<= not signal1;
    end process;

    -- Driver A
    process is 
    begin
        signal2 <= 'Z';
        signal3 <= '0';
        wait;
    end process;

    -- Driver B
    process(signal) is 
    begin 
        if signal1 = '0' then
            signal2 <= 'Z';
            signal3 <= 'Z';
        else
            signal2 <= '1';
            signal3 <= '1';
        end if;
    end process;

end architecture;
