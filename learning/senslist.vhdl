entity senslisttb is 
end entity;

-- Up until now, we've used architecture "sim", which
-- is intended to run on simulations
--
architecture sim of senslisttb is 
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
        if countup = countdown then
            report "Process A: Same!";
        end if;
        wait on countup, countdown;
    end process;

    -- Let's make another process similar to the one above
    -- with a sensitivity list
    -- The process below is "sensible" to both
    -- countup and countdown, meaning it runs once everytime
    -- either of those signals gets updated
    -- Both processes are logically equal, but using
    -- sensitivity lists is generally cleaner
    process(countup, countdown) is 
    begin
        if countup = Countdown then 
            report "Process B: Same!";
        end if;
    end process;
end architecture;
