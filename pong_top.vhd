library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity pong_top is
    generic (
        -- Screen size --
        width : integer := 0;
        height : integer := 0
        -- Propiedades para el estado del juego --
        apos : out unsigned(7 downto 0) := (others => '0');
        bpos : out unsigned(7 downto 0) := (others => '0');
        dotxpos : out unsigned(7 downto 0) := (others => '0');
        dotypos : out unsigned(7 downto 0) := (others => '0');
        dotxvel : out signed(3 downto 0) := (others => '0');
        dotyvel : out signed(3 downto 0) := (others => '0');
        ascore : out unsigned(2 downto 0) := (others => '0');
        bscore : out unsigned(2 downto 0) := (others => '0') 
    );
    port (
        clk : in std_logic;
        clr : in std_logic;
        
        -- Bit para reiniciar el estado del juego --
        reset : inout signed;
        
        -- Inputs de jugadores --
        aup : in std_logic;
        adown : in std_logic;
        bup : in std_logic;
        bdown : in std_logic
         );
end pong_top;
            
architecture behaviour of pong_top is
    --component
    --    ponglogic
    --    port (
begin
    process is
    begin
        if reset /= 1 then 
            report "reset is pressed";
        else 
            report "reset is not pressed";
        end if;
    end process;
end arzchitecture;
