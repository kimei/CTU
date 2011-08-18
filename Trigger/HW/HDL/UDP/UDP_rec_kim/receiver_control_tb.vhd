-------------------------------------------------------------------------------
-- Title      : Testbench for design "receiver_control"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : receiver_control_tb.vhd
-- Author     : Kim-Eigard  <kimei@COMPETReadout003>
-- Company    : 
-- Created    : 2011-08-17
-- Last update: 2011-08-17
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2011 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2011-08-17  1.0      kimei	Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity receiver_control_tb is

end receiver_control_tb;

-------------------------------------------------------------------------------

architecture tb of receiver_control_tb is

  component receiver_control
    port (
      clk                 : in  std_logic;
      rst_b               : in  std_logic;
      udp_data_in         : in  std_logic_vector(15 downto 0);
      valid_data          : in  std_logic;
      port_number         : in  std_logic;
      mrst_from_udp_b     : out std_logic;
      send_fifo_we        : out std_logic;
      send_fifo_we_others : in  std_logic;
      send_fifo_empty     : in  std_logic;
      send_fifo_data_in   : out std_logic_vector(7 downto 0));
  end component;

  -- component ports
  signal clk                 : std_logic;
  signal rst_b               : std_logic;
  signal udp_data_in         : std_logic_vector(7 downto 0);
  signal valid_data          : std_logic;
  signal port_number         : std_logic;
  signal mrst_from_udp_b     : std_logic;
  signal send_fifo_we        : std_logic;
  signal send_fifo_we_others : std_logic;
  signal send_fifo_empty     : std_logic;
  signal send_fifo_data_in   : std_logic_vector(7 downto 0);

  -- clock
  signal Clk_s : std_logic := '1';

begin  -- tb

  -- component instantiation
  DUT: receiver_control
    port map (
      clk                 => clk,
      rst_b               => rst_b,
      udp_data_in         => udp_data_in,
      valid_data          => valid_data,
      port_number         => port_number,
      mrst_from_udp_b     => mrst_from_udp_b,
      send_fifo_we        => send_fifo_we,
      send_fifo_we_others => send_fifo_we_others,
      send_fifo_empty     => send_fifo_empty,
      send_fifo_data_in   => send_fifo_data_in);

  -- clock generation
  Clk_s <= not Clk_s after 5 ns;

  clk <= Clk_s;

  reset_proc :process
    begin
      rst_b <= '0';
      wait for 40 ns;
      rst_b <= '1';
      wait;
    end process reset_proc;
  
  -- waveform generation
  WaveGen_Proc: process
  begin
     valid_data <= '0';
    udp_data_in <= x"00";
    send_fifo_we_others <= '0';
     wait for 198 ns;
     udp_data_in <= x"72";
    wait for 2 ns;
    valid_data <= '1';
    wait for 10 ns;
     valid_data <= '0';
     wait for 2 ns;
    valid_data <= '0';
    udp_data_in <= x"00";
    wait for 200 ns;
  end process WaveGen_Proc;

  

end tb;
