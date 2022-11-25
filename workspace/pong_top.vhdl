library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pongtop is 
    generic(
    clf : integer := 50e6
           );
    port(
    clk : inout std_logic;
    nrst : inout std_logic;
        
    p1up : in std_logic;
    p1down : in std_logic;
        
    p2up : in std_logic;
    p2down : in std_logic;

    NCS : out std_logic := '1';
    MOSI : out std_logic := '0';
    gclk : inout std_logic := '0');
end entity;

architecture behav of pongtop is 
    function bittoint (logic : std_logic) return integer is 
    begin
        if logic = '1' then
            return 1;
        else
            return 0;
        end if;
    end function;

    signal ticks : integer := 0;
    signal iclk : std_logic := '0';
    signal divisor : integer := 50e5; 


    constant screenwidth : integer := 8;
    constant screenheight : integer := 8;
    constant playerspeed : integer := 1;
    constant pheight : integer := 3;
    constant mnumber : integer := 2; 
    constant p1xpos : integer := 1;
    constant p2xpos : integer := screenwidth*mnumber - 2;

    signal p1ypos : integer := 0;     
    signal p2ypos : integer := 0;     
    signal ballxpos : integer := 0;    
    signal ballypos : integer := 0; 

begin
    i_graphics : entity work.graphics(behav)
    generic map (clf => clf)
    port map ( 
        clk => clk,
        nrst => nrst,
        
        p1ypos => p1ypos,
        p2ypos => p2ypos,
        
        ballxpos => ballxpos,
        ballypos => ballypos,

        NCS => NCS,
        MOSI => MOSI,
        gclk => gclk
    );
    process(clk) is 
        variable p1preypos : integer;
        variable p2preypos : integer;
        variable ballxspeed : integer := 1; 
        variable ballyspeed : integer := 1; 
        variable ballprexpos : integer;
        variable ballpreypos : integer;
    begin
        if rising_edge(clk) then
            if nrst = '0' then 
                ticks <= 0;
                p1ypos <= 3;
                p2ypos <= 3;
                ballxpos <= screenwidth*mnumber/2 - 1;
                ballypos <= screenheight/2 - 1;
                iclk <= '0';
            else 
                ticks <= ticks + 1;
                if ticks = divisor then 
                    ticks <= 0;
                    iclk <= not iclk;
                    if iclk = '0' then
                    p1preypos := p1ypos - playerspeed * bittoint(p1up)
                    + playerspeed * bittoint(p1down);
                    if p1preypos < 0 then 
                        p1preypos := 0;
                    elsif p1preypos > screenheight - pheight then 
                        p1preypos := screenheight - pheight;
                    end if;

                    p2preypos := p2ypos - playerspeed * bittoint(p2up)
                    + playerspeed * bittoint(p2down);
                    if p2preypos < 0 then 
                        p2preypos := 0;
                    elsif p2preypos > screenheight - pheight then 
                        p2preypos := screenheight - pheight;
                    end if;


                    ballpreypos := ballypos + ballyspeed;


                    if ballpreypos < 0 then
                        ballpreypos := 1;
                        ballyspeed := - ballyspeed; 
                    elsif ballpreypos > screenheight - 1 then
                        ballpreypos := screenheight - 2;
                        ballyspeed := - ballyspeed; 
                    end if;

                    ballprexpos := ballxpos + ballxspeed;

                    if ballprexpos <= p1xpos and ballprexpos > p1xpos + ballxspeed then 
                        if ballpreypos >= p1preypos and 
                        ballpreypos <= p1preypos + pheight then 
                            ballprexpos := p1xpos + 1; 
                            ballxspeed := - ballxspeed;
                        end if;
                    elsif ballprexpos < 0 then
                        ballprexpos := screenwidth*mnumber / 2 - 1;
                        ballxspeed := -ballxspeed;
                    end if;

                    if ballprexpos >= p2xpos and ballprexpos < p2xpos + ballxspeed then 
                        if ballpreypos >= p2preypos and 
                        ballpreypos <= p2preypos + pheight - 1 then 
                            ballprexpos := p2xpos - 1; 
                            ballxspeed := - ballxspeed;
                        end if;
                    elsif ballprexpos > screenwidth*mnumber - 1 then
                    ballprexpos := screenwidth*mnumber / 2 - 1;
                    ballxspeed := -ballxspeed;
                    end if;

                p1ypos <= p1preypos;
                p2ypos <= p2preypos;
                ballxpos <= ballprexpos;
                ballypos <= ballpreypos;
            end if;
                end if;
            end if;
        end if;
    end process;
end architecture;
