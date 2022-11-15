entity waitonuntiltb is 
end entity;

architecture sim of waitonuntiltb is 
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
        -- This wait statement will freeze the second process 
        -- until countup and countdown have been updated
        wait on countup, countdown;
        report "countup=" & integer'image(countup) &
            ", countdown=" & integer'image(countdown);
    end process;
    process is 
    begin
        -- In this case, everytime countup or countdown change values
        -- the condition is evaluated. The process is frozen until
        -- the condittion is met
        wait until countup = countdown;
        report "They're the same";
    end process;
end architecture;
