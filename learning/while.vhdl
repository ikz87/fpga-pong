entity whiletb is 
end entity;

architecture sim of whiletb is 
begin
    process is 
        variable i : integer := 0;
    begin
        while i < 10 loop
            report "i=" & integer'image(i);
            i := i + 1;
        end loop;
        wait;
    end process;
end architecture;
