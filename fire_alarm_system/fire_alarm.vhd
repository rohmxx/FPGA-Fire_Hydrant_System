library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.all;

entity fire_alarm is
	port(	button: in std_logic;
			clr: in std_logic;
			clk: in std_logic;
			fire: in std_logic;
			sensor: out std_logic;
			alarm: out std_logic;
			hydrant: out std_logic;
			a_to_g : out STD_LOGIC_VECTOR (6 downto 0);
			an  : out STD_LOGIC_VECTOR (3 downto 0);
			dp  : out STD_LOGIC);
end fire_alarm;

architecture Behavioral of fire_alarm is
	component clkdiv is
			port( mclk : in std_logic;
					clr : in std_logic;
					clk48: out std_logic
				 );
	end component;
	component x7segb is 
			port ( x : in STD_LOGIC_VECTOR (15 downto 0);
					 clk : in STD_LOGIC;
					 clr : in STD_LOGIC;
					 a_to_g : out STD_LOGIC_VECTOR (6 downto 0);
					 an : out STD_LOGIC_VECTOR (3 downto 0);
					 dp : out STD_LOGIC );
	end component;
	type state_type is (disarm,arm,intrution);
	signal state: state_type;
	signal clk48: std_logic;
	signal x: std_logic_vector(15 downto 0);
	
begin

	u1: clkdiv port map(
		mclk => clk,
		clr => clr,
		clk48 => clk48
		);
	
	process(button, fire, clk48)
	begin
		if clr='1' then 
			state <= disarm;
		elsif clk48' event and clk48='1' then
			case state is
				when disarm =>	if button = '1' then state <= arm;
									else state <= disarm;
									end if;
				when arm =>	if button = '0' and fire = '1' then state <= intrution;
								elsif button = '1' and fire = '0' then state <= disarm;
								else state <= arm;
								end if;
				when intrution =>	if button = '0' and fire = '1' then state <= intrution;
										elsif button = '1' and fire = '0' then state <= disarm;
										else state <= intrution;
										end if;
			end case;
			sensor <= fire;
		end if;
	end process;
	
	process(state, fire, clk48)
	begin
		case state is
			when disarm => alarm <= '0'; hydrant <= '0'; x <= "0000000100110011";
			when arm => alarm <= '0'; hydrant <= '0'; x <= "0000000000010010";
			when intrution => if fire = '1' then alarm <= '1'; hydrant <= '1';
									else alarm <= '1'; hydrant <= '0';
									end if;
		end case;
	end process;
	
	u2 : x7segb port map 
			(x=>x, clk=>clk48, clr=>clr, a_to_g=>a_to_g, an=>an, dp=>dp);
	
end Behavioral;

