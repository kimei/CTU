-------------------------------------------------------------------------------
-- Title      : Testbench for design "sync_trigger"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : sync_trigger_tb.vhd
-- Author     :   <kimei@fyspc-epf02>
-- Company    : 
-- Created    : 2011-03-11
-- Last update: 2011-10-21
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2011 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2011-03-11  1.0      kimei   Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;



library work;
use work.constants.all;
-------------------------------------------------------------------------------

entity sync_trigger_tb is

end sync_trigger_tb;

-------------------------------------------------------------------------------

architecture tb of sync_trigger_tb is

  component sync_trigger
    port (
      rst_b         : in  std_logic;
      mclk          : in  std_logic;
      en_or_trigger : in std_logic;
      module_mask : in std_logic_vector(NUMBER_OF_MODULES-1 downto 0);
      trigger_in    : in  std_logic_vector(NUMBER_OF_ROCS-1 downto 0);
      trigger_out   : out std_logic_vector(NUMBER_OF_ROCS-1 downto 0));
  end component;

  -- component ports
  signal rst_b         : std_logic;
  signal mclk          : std_logic;
  signal trigger_in    : std_logic_vector(NUMBER_OF_ROCS-1 downto 0);

  signal trigger_out   : std_logic_vector(NUMBER_OF_ROCS-1 downto 0);

  signal      en_or_trigger :std_logic;
signal     module_mask :  std_logic_vector(NUMBER_OF_MODULES-1 downto 0);

  -- clock
  signal Clk : std_logic := '1';
  
  procedure read_v1d (
    variable f : in text; v : out std_logic_vector) is
    variable buf : line;
    variable c   : character;
  begin
    readline(f,buf);
    for i in v'range loop
      read(buf, c);
      case c is
        when 'X'    => v(i) := 'X';
        when 'U'    => v(i) := 'U';
        when 'Z'    => v(i) := 'Z';
        when '0'    => v(i) := '0';
        when '1'    => v(i) := '1';
        when '-'    => v(i) := '-';
        when 'W'    => v(i) := 'W';
        when 'L'    => v(i) := 'L';
        when 'H'    => v(i) := 'H';
        when others => null;
      end case;
    end loop;  -- i
  end procedure read_v1d;


    begin  -- tb

      -- component instantiation
      DUT : sync_trigger
        port map (
          en_or_trigger => en_or_trigger,
          module_mask => module_mask,
          rst_b         => rst_b,
          mclk          => mclk,
          trigger_in    => trigger_in,
          trigger_out   => trigger_out);

      -- clock generation
      Clk  <= not Clk after 5 ns;
      mclk <= Clk;

      reset_Proc : process
      begin
        rst_b <= '0';
        wait for 50 ns;
        rst_b <= '1';
        wait;
      end process reset_Proc;



      WaveGen_Proc : process
        file infile       : text open read_mode is "vectors.dat";
        variable buf      : line;
        variable stimulus : std_logic_vector(NUMBER_OF_ROCS-1 downto 0);
      begin 
       en_or_trigger <=  '0';
       module_mask <=  (others => '1');
        while not(endfile(infile)) loop
          read_v1d(infile, stimulus);
          trigger_in <= stimulus;
          wait for 10 ns;
          
        end loop;
        
      end process WaveGen_Proc;

    end tb;


