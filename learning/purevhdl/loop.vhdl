entity looptb is 
end entity;

architecture sim of looptb is 
begin
    process is 
    begin
        report "Hi";
        loop
            report "in the loop";
            wait for 10 ns;
            exit; -- <- similar to "break"
        end loop;
        
        report "buh-bye";
        wait;
    end process;
end architecture;
