entity signalstb is 
end entity;

architecture sim of signalstb is 
    -- This part of the code is known as the declarative 
    -- region of the vhdl file
    -- Signals can only be declared here
    -- They can be accessed from every process within
    -- the architecture

    signal MySignal : integer := 0;

    -- The declarative region ends here
begin
    process is 
        -- Variables can only be accesed within the 
        -- process block they're declared in
        variable MyVar : integer := 0;
    begin
        MyVar := MyVar + 1;
        -- Notice the difference between varible and signal
        -- assignments
        MySignal <= MySignal + 1;
        
        -- Read note at line 35
        MySignal <= MySignal + 1;
        MySignal <= MySignal + 1;
        MySignal <= MySignal + 1;
        MySignal <= MySignal + 1;
        

        report "MyVar=" & integer'image(MyVar) &
            ", MySignal=" & integer'image(MySignal);
        wait for 10 ns;
        -- Signal values only update when the process pauses, so    
        -- since we have the wait AFTER the report, the 
        -- output will always show MySignal being one step
        -- behind MyVar. This also means that every consecutive
        -- operation applied to a signal (like in lines 26 - 29
        -- will actually be applied to the outdated value, and
        -- for consecutive assignments, the last one from top
        -- to bottom will take priority
    end process;
end architecture;
