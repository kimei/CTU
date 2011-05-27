----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:02:00 04/08/2011 
-- Design Name: 
-- Module Name:    clkgen - Behavioral 
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
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity clkgen is
    Port ( 	 
		CLKIN : in  STD_LOGIC;
      CLKFBIN : in  STD_LOGIC;
      CLKOUT0 :out std_logic;
      CLKOUT1 :out std_logic;
      CLKOUT2 :out std_logic;
      CLKOUT3 :out std_logic;
      CLKOUT4 :out std_logic;
      CLKOUT5 :out std_logic;
		RST : in std_logic;
      LOCKED : out std_logic);
end clkgen;

architecture Behavioral of clkgen is

	COMPONENT pll
	PORT(
		CLKIN1_IN : IN std_logic;
		RST_IN : IN std_logic;          
		CLKOUT0_OUT : OUT std_logic;
		CLKOUT1_OUT : OUT std_logic;
		CLKOUT2_OUT : OUT std_logic;
		CLKOUT3_OUT : OUT std_logic;
		CLKOUT4_OUT : OUT std_logic;
		CLKOUT5_OUT : OUT std_logic;
		LOCKED_OUT : OUT std_logic
		);
	END COMPONENT;

begin

	Inst_pll: pll PORT MAP(
		CLKIN1_IN => CLKIN,
		RST_IN => RST,
		CLKOUT0_OUT => CLKOUT0,
		CLKOUT1_OUT => CLKOUT1,
		CLKOUT2_OUT => CLKOUT2,
		CLKOUT3_OUT => CLKOUT3,
		CLKOUT4_OUT => CLKOUT4,
		CLKOUT5_OUT => CLKOUT5,
		LOCKED_OUT => LOCKED 
	);


end Behavioral;

