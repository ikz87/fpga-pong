library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pongtop is 
    generic(
    -- Clock frequency
    clf : integer
           );
    port(
    -- Clock and reset
    clk : in std_logic;
    nrst : in std_logic;
        
    -- Player inputs 
    -- Player 1
    p1up : in std_logic;
    p1down : in std_logic;
        
    -- Player 2 
    p2up : in std_logic;
    p2down : in std_logic);

    -- Position outputs 
    p1ypos : out integer; 
    p2ypos : out integer; 
    ballxpos : out integer;
    ballypos : out integer;

end entity;

architecture rtl of pong is 

    function bittoint (logic : std_logic) return integer is 
        if logic = '1' then
            return 1;
        else
            return 0;
        end if;
    end function;

    -- Counting clock ticks 
    signal ticks : integer;


    -- Screen dimension dependant properties
    constant screenwidth : integer := 128;
    constant screenheight : integer := 64;
    constant playerspeed : integer := 5;
    constant p1xpos : integer := 20;
    constant p2xpos : integer := screenwidth - 20;
    constant pheight : integer := screenwidth / 4;
    variable ballxspeed : integer := 3; 
    variable ballyspeed : integer := 3; 
    variable playerpreypos : integer;
    variable ballprexpos : integer;
    variable ballpreypos : integer;
begin
    process(clk) is 
    begin
        if rising_edge(clk) then
            if nrst = '0' then 
                ticks <= 0;

            else
                -- Update player 1 position
                -- We need to make sure that p1 doesn't go above or below
                -- the screen. If we assume p1ypos to be at the top of the
                -- player bar, we can do the following:
                -- First we calculate the position according to 
                -- speed and inputs into a buffer variable
                playerpreypos := p1ypos - playerspeed * bittoint(p1up)
                                + playerspeed * bittoint(p1down);
                -- Then we make sure the position signal stays between the boundary
                -- of 0 and screenheight - playerheight
                if playerpreypos < 0 then 
                    p1ypos <= 0;
                elsif playerpreypos > screenheight - playerheight then 
                    p1ypos <= screenheight - playerheight;
                else
                    p1ypos <= playerpreypos;
                end if;

                -- Update player 2 position
                -- We do the exact same for player 2
                playerpreypos := p2ypos - playerspeed * bittoint(p1up)
                                + playerspeed * bittoint(p1down);
                if playerpreypos < 0 then 
                    p2ypos <= 0;
                elsif playerpreypos > screenheight - playerheight then 
                    p2ypos <= screenheight - playerheight;
                else
                    p2ypos <= playerpreypos;
                end if;


                -- Update ball position 
                -- This is a little different since we need to  
                -- be able to invert the direction of the ball when it touches
                -- a surface. We will achieve this by first updating and 
                -- normalizing its position as we did with the players, and
                -- recalculating the velocity afterwards

                -- ballypos  
                ballpreypos := ballypos + ballyspeed;

                if ballpreypos < 0 then
                    ballypos <= 0;
                    -- Everytime the ball hits a vertical boundary
                    -- We invert its speed
                    ballyspeed := ballyspeed * -1; 


                ballyspeed := 
                

            end if;
        end if;

        
