entity helloworldtb is 
end entity;

architecture sim of helloworldtb is 
begin
    process is 
    begin
        report "Hello world!";
        wait;
    end process;
end architecture;
