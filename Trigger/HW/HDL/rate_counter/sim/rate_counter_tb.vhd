-------------------------------------------------------------------------------
-- Title      : Testbench for design "rate_counter"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : rate_counter_tb.vhd
-- Author     :   <kimei@fyspc-epf02>
-- Company    : 
-- Created    : 2011-05-20
-- Last update: 2011-05-20
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2011 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2011-05-20  1.0      kimei   Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.components.all;
use work.constants.all;

-------------------------------------------------------------------------------

entity rate_counter_tb is

end rate_counter_tb;

-------------------------------------------------------------------------------

architecture stimuli of rate_counter_tb is

  component rate_counter
    port (
      clk         : in  std_logic;
      rst_b       : in  std_logic;
      rate_cards  : in  std_logic_vector(NUMBER_OF_ROCS-1 downto 0);
      coincidence : in  std_logic_vector(NUMBER_OF_ROCS-1 downto 0);
      we          : out std_logic;
      we_others   : in  std_logic;
      fifo_empty  : in  std_logic;
      din         : out std_logic_vector(7 downto 0));
  end component;

  -- component ports
  signal fifo_empty : std_logic;
  signal clk         : std_logic;
  signal rst_b       : std_logic;
  signal rate_cards  : std_logic_vector(NUMBER_OF_ROCS-1 downto 0);
  signal coincidence : std_logic_vector(NUMBER_OF_ROCS-1 downto 0);
  signal we          : std_logic;
  signal we_others   : std_logic;
  signal din         : std_logic_vector(7 downto 0);

  -- clock
  signal clk_s : std_logic := '1';

begin  -- tb_rate_counter

  -- component instantiation
  DUT : rate_counter
    port map (
      clk         => clk,
      rst_b       => rst_b,
      rate_cards  => rate_cards,
      coincidence => coincidence,
      we          => we,
      fifo_empty => fifo_empty,
      we_others   => we_others,
      din         => din);

  -- clock generation
  clk_s <= not clk_s after 10 ns;

  clk <= clk_s;

  -- waveform generation
  WaveGen_Proc : process
  begin
    fifo_empty <= '1';
    we_others <= '0';
    rate_cards    <= (others => '0');
    coincidence   <= (others => '0');
    rst_b         <= '0';
    wait for 20 ns;
    rst_b         <= '1';
    wait for 40 ns;
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


