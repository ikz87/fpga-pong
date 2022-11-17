library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity impfuncttl is 
    generic(clf : integer);
    port(
    clk : in std_logic;
    nrst : in std_logic;
    northred : out std_logic;
    northyellow : out std_logic;
    northgreen : out std_logic;
    westred : out std_logic;
    westyellow : out std_logic;
    westgreen : out std_logic
);
end entity;
architecture rtl of impfuncttl is 
    -- Declaration of a function
    --        \/ Name       \/ args     \/ arg types and default values
    function countinterval (minutes : integer := 0; --      \/ return type
                            seconds : integer := 0) return integer is
    -- Functions have a declarative region here
        variable totalseconds : integer;
    -- Here we have declared a variable local to the function
    begin
        totalseconds := seconds + minutes * 60;
        return totalseconds * clf - 1;
    end function;



    -- Standard enum declaration and data signal declaration
    -- This is similar to structs
    type std_state is (northnext, startnorth, north, stopnorth,
                    westnext, startwest, west, stopwest);
    signal state : std_state;
    signal counter : integer range 0 to clf * 60;
begin
    process(clk) is 
        -- This is the declarative region of the process 
        -- Functions can be declared here
        -- They'd be only accessible from this process
        -- Impure functions can read and write to external signals
        impure function counterexpired (minutes : integer := 0;
                                        seconds : integer := 0)
                                        return boolean is 
        begin
            if counter = countinterval(minutes, seconds) then 
                counter <= 0;
                return true;
            else
                return false;
            end if;
        end function;
    begin 
        if rising_edge(clk) then
             if nrst = '0' then
                 -- Reset values
                 state <= northnext;
                 northred <= '1';
                 northyellow <= '0';
                 northgreen <= '0';
                 westred <= '1';
                 westyellow <= '0';
                 westgreen <= '0';
                 counter <= 0;
             else
                
                 -- Default values 
                northred <= '0';
                northyellow <= '0';
                northgreen <= '0';
                westred <= '0';
                westyellow <= '0';
                westgreen <= '0';

                counter <= counter + 1;
                case state is 
                    when northnext =>
                        northred <= '1';
                        westred <= '1';
                        if counterexpired(seconds => 5) then
                            counter <= 0;
                            state <= startnorth;
                        end if;
                    when startnorth =>
                        northyellow <= '1';
                        westred <= '1';
                        if counterexpired(seconds => 5) then
                            counter <= 0;
                            state <= north;
                        end if;
                    when north =>
                        northgreen <= '1';
                        westred <= '1';
                        if counterexpired(minutes => 1) then
                            counter <= 0;
                            state <= stopnorth;
                        end if;
                    when stopnorth =>
                        northyellow <= '1';
                        westred <= '1';
                        if counterexpired(seconds => 5) then
                            counter <= 0;
                            state <= westnext;
                        end if;
                    when westnext =>
                        northred <= '1';
                        westred <= '1';
                        if counterexpired(seconds => 5) then
                            counter <= 0;
                            state <= startwest;
                        end if;
                    when startwest =>
                        northred <= '1';
                        westyellow <= '1';
                        if counterexpired(seconds => 5) then
                            counter <= 0;
                            state <= west;
                        end if;
                    when west =>
                        northred <= '1';
                        westgreen <= '1';
                        if counterexpired(minutes => 1) then
                            counter <= 0;
                            state <= stopwest;
                        end if;
                    when stopwest =>
                        northred <= '1';
                        westyellow <= '1';
                        if counterexpired(seconds => 5) then
                            counter <= 0;
                            state <= northnext;
                        end if;
                end case;
             end if;
        end if;
    end process;
end architecture;
