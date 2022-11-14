entity forlooptb is 
end entity;

architecture sim of forlooptb is 
begin
    process is 
    begin
        -- Note: x in a to b includes a AND b as values for x to iterate over
        for i in 1 to 10 loop
            --                      \/ converts an int to a string(?)
            report "Cycle is: " & integer'image(i);
            --                  ^ concats the values given
        end loop;
        wait;
    end process;
end architecture;
