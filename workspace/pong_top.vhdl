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
    clk : inout std_logic;
    nrst : inout std_logic;
    iclk : inout std_logic;
        
    -- Player inputs 
    -- Player 1
    p1up : in std_logic;
    p1down : in std_logic;
        
    -- Player 2 
    p2up : in std_logic;
    p2down : in std_logic;

    -- Position inoutputs 
    p1ypos : inout integer := 0; 
    p2ypos : inout integer := 0; 
    ballxpos : inout integer := 0;
    ballypos : inout integer := 0);
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

    -- Counting clock ticks 
    signal ticks : integer;
    signal divisor : integer := 100; 


    -- Screen dimension dependant properties
    constant screenwidth : integer := 8;
    constant screenheight : integer := 8;
    constant playerspeed : integer := 1;
    constant pheight : integer := 3;
    constant mnumber : integer := 2; 
    constant p1xpos : integer := 1;
    constant p2xpos : integer := screenwidth*mnumber - 2;

    -- Debugging 
    type ballstates is (moving, collidedleft, collidedup, collidedright,
                        collideddown, respawned);
    signal currballstate : ballstates;
begin
    i_graphics : entity work.graphics(behav)
    generic map (clf => clf)
    port map ( 
        clk => clk,
        nrst => nrst,
        
        p1ypos => p1ypos,
        p2ypos => p2ypos,
        
        ballxpos => ballxpos,
        ballypos => ballypos
    );
    process(clk) is 
        -- Redundant variables to make position calculations instant 
        variable p1preypos : integer;
        variable p2preypos : integer;
        variable ballxspeed : integer := 1; 
        variable ballyspeed : integer := 1; 
        variable ballprexpos : integer;
        variable ballpreypos : integer;
    begin
        if rising_edge(clk) then
            if nrst = '0' then 
                -- Here we reset every important variable
                ticks <= 0;
                p1ypos <= 3;
                p2ypos <= 3;
                ballxpos <= screenwidth*mnumber/2 - 1;
                ballypos <= screenheight/2 - 1;
                currballstate <= moving;
                iclk <= '0';
            else 
                ticks <= ticks + 1;
                if ticks = divisor then 
                    ticks <= 0;
                    iclk <= not iclk;
                    if iclk = '0' then
                    -- Update player 1 position
                    -- We need to make sure that p1 doesn't go above or below
                    -- the screen. If we assume p1ypos to be at the top of the
                    -- player bar, we can do the following:
                    -- First we calculate the position according to 
                    -- speed and inputs into a buffer variable
                    p1preypos := p1ypos - playerspeed * bittoint(p1up)
                    + playerspeed * bittoint(p1down);
                    -- Then we make sure the position signal stays between the 
                    -- boundary of 0 and screenheight - pheight
                    if p1preypos < 0 then 
                        p1preypos := 0;
                    elsif p1preypos > screenheight - 1 - pheight then 
                        p1preypos := screenheight - 1 - pheight;
                    end if;

                    -- Update player 2 position
                    -- We do the exact same for player 2
                    p2preypos := p2ypos - playerspeed * bittoint(p2up)
                    + playerspeed * bittoint(p2down);
                    if p2preypos < 0 then 
                        p2preypos := 0;
                    elsif p2preypos > screenheight - 1 - pheight then 
                        p2preypos := screenheight - 1 - pheight;
                    end if;


                    -- Update ball position 
                    -- This is a little different since we need to  
                    -- be able to invert the direction of the ball when it touches
                    -- a surface. We will achieve this by first updating and 
                    -- normalizing its position as we did with the players, and
                    -- recalculating the velocity afterwards
                    -- We start with the y position
                    ballpreypos := ballypos + ballyspeed;

                    currballstate <= moving;

                    if ballpreypos < 0 then
                        ballpreypos := 0;
                        -- Everytime the ball hits a vertical boundary
                        -- we invert its y speed
                        ballyspeed := - ballyspeed; 
                        currballstate <= collidedup;
                    elsif ballpreypos > screenheight - 1 then
                        ballpreypos := screenheight - 1;
                        ballyspeed := - ballyspeed; 
                        currballstate <= collideddown;
                    end if;

                    -- If the ball hasn't collided with any boundaries
                    -- we just leave the speed as it is
                    -- As for the X position, the boundary check is a bit 
                    -- more complex since it depends on both the ball's x 
                    -- position and either of the players y position 
                    -- Focusing in the case for the leftmost boundary (player 1)
                    -- we will first check if the ball is about to enter the 
                    -- region behind the player
                    ballprexpos := ballxpos + ballxspeed;

                    if ballprexpos <= p1xpos and ballprexpos > p1xpos + ballxspeed then 
                        -- Here we have confirmed that the ball is about to 
                        -- get behind our player, so we now check if the player
                        -- is in place to stop it 
                        if ballpreypos >= p1preypos and 
                        ballpreypos <= p1preypos + pheight then 
                            -- Now we handle the collision similarly as 
                            -- we did before
                            ballprexpos := p1xpos + 1; 
                            ballxspeed := - ballxspeed;
                            currballstate <= collidedleft;
                        end if;
                    elsif ballprexpos < 0 then
                        -- If the ball hits the edge of the screen we reset it to the
                        -- center and flip its speed
                        ballprexpos := screenwidth*mnumber / 2 - 1;
                        -- ballpreypos := screenheight*mnumber / 2 - 1;
                        ballxspeed := -ballxspeed;
                        currballstate <= respawned;
                    end if;

                    -- Now we handle collisions for player 2 in the same manner
                    if ballprexpos >= p2xpos and ballprexpos < p2xpos + ballxspeed then 
                        if ballpreypos >= p2preypos and 
                        ballpreypos <= p2preypos + pheight - 1 then 
                            ballprexpos := p2xpos - 1; 
                           ballxspeed := - ballxspeed;
                            currballstate <= collidedright;
                        end if;
                    elsif ballprexpos > screenwidth*mnumber - 1 then
                    ballprexpos := screenwidth*mnumber / 2 - 1;
                    -- ballpreypos := screenheight*mnumber / 2;
                    ballxspeed := -ballxspeed;
                    currballstate <= respawned;
                    end if;

                -- Now we pass the information in our buffers to the signals
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
