library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

entity clkdiv is
Port (mclk : in  STD_LOGIC; 
		clr : in STD_LOGIC;  
		clk48 : out STD_LOGIC);
end clkdiv;

architecture Behavioral of clkdiv is
signal q:std_logic_vector(23 downto 0);
begin
	process(mclk, clr) 
	begin
		if clr = '1' then
			q <= x"000000";
		elsif mclk' event and mclk = '1' then
			q <= q + 1;
		end if;
		clk48 <= q(22);
	end process;
end Behavioral ;