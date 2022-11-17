library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity timer is 
    generic(clf : integer);
    port(
    clk : in std_logic;
    nrst : in std_logic;
    seconds : inout integer;
    minutes : inout integer;
    hours : inout integer);
end entity;


architecture rtl of timer is 
    -- counting clock ticks
    signal ticks : integer;
begin
    process(clk) is 
    begin 
        if rising_edge(clk) then
             if nrst = '0' then
                ticks <= 0;
                seconds <= 0;
                minutes <= 0;
                hours <= 0;
             else
                if ticks = clf - 1 then
                    ticks <= 0;
                    if seconds = 59 then
                        seconds <= 0;
                        if minutes = 59 then
                            minutes <= 0;
                            if hours = 23 then
                                hours <= 0;
                            else 
                                hours <= hours + 1;
                            end if;
                        else
                            minutes <= minutes + 1;
                        end if;
                    else
                        seconds <= seconds + 1;
                    end if;
                else
                    ticks <= ticks + 1;
                end if;
             end if;
        end if;
    end process;
end architecture;
