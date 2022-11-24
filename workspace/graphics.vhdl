library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity graphics is 
    generic(
    clf : integer
);

port(
    clk : in std_logic;
    nrst : in std_logic;

    p1ypos : in integer := 0;
    p2ypos : in integer := 0;

    ballxpos : in integer := 0;
    ballypos : in integer := 0;

    NCS : out std_logic := '1';
    MOSI : out std_logic := '0';
    gclk : inout std_logic := '0'
);
end entity;

architecture behav of graphics is 
    function getaddress (i : integer) return std_logic_vector is
    begin 
        return std_logic_vector( to_unsigned(i, 8));
    end function;

    signal currow : integer := 0;
    signal ison : std_logic := '0';
    signal isscanning : std_logic := '0';
    signal isndecoding : std_logic := '0';
    constant turnon : std_logic_vector (15 downto 0) := "0000110000000001";
    constant scanon : std_logic_vector (15 downto 0) := "0000101100000111";
    constant decodingoff : std_logic_vector (15 downto 0) := "0000100100000000";

    signal ticks : integer := 0;
    signal iticks : integer := 0;
    constant divisor : integer := 12e3;

    constant screenwidth : integer := 8;    
    constant screenheight : integer := 8;    
    constant pxpos : integer := 1;    
    constant pheight : integer := 3;
    constant mnumber : integer := 2;
    constant mwidth : integer := 16*mnumber-1;
    constant hmwidth : integer := 8*mnumber-1;
begin
    process(clk) is
    type matrix is array (7 downto 0, mwidth downto 0) of std_logic;
    variable mymatrix : matrix ;


    variable currmessadress : std_logic_vector (7 downto 0);
    begin
        if rising_edge(clk) then 
            if nrst = '0' then
                gclk <= '0';
                iticks <= 0;
                currow <= 0;
                ticks <= 0;
                ison <= '0';
                isscanning <= '0';
                isndecoding <= '0';
                MOSI <= '1';
                NCS <= '1';
            else
                ticks <= ticks + 1;
                if ticks = divisor then 
                    ticks <= 0;
                    gclk <= not gclk;
                    if gclk = '0' then
                    iticks <= iticks + 1;
                    if isscanning = '0' then
                        if iticks = 0 then 
                            NCS <= '0';
                            MOSI <= scanon((mwidth-iticks) mod 16);
                        elsif iticks <= mwidth then 
                            MOSI <= scanon((mwidth-iticks) mod 16);
                        elsif iticks = mwidth+1 then 
                            NCS <= '1';
                            isscanning <= '1';
                            iticks <= 0;
                        end if;

                    elsif isndecoding = '0' then
                        if iticks = 0 then 
                            NCS <= '0';
                            MOSI <= decodingoff((mwidth-iticks) mod 16);
                        elsif iticks <= mwidth then 
                            MOSI <= decodingoff((mwidth-iticks) mod 16);
                        elsif iticks = mwidth+1 then 
                            NCS <= '1';
                            isndecoding <= '1';
                            iticks <= 0;
                        end if;

                    elsif ison = '0' then 
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
                    else


                        if iticks = 0 then
                            currmessadress := getaddress(currow+1);
                            for mindex in mnumber downto 1 loop
                                for bit in 7 downto 0 loop
                                    mymatrix(currow,7+16*(mindex-1)-bit) := currmessadress(bit);
                                end loop;
                                for bit in 15 downto 8 loop 
                                    mymatrix(currow,16*(mindex-1)+bit) := '0';
                                end loop;

                                for x in 8*mindex-1 downto 8*(mindex-1) loop 
                                    if ballypos = currow and ballxpos = x then
                                        mymatrix(currow,(x mod 8)+8+16*(mindex-1)) := '1'; 
                                    end if;
                                end loop;
                                end loop; 

                                if currow >= p1ypos and currow < p1ypos+pheight then
                                    mymatrix(currow,8+pxpos) := '1';
                                end if;

                                if currow >= p2ypos and currow < p2ypos+pheight then
                                    mymatrix(currow,16*mnumber-1-pxpos) := '1';
                                end if;

                        elsif iticks = 1 then 
                            NCS <= '0';
                            MOSI <= mymatrix(currow, iticks-1);

                        elsif iticks <= mwidth + 1 then 
                            MOSI <= mymatrix(currow, iticks-1);

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
