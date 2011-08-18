-------------------------------------------------------------------------------
-- Title      : Testbench for design "udp_rec"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : udp_rec_tb.vhd
-- Author     : Kim-Eigard  <kimei@COMPETReadout003>
-- Company    : 
-- Created    : 2011-08-15
-- Last update: 2011-08-16
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2011 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2011-08-15  1.0      kimei   Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;

-------------------------------------------------------------------------------

entity udp_rec_tb is

end udp_rec_tb;

-------------------------------------------------------------------------------

architecture tb of udp_rec_tb is

  component udp_rec
    port (
      clk                : in  std_logic;
      rst_b              : in  std_logic;
      usr_data_input_bus : in  std_logic_vector(7 downto 0);
      valid_out_usr_data : in  std_logic;
      data_out           : out std_logic_vector(7 downto 0);
      valid_data         : out std_logic;
      port_number        : out std_logic_vector(15 downto 0));
  end component;

  -- component ports
  signal clk                : std_logic;
  signal rst_b              : std_logic;
  signal usr_data_input_bus : std_logic_vector(7 downto 0);
  signal valid_out_usr_data : std_logic;
  signal data_out           : std_logic_vector(7 downto 0);
  signal valid_data         : std_logic;
  signal port_number        : std_logic_vector(15 downto 0);

  -- clock
  signal lClk : std_logic := '1';


  procedure read_v1d (
    variable f : in text; v : out std_logic_vector) is
    variable buf : line;
    variable c   : character;
  begin
    readline(f, buf);
    for i in 0 to 1 loop
      read(buf, c);
      case c is
        when '0'    => v(0+4*i to 3+4*i)   := "0000";
        when '1'    => v(0+4*i to 3+4*i) := "0001";
        when '2'    => v(0+4*i to 3+4*i) := "0010";
        when '3'    => v(0+4*i to 3+4*i) := "0011";
        when '4'    => v(0+4*i to 3+4*i) := "0100";
        when '5'    => v(0+4*i to 3+4*i) := "0101";
        when '6'    => v(0+4*i to 3+4*i) := "0110";
        when '7'    => v(0+4*i to 3+4*i) := "0111";
        when '8'    => v(0+4*i to 3+4*i) := "1000";
        when '9'    => v(0+4*i to 3+4*i) := "1001";
        when 'A'    => v(0+4*i to 3+4*i) := "1010";
        when 'B'    => v(0+4*i to 3+4*i) := "1011";
        when 'C'    => v(0+4*i to 3+4*i) := "1100";
        when 'D'    => v(0+4*i to 3+4*i) := "1101";
        when 'E'    => v(0+4*i to 3+4*i) := "1110";
        when 'F'    => v(0+4*i to 3+4*i) := "1111";
        when others => null;
      end case;
    end loop;  -- i
  end procedure read_v1d;

begin  -- tb

  -- component instantiation
  DUT : udp_rec
    port map (
      clk                => clk,
      rst_b              => rst_b,
      usr_data_input_bus => usr_data_input_bus,
      valid_out_usr_data => valid_out_usr_data,
      data_out           => data_out,
      valid_data         => valid_data,
      port_number        => port_number);

  -- clock generation
  lClk <= not lClk after 5 ns;
  clk  <= lclk;

  reset_Proc : process
  begin
    rst_b <= '0';
    wait for 20 ns;
    rst_b <= '1';
    wait;
  end process reset_Proc;

  corr_data : process
    begin
      valid_out_usr_data <= '0';
      wait for 390 ns;
      valid_out_usr_data <= '1';
      wait for 20 ns;
      valid_out_usr_data <= '0';
      wait;
  end process corr_data;

  -- waveform generation
  WaveGen_Proc : process


    file infile       : text open read_mode is "../../UDP/UDP_rec_kim/test_vector.dat";
    variable buf      : line;
    variable stimulus : std_logic_vector(0 to 7);
  begin
    wait for 100 ns;
    while not(endfile(infile)) loop
      read_v1d(infile, stimulus);
 
        wait for 10 ns;
        usr_data_input_bus <= stimulus;
 
      
     
      
    end loop;
    wait for 10 ns;
    usr_data_input_bus <= "XXXXXXXX";


    wait until Clk = '1';
  end process WaveGen_Proc;

  

end tb;

