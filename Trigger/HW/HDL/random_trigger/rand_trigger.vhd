-------------------------------------------------------------------------------
-- Title      : Sync Trigger
-- Project    : Source files in two directories, custom library name, VHDL'87
-------------------------------------------------------------------------------
-- File       : Sync_trigger.vhd
-- Author     :   <kimei@fyspc-epf02>
-- Company    : 
-- Created    : 2011-03-08
-- Last update: 2011-09-15
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: Random trigger part of the CTU in COMPET
-- This module will generate random triggers in the rate of 1 khz, each trigger
-- will be 3 clk cycles long.
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
use ieee.numeric_std.all;  --! Numeric/arithmetical logic (IEEE standard)

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

library work;
use work.constants.all;
use work.functions.all;

entity rand_trigger is
  port (
    rst_b       : in  std_logic;
    mclk        : in  std_logic;
    trigger_out : out std_logic_vector(NUMBER_OF_ROCS-1 downto 0));
end rand_trigger;

architecture Behavioral of rand_trigger is
  
  signal counter : unsigned(16 downto 0);
begin
  -- purpose: generate random triggers 3 clk cycles wide
  rand_triggers : process (mclk, rst_b)
  begin  -- process rand_triggers
    if rst_b = '0' then                   -- asynchronous reset (active low)
      counter     <= (others => '0');
      trigger_out <= (others => '0');
    elsif mclk'event and mclk = '1' then  -- rising clock edge
      counter     <= counter + 1;
      trigger_out <= (others => '0');
      if counter = 997 then
        trigger_out <= (others => '1');
        trigger_out <= (others => '1');
      elsif counter = 998 then
        trigger_out <= (others => '1');
        trigger_out <= (others => '1');
      elsif counter = 999 then
        trigger_out <= (others => '1');
        counter     <= (others => '0');
      end if;
    end if;
  end process rand_triggers;
  
end Behavioral;
