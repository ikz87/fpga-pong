library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity graphics is 
    generic(
    -- Clock frequency 
    clf : integer
);

port(
    -- Clock and reset 
    clk : in std_logic;
    gclk : inout std_logic := '0';
    nrst : in std_logic;

    -- Player positions 
    p1ypos : in integer := 0;
    p2ypos : in integer := 0;

    -- Ball position 
    ballxpos : in integer := 0;
    ballypos : in integer := 0;

    -- SPI ports 
    NCS : out std_logic := '1';
    MOSI : out std_logic := '0' 
    -- The internal clock will be used for SPI communication
);
end entity;

architecture behav of graphics is 
    function getaddress (i : integer) return std_logic_vector is
    begin 
        return std_logic_vector( to_unsigned(i, 8));
    end function;

    -- SPI stuff
    signal currow : integer := 0;
    signal ison : std_logic := '0';
    signal isable : std_logic := '0';
    constant turnon : std_logic_vector (15 downto 0) := "0000110000000001";
    constant abilitate : std_logic_vector (15 downto 0) := "0000101100001111";

    -- Counting clock ticks
    signal ticks : integer := 0;
    signal iticks : integer := 0;
    constant divisor : integer := 1;

    -- Screen dimension dependant properties 
    constant screenwidth : integer := 8;    
    constant screenheight : integer := 8;    
    constant pxpos : integer := 1;    
    constant pheight : integer := 3;
    constant mnumber : integer := 2;
    constant mwidth : integer := 16*mnumber-1;
    constant hmwidth : integer := 8*mnumber-1;
begin
    process(clk) is
    -- Array to keep track of every row and column    
    --                      columns    16*m# bit message (address+data)    
    type matrix is array (7 downto 0, mwidth downto 0) of std_logic;
    variable mymatrix : matrix ;


    -- Buffer for SPI adresses 
    variable currmessadress : std_logic_vector (7 downto 0);
    begin
        if rising_edge(clk) then 
            if nrst = '0' then
                -- Here we reset every important variable 
                gclk <= '0';
                iticks <= 0;
                currow <= 0;
                ticks <= 0;
                ison <= '0';
                isable <= '0';
                MOSI <= '1';
                NCS <= '1';
            else
                ticks <= ticks + 1;
                if ticks = divisor then 
                    ticks <= 0;
                    gclk <= not gclk;
                    if gclk = '0' then
                    iticks <= iticks + 1;
                    -- First we turn on the matrix 
                    if ison = '0' then
                        if iticks = 0 then 
                            NCS <= '0';
                            MOSI <= turnon((mwidth-iticks) mod 16);
                        elsif iticks <= mwidth then 
                            MOSI <= turnon((mwidth-iticks) mod 16);
                        elsif iticks = mwidth+1 then 
                            NCS <= '1';
                            ison <= '1';
                            iticks <= 0;
                        end if;

                    -- Then we abilitate multiple rows 
                    elsif isable = '0' then
                        if iticks = 0 then 
                            NCS <= '0';
                            MOSI <= abilitate((mwidth-iticks) mod 16);
                        elsif iticks <= mwidth then 
                            MOSI <= abilitate((mwidth-iticks) mod 16);
                        elsif iticks = mwidth+1 then 
                            NCS <= '1';
                            isable <= '1';
                            iticks <= 0;
                        end if;
                    else
                    -- Here we will implement the rest of he communication 
                    -- with the led matrix 
                    -- The whole communication will consist of 4 states
                    -- state 1 (iticks = 0)
                    --      We put whatever info is in the position signals 
                    --      in the mymatrix variable     
                    -- state 2 (iticks = 1)
                    --      We poll low through the NCS to say to the slave 
                    --      a message is gonna be sent. At the same time we 
                    --      send the first bit of currow
                    -- state 3 (iticks 2 through 9) 
                    --      We send the rest of the bits of the current mymatrix
                    --      row to the slave 
                    -- state 4 (iticks = 10) 
                    --      We poll high through the NCS to end the message
                    -- That's one message sent, we will have to send 8 of them
                    -- (one for each led row). This will be done by adding to a 
                    -- variable called currow each time a message is sent 
                    -- (on state 4)
                    -- Note that the tick values given in this comment are for
                    -- controlling exactly 1 led matrix. These numbers can 
                    -- change depending on the number of matrices used

                    -- state 1 
                        if iticks = 0 then
                        -- We change mymatrix according to the player positions 
                        -- and the ball position
                            -- First we set the address
                            currmessadress := getaddress(currow+1);
                            for mindex in mnumber downto 1 loop
                                for bit in 7 downto 0 loop
                                    mymatrix(currow,7+16*(mindex-1)-bit) := currmessadress(bit);
                                end loop;
                                for bit in 15 downto 8 loop 
                                    mymatrix(currow,16*(mindex-1)+bit) := '0';
                                end loop;

                                for x in 8*mindex-1 downto 8*(mindex-1) loop 
                                    -- Now we check for both of the ball coords
                                    if ballypos = currow and ballxpos = x then
                                        mymatrix(currow,(x mod 8)+8+16*(mindex-1)) := '1'; 
                                    end if;
                                end loop;
                                end loop; 

                                -- Now we check if the players are in this y
                                -- coords
                                if currow >= p1ypos and currow < p1ypos+pheight then
                                    mymatrix(currow,8+pxpos) := '1';
                                end if;

                                if currow >= p2ypos and currow < p2ypos+pheight then
                                    mymatrix(currow,16*mnumber-1-pxpos) := '1';
                                end if;

                    --report "Message " & integer'image(y) & " is " & 
                    --std_logic'image(mymatrix(y,8)) & 
                    --std_logic'image(mymatrix(y,9)) & 
                    --std_logic'image(mymatrix(y,10)) & 
                    --std_logic'image(mymatrix(y,11)) & 
                    --std_logic'image(mymatrix(y,12)) & 
                    --std_logic'image(mymatrix(y,13)) & 
                    --std_logic'image(mymatrix(y,14)) & 
                    --std_logic'image(mymatrix(y,15)); -- &
                    --std_logic'image(mymatrix(y,24)) & 
                    --std_logic'image(mymatrix(y,25)) & 
                    --std_logic'image(mymatrix(y,26)) & 
                    --std_logic'image(mymatrix(y,27)) & 
                    --std_logic'image(mymatrix(y,28)) & 
                    --std_logic'image(mymatrix(y,29)) & 
                    --std_logic'image(mymatrix(y,30)) & 
                    --std_logic'image(mymatrix(y,31));

                        -- state 2
                        elsif iticks = 1 then 
                            NCS <= '0';
                            MOSI <= mymatrix(currow, iticks-1);

                        -- state 3 
                        elsif iticks <= mwidth + 1 then 
                            MOSI <= mymatrix(currow, iticks-1);

                        -- state 4
                        elsif iticks = mwidth + 2 then 
                            NCS <= '1';
                            iticks <= 0;
                            if currow = 7 then 
                                currow <= 0;
                            else 
                                currow <= currow + 1;
                                for i in 0 to 7 loop 
                                    for j in 0 to mwidth loop
                                        mymatrix(i,j) := '0';
                                    end loop;
                                end loop;
                            end if;
                        end if;
                    end if;
                    end if;
                end if;
            end if;
        end if;
    end process;
end architecture;
