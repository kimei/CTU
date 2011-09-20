-------------------------------------------------------------------------------
-- Title      : Testbench for design "async_trigger"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : async_trigger_tb.vhd
-- Author     : Kim-Eigard  <kimei@COMPETReadout003>
-- Company    : 
-- Created    : 2011-08-26
-- Last update: 2011-09-05
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2011 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2011-08-26  1.0      kimei	Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity async_trigger_tb is

end async_trigger_tb;

-------------------------------------------------------------------------------

architecture sim of async_trigger_tb is

  component async_trigger
    port (
      clk                 : in  std_logic;
      clk100              : in  std_logic;
      rst_b               : in  std_logic;
      rocs_reset_b        : in  std_logic;
      udp_data_in         : in  std_logic_vector(7 downto 0);
      valid_data          : in  std_logic;
      port_number         : in  std_logic_vector(15 downto 0);
      sender_ip           : in  std_logic_vector(7 downto 0);
      send_fifo_we        : out std_logic;
      send_fifo_we_others : in  std_logic;
      send_fifo_empty     : in  std_logic;
      send_fifo_data_in   : out std_logic_vector(7 downto 0));
  end component;

  -- component ports
  signal clk                 : std_logic;
  signal clk100              : std_logic;
  signal rst_b               : std_logic;
  signal rocs_reset_b        : std_logic;
  signal udp_data_in         : std_logic_vector(7 downto 0);
  signal valid_data          : std_logic;
  signal port_number         : std_logic_vector(15 downto 0);
  signal sender_ip           : std_logic_vector(7 downto 0);
  signal send_fifo_we        : std_logic;
  signal send_fifo_we_others : std_logic;
  signal send_fifo_empty     : std_logic;
  signal send_fifo_data_in   : std_logic_vector(7 downto 0);

  -- clock
  signal Clk_100 : std_logic := '1';
  signal Clk_125 : std_logic := '1';

begin  -- sim

  -- component instantiation
  DUT: async_trigger
    port map (
      clk                 => clk,
      clk100              => clk100,
      rst_b               => rst_b,
      rocs_reset_b        => rocs_reset_b,
      udp_data_in         => udp_data_in,
      valid_data          => valid_data,
      port_number         => port_number,
      sender_ip           => sender_ip,
      send_fifo_we        => send_fifo_we,
      send_fifo_we_others => send_fifo_we_others,
      send_fifo_empty     => send_fifo_empty,
      send_fifo_data_in   => send_fifo_data_in);

  -- clock generation

  Clk_100 <= not Clk_100 after 5 ns;
  Clk_125 <= not Clk_125 after 4 ns;
  clk <= Clk_125;
  clk100 <= Clk_100;

  -- waveform generation
  WaveGen_Proc: process
  begin
    valid_data <= '0';
    port_number <= (others => '0');
    sender_ip <= (others => '0');
    send_fifo_we_others <= '0';
    send_fifo_empty <= '1';
    rst_b <= '0';
    rocs_reset_b <= '0';
    wait for 40 ns;
    rst_b <= '1';
    rocs_reset_b <= '1';
   
    wait for 119 ns;
    valid_data <= '1';
    sender_ip <= X"22";
    udp_data_in <=  X"00";
    wait for 1 ns;
    wait for 8 ns;
    udp_data_in <= X"00";
    wait for 8 ns;
    udp_data_in <= X"FF";
    wait for 8 ns;
    udp_data_in <= X"FF";
    wait for 8 ns;
    valid_data <= '0';
    sender_ip <= X"00";
    udp_data_in <= X"00";        
    wait for 39 ns;
     valid_data <= '1';
    sender_ip <= X"23";
    udp_data_in <= X"d5";
    wait for 1 ns;
    wait for 8 ns;
    udp_data_in <= X"88";
    wait for 8 ns;
    udp_data_in <= X"ad";
    wait for 8 ns;
    udp_data_in <= X"ae";
    wait for 8 ns;
    valid_data <= '0';
    sender_ip <= X"00";
    udp_data_in <= X"00";  
     wait;
    
  end process WaveGen_Proc;

  

end sim;

-------------------------------------------------------------------------------

configuration async_trigger_tb_sim_cfg of async_trigger_tb is
  for sim
  end for;
end async_trigger_tb_sim_cfg;

-------------------------------------------------------------------------------
