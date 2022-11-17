use std.textio.all; 

entity fizzbuzz is 
end entity;

architecture sim of fizzbuzz is 
begin
    process is 
        variable message : line;
    begin
        for i in 1 to 100 loop
            if i mod 3 = 0 then    
                write (message, string'("Fizz"));
            end if;
            if i mod 5 = 0 then
                write (message, string'("Buzz"));
            end if;
            if (i mod 5 /= 0) and (i mod 3 /= 0) then
                write (message, integer'(i));
            end if;
            writeline (output, message);
        end loop;
        wait;
    end process;
end architecture;
