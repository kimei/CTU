-------------------------------------------------------------------------------
-- input_bufg_0_wrapper.vhd
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

library input_bufg_v1_00_a;
use input_bufg_v1_00_a.all;

entity input_bufg_0_wrapper is
  port (
    I : in std_logic_vector(0 downto 0);
    O : out std_logic_vector(0 downto 0)
  );

  attribute x_core_info : STRING;
  attribute x_core_info of input_bufg_0_wrapper : entity is "input_bufg_v1_00_a";

end input_bufg_0_wrapper;

architecture STRUCTURE of input_bufg_0_wrapper is

  component input_bufg is
    generic (
      DWIDTH : INTEGER
    );
    port (
      I : in std_logic_vector((DWIDTH-1) downto 0);
      O : out std_logic_vector((DWIDTH-1) downto 0)
    );
  end component;

begin

  input_bufg_0 : input_bufg
    generic map (
      DWIDTH => 1
    )
    port map (
      I => I,
      O => O
    );

end architecture STRUCTURE;

