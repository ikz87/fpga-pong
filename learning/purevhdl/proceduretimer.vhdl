library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity proceduretimer is 
    generic(clf : integer);
    port(
    clk : in std_logic;
    nrst : in std_logic;
    seconds : inout integer;
    minutes : inout integer;
    hours : inout integer);
end entity;


architecture rtl of proceduretimer is 
    -- counting clock ticks
    signal ticks : integer;

    -- Procedures are also declared in the 
    -- declarative region of the code
    -- This is similar to a function
    procedure incrementwrap (signal counter : inout integer;
                        constant wrapvalue : in integer;
                        variable wrapped : out boolean;
                        constant enable : in boolean) is 
    begin
        if enable then
            if counter = wrapvalue - 1 then
                wrapped := true;
                counter <= 0;
            else
                wrapped := false;
                counter <= counter + 1;
            end if;
        end if;
    end procedure;
begin
    process(clk) is 
        variable wrapped : boolean := false;
    begin 
        if rising_edge(clk) then
             if nrst = '0' then
                ticks <= 0;
                seconds <= 0;
                minutes <= 0;
                hours <= 0;
             else
                incrementwrap(ticks, clf, wrapped, true);
                incrementwrap(seconds, 60, wrapped, wrapped);
                incrementwrap(minutes, 60, wrapped, wrapped);       
                incrementwrap(hours, 23, wrapped, wrapped);
             end if;
        end if;
    end process;
end architecture;
