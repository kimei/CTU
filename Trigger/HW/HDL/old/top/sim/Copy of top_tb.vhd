-------------------------------------------------------------------------------
-- Title      : Testbench for design "top"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : top_tb.vhd
-- Author     :   <kimei@fyspc-epf02>
-- Company    : 
-- Created    : 2011-03-25
-- Last update: 2011-03-25
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2011 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2011-03-25  1.0      kimei   Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library UNISIM;
use UNISIM.VComponents.all;

library work;
use work.components.all;
use work.constants.all;
use work.functions.all;

-------------------------------------------------------------------------------

entity top_tb is

end top_tb;

-------------------------------------------------------------------------------

architecture tb of top_tb is

  component top
    port (
      FPGA100M           : in  std_logic;
      RESET              : in  std_logic;
      MCLK100            : out std_logic;
      MCLK100_b          : out std_logic;
      RESET_ROC_B        : out std_logic;
      RESET_ROC_B_b      : out std_logic;
      SYNC_TRIGGER_OUT   : out std_logic_vector(NUMBER_OF_MODULES-1 downto 0);
      SYNC_TRIGGER_OUT_b : out std_logic_vector(NUMBER_OF_MODULES-1 downto 0);
      SYNC_TRIGGER_IN    : in  std_logic_vector(NUMBER_OF_ROCS-1 downto 0);
      SYNC_TRIGGER_IN_b  : in  std_logic_vector(NUMBER_OF_ROCS-1 downto 0);
      test_led           : out std_logic;
      test_led2          : out std_logic;
      tx                 : out std_logic;
      rx                 : in  std_logic);
  end component;

  -- component ports
  signal FPGA100M           : std_logic;
  signal RESET              : std_logic;
  signal MCLK100            : std_logic;
  signal MCLK100_b          : std_logic;
  signal RESET_ROC_B        : std_logic;
  signal RESET_ROC_B_b      : std_logic;
  signal SYNC_TRIGGER_OUT   : std_logic_vector(NUMBER_OF_MODULES-1 downto 0);
  signal SYNC_TRIGGER_OUT_b : std_logic_vector(NUMBER_OF_MODULES-1 downto 0);
  signal SYNC_TRIGGER_IN    : std_logic_vector(NUMBER_OF_ROCS-1 downto 0);
  signal SYNC_TRIGGER_IN_b  : std_logic_vector(NUMBER_OF_ROCS-1 downto 0);
  signal test_led           : std_logic;
  signal test_led2          : std_logic;
  signal tx                 : std_logic;
  signal rx                 : std_logic;

  -- clock
  signal Clk : std_logic := '1';

begin  -- tb_top



  -- component instantiation
  DUT : top
    port map (
      FPGA100M           => FPGA100M,
      RESET              => RESET,
      MCLK100            => MCLK100,
      MCLK100_b          => MCLK100_b,
      RESET_ROC_B        => RESET_ROC_B,
      RESET_ROC_B_b      => RESET_ROC_B_b,
      SYNC_TRIGGER_OUT   => SYNC_TRIGGER_OUT,
      SYNC_TRIGGER_OUT_b => SYNC_TRIGGER_OUT_b,
      SYNC_TRIGGER_IN    => SYNC_TRIGGER_IN,
      SYNC_TRIGGER_IN_b  => SYNC_TRIGGER_IN_b,
      test_led           => test_led,
      test_led2          => test_led2,
      tx                 => tx,
      rx                 => rx);

  -- clock generation
  Clk      <= not Clk after 5 ns;
  FPGA100M <= Clk;

  -- waveform generation
  WaveGen_Proc : process
  begin
    
    RESET             <= '1';
    SYNC_TRIGGER_IN   <= (others => '0');
    SYNC_TRIGGER_IN_b <= (others => '1');
    wait for 20 ns;
    RESET             <= '0';
    wait for 3 ns;
    wait for 300 us;
    SYNC_TRIGGER_IN   <= (others => '1');
    SYNC_TRIGGER_IN_b <= (others => '0');
    wait for 30 ns;
    SYNC_TRIGGER_IN   <= (others => '0');
    SYNC_TRIGGER_IN_b <= (others => '1');

    wait;
  end process WaveGen_Proc;

  

end tb;
