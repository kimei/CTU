----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:05:11 02/15/2011 
-- Design Name: 
-- Module Name:    top - Behavioral 
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
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;




entity top is
  port(
    -- Inputs from the board
    FPGA100M : in std_logic;
 --   RESET    : in std_logic;

    -- output to the ROCs

    --clocks and resets
    MCLK100   : out std_logic
    --MCLK100_b : out std_logic
	  );
end top;
architecture Behavioral of top is
  
begin
	 
	mclk100 <= FPGA100M;
	
end Behavioral;




