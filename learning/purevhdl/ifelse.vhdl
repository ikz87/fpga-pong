entity ifelsetb is 
end entity;

architecture sim of ifelsetb is 
    signal countup : integer := 0;
    signal countdown : integer := 10;
begin
    process is 
    begin
        countup <= countup + 1;
        countdown <= countdown - 1;
        wait for 100000 ms;
    end process;

    process is 
    begin
        if countup > countdown then
            report "Countup is larger";
        elsif countup < countdown then
            report "Countdown is larger";
        else
            report "they're equal";
        end if;
        wait on countup, countdown;
    end process;
end architecture;
