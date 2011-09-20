----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:03:24 09/13/2011 
-- Design Name: 
-- Module Name:    test_comp - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity test_comp is
end test_comp;

architecture Behavioral of test_comp is
signal s1 : unsigned(15 downto 0);
signal s2 : unsigned(15 downto 0);
signal s3 : unsigned(15 downto 0);
signal s4 : unsigned(15 downto 0);
signal s5 : unsigned(15 downto 0);
begin
 s1 <= x"028a";
 s2 <= x"0289";

 s3 <= s1 -s2 + 1;
 s4 <= s2 - s1 + 1;
 s5 <= s1 - s1 + 1;

  
  
  

end Behavioral;

