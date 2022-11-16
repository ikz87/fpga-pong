library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity flipflop is 
    port(
    clk : in std_logic;
    nrst : in std_logic;
    input : in std_logic;
    output : out std_logic);
end entity;


architecture rtl of flipflop is 
begin
    -- flipflop logic
    process(clk) is 
    begin 
        if rising_edge(clk) then
             if nrst = '0' then
                 output <= '0';
             else
                 output <= input;
             end if;
        end if;
    end process;
end architecture;
