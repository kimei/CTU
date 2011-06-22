library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SwitchDebouncerFPGATest is
	port (	clkIn			: in	std_logic;
				resetButton	: in	std_logic;
				switchesIn	: in	std_logic_vector(2 downto 0);
				switchesOut	: out	std_logic_vector(2 downto 0);
				seg			: out	std_logic_vector(6 downto 0);
				dp				: out	std_logic;
				an				: out	std_logic_vector(3 downto 0));
end SwitchDebouncerFPGATest;

architecture Test of SwitchDebouncerFPGATest is

	-- LOCs for Digilent Spartan-3E Development Board
	attribute LOC : string;
	attribute LOC of clkIn			: signal is "B8";					-- 50MHz
	attribute LOC of resetButton	: signal is "H13";				-- BTN3
	attribute LOC of switchesIn	: signal is "E18 D18 B18";		-- BTN2 BTN1 BTN0
	attribute LOC of switchesOut	: signal is "K15 J15 J14";		-- LED2 LED1 LED0

	attribute LOC of seg				: signal is "L18 F18 D17 D16 G14 J17 H14";
	attribute LOC of dp				: signal is "C17";
	attribute LOC of an				: signal is "F15 C18 H17 F17";

	component SwitchDebouncer is
		generic (CLK_FREQ			: positive;
					NUM_SWITCHES	: positive);
		port (	clk				: in	std_logic;
					reset				: in	std_logic;
					switchesIn		: in	std_logic_vector(NUM_SWITCHES-1 downto 0);
					switchesOut		: out	std_logic_vector(NUM_SWITCHES-1 downto 0));
	end component;

	component SimpleSevenSegDriver is
	port (	clk				: in	std_logic;
				reset				: in	std_logic;
				digit0			: in	std_logic_vector(3 downto 0);
				digit1			: in	std_logic_vector(3 downto 0);
				digit2			: in	std_logic_vector(3 downto 0);
				digit3			: in	std_logic_vector(3 downto 0);
				dpIn				: in	std_logic_vector(3 downto 0);
				seg				: out	std_logic_vector(6 downto 0);
				dp					: out	std_logic;
				an					: out	std_logic_vector(3 downto 0));
	end component;

	signal swOut	: std_logic_vector(2 downto 0);
	signal sw0_d	: std_logic;
	signal sw1_d	: std_logic;
	signal counter	: std_logic_vector(15 downto 0);

begin

switchesOut <= swOut;

UUT : SwitchDebouncer
generic map(CLK_FREQ			=> 50000000,
				NUM_SWITCHES	=> 3)
port map(	clk				=> clkIn,
				reset				=> resetButton,
				switchesIn		=> switchesIn,
				switchesOut		=> swOut);

Display : SimpleSevenSegDriver
port map (	clk		=> clkIn,
				reset		=> resetButton,
				digit0	=> counter(3 downto 0),
				digit1	=> counter(7 downto 4),
				digit2	=> counter(11 downto 8),
				digit3	=> counter(15 downto 12),
				dpIn		=> "0000",
				seg		=> seg,
				dp			=> dp,
				an			=> an);

CounterControl : process(clkIn)
begin
	if (clkIn'event and clkIn='1') then
		if (resetButton = '1') then
			counter	<= (others => '0');
			sw0_d		<= '0';
			sw1_d		<= '0';
		else
			sw0_d <= swOut(0);
			sw1_d <= swOut(1);

			if (swOut(0)='1' and sw0_d='0') then
				counter <= std_logic_vector(unsigned(counter) + 1);

			elsif (swOut(1)='1' and sw1_d='0') then
				counter <= std_logic_vector(unsigned(counter) - 1);

			end if;
		end if;
	end if;
end process;

end Test;
