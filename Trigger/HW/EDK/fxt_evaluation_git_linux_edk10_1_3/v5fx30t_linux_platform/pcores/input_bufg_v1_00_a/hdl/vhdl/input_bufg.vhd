library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity input_bufg is
	Generic (DWIDTH : integer := 4);
	Port (
		I : in std_logic_vector(DWIDTH-1 downto 0);
		O : out std_logic_vector(DWIDTH-1 downto 0)
		);
end input_bufg;

architecture Behavioral of input_bufg is

begin

IBUF_IP_CORE_GENERATE: for x in 0 to DWIDTH-1 generate
  MULTIPLE_BUFG : BUFG
    port map (I => I(x), O => O(x));
end generate;

end Behavioral;
