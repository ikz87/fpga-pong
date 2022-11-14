entity waittb is 
end entity;

architecture sim of waittb is 
begin
    process is 
    begin
        report "Hello world!";
        wait for 1000 ms;
    end process;
end architecture;
