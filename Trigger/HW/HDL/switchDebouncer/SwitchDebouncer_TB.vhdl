library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SwitchDebouncer_TB is
end SwitchDebouncer_TB;

architecture TestBench of SwitchDebouncer_TB is

	constant SYS_CLK_FREQ	: real := 50.0; -- MHz
	constant SYS_CLK_PERIOD	: time := 1 us / SYS_CLK_FREQ;

	component SwitchDebouncer is
		generic (CLK_FREQ			: positive;
					NUM_SWITCHES	: positive);
		port (	clk				: in	std_logic;
					reset				: in	std_logic;
					switchesIn		: in	std_logic_vector(NUM_SWITCHES-1 downto 0);
					switchesOut		: out	std_logic_vector(NUM_SWITCHES-1 downto 0));
	end component;

	signal clk				: std_logic;
	signal reset			: std_logic;
	signal switchesIn		: std_logic_vector(2 downto 0);
	signal switchesOut	: std_logic_vector(2 downto 0);

begin

Clock : process
begin
	clk <= '0';
	wait for SYS_CLK_PERIOD/2;
	clk <= '1';
	wait for SYS_CLK_PERIOD/2;
end process;

UUT : SwitchDebouncer
generic map(CLK_FREQ			=> 50000000,
				NUM_SWITCHES	=> 3)
port map(	clk				=> clk,
				reset				=> reset,
				switchesIn		=> switchesIn,
				switchesOut		=> switchesOut);

Sw1 : process
begin
	switchesIn(0) <= '0';
	wait for 20 ms;

	for i in 0 to 5
	loop
		switchesIn(0) <= '1';
		wait for 1 ms;
		switchesIn(0) <= '0';
		wait for 1 ms;
	end loop;

	switchesIn(0) <= '1';
	wait for 20 ms;

	for i in 0 to 5
	loop
		switchesIn(0) <= '0';
		wait for 1 ms;
		switchesIn(0) <= '1';
		wait for 1 ms;
	end loop;

end process;

TB : process
begin
	reset <= '1';

	switchesIn(1) <= '0';
	switchesIn(2) <= '0';

	wait for 100 us;
	wait until (clk'event and clk='1');

	reset <= '0';

	wait;

end process;

end TestBench;
