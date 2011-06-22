library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SwitchDebouncer is
	generic (CLK_FREQ			: positive;
				NUM_SWITCHES	: positive);
	port (	clk				: in	std_logic;
				reset				: in	std_logic;
				switchesIn		: in	std_logic_vector(NUM_SWITCHES-1 downto 0);
				switchesOut		: out	std_logic_vector(NUM_SWITCHES-1 downto 0));
end SwitchDebouncer;

architecture Structural of SwitchDebouncer is

	signal sample	: std_logic;

begin

SampleGen : process(clk, reset)
	constant SAMPLE_COUNT_MAX	: integer := (CLK_FREQ / 2000) - 1;	-- 500 us
	variable counter				: integer range 0 to SAMPLE_COUNT_MAX;
begin
	if (reset='0') then
			sample	<= '0';
			counter	:= 0;

	elsif (clk'event and clk='1') then
			if (counter=SAMPLE_COUNT_MAX) then
				counter	:= 0;
				sample	<= '1';

			else
				sample	<= '0';
				counter	:= counter + 1;

			end if;
	end if;
end process;

DebounceGen : for sw in 0 to NUM_SWITCHES-1 generate
	constant PULSE_COUNT_MAX	: integer := 20;
	signal sync						: std_logic_vector(1 downto 0);
	signal counter					: integer range 0 to PULSE_COUNT_MAX;
begin

	Debounce : process(clk, reset)
	begin
	
	if (reset='0') then
				sync					<= (others => '0');
				counter				<= 0;
				switchesOut(sw)	<= '0';
	elsif (clk'event and clk='1') then
			

			
				sync <= sync(0) & switchesIn(sw);

				if (sync(1)='0') then		-- Switch not pressed
					counter <= 0;
					switchesOut(sw) <= '0';

				elsif(sample = '1') then	-- Switch pressed
					if (counter=PULSE_COUNT_MAX) then
						switchesOut(sw) <= '1';
					else
						counter <= counter + 1;
					end if;

				end if;
		end if;
	end process;

end generate;

end Structural;
