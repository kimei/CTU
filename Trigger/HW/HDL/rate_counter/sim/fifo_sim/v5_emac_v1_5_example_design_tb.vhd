-------------------------------------------------------------------------------
-- Title      : Testbench for design "v5_emac_v1_5_example_design"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : v5_emac_v1_5_example_design_tb.vhd
-- Author     :   <kimei@fyspc-epf02>
-- Company    : 
-- Created    : 2011-05-20
-- Last update: 2011-05-23
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2011 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2011-05-20  1.0      kimei	Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.components.all;
use work.constants.all;

-------------------------------------------------------------------------------

entity v5_emac_v1_5_example_design_tb is

end v5_emac_v1_5_example_design_tb;

-------------------------------------------------------------------------------

architecture stimuli of v5_emac_v1_5_example_design_tb is

  component v5_emac_v1_5_example_design
    port (
      clk200      : in std_logic;
      rst_b       : in std_logic;
      rate_cards  : in std_logic_vector(NUMBER_OF_ROCS - 1 downto 0);
      coincidence : in std_logic_vector(NUMBER_OF_ROCS - 1 downto 0));
  end component;

  -- component ports
  signal clk200      : std_logic;
  signal rst_b       : std_logic;
  signal rate_cards  : std_logic_vector(NUMBER_OF_ROCS - 1 downto 0);
  signal coincidence : std_logic_vector(NUMBER_OF_ROCS - 1 downto 0);

  -- clock
  signal Clk : std_logic := '1';

begin  -- stimuli

  -- component instantiation
  DUT: v5_emac_v1_5_example_design
    port map (
      clk200      => clk200,
      rst_b       => rst_b,
      rate_cards  => rate_cards,
      coincidence => coincidence);

  -- clock generation
  Clk <= not Clk after 5 ns;
  clk200 <= Clk;

  -- waveform generation
  WaveGen_Proc: process
    begin
   rate_cards <= (others => '0');
   coincidence <= (others => '0');
  rst_b <= '0';
   wait for 40 ns;
    rst_b         <= '1';
    wait for 80 ns;
    rate_cards(0) <= '1';
    wait for 40 ns;
    rate_cards(0) <= '0';
    rate_cards(1) <= '1';
    wait for 20 ns;
    rate_cards(1) <= '0';
    wait for 30 ns;
    coincidence   <= (others => '1');
    wait for 20 ns;
    coincidence   <= (others => '0');


    wait;
  end process WaveGen_Proc;

  

end stimuli;

