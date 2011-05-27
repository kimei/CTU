-------------------------------------------------------------------------------
-- Title      : edge_detect.vhd
-- Project    : 
-------------------------------------------------------------------------------
-- File       : edge_detect.vhd
-- Author     :   <kimei@fyspc-epf02>
-- Company    : 
-- Created    : 2011-03-15
-- Last update: 2011-03-21
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: Synchronous trigger part of the CTU in COMPET
-- Main function is to synchronize the input signal to the mclk and create a
-- pulse for one clk cycle if there is a rising edge. 
-------------------------------------------------------------------------------
-- Copyright (c) 2011 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2011-03-08  1.0      kimei   Created
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

library work;
use work.components.all;
use work.constants.all;
use work.functions.all;

entity edge_detector is
  
  port (
    rst_b : in std_logic;
    mclk : in std_logic;
    inp : in std_logic;
    outp : out std_logic);
end edge_detector;

architecture behave of edge_detector is
signal s : std_logic_vector(2 downto 0);
begin  -- behave
 outp <= '1' when ((s(0) = '0') and (s(1) = '1')) else '0';

  latch: process (mclk, rst_b)
  begin  -- process latch
    if rst_b = '0' then
      
      s <=(others => '0');
      
    elsif mclk'event and mclk = '1' then
      s(2) <= inp;
      s(1) <= s(2);
      s(0) <= s(1);

    end if;
  end process latch;

  

end behave;
