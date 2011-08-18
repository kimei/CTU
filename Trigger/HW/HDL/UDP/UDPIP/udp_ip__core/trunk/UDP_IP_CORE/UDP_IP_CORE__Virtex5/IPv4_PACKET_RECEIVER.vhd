-----------------------------------------------------------------------------------------
-- Copyright (C) 2010 Nikolaos Ch. Alachiotis                                                                                                           --
--                                                                                                                                                                                                                                      --
-- Engineer:                            Nikolaos Ch. Alachiotis                                                                                                         --
--                                                                                                                                                                                                                                      --
-- Contact:                                     alachiot@cs.tum.edu                                                                                                                     --
--                                                              n.alachiotis@gmail.com                                                                                                          --
--                                                                                                                                                                                                                              --
-- Create Date:                 14:32:06 02/07/2010                                                                                                             --
-- Module Name:                 IPv4_PACKET_RECEIVER                                                                                                       --
-- Target Devices:              Virtex 5 FPGAs                                                                                                                          --
-- Tool versions:               ISE 10.1                                                                                                                                                        --
-- Description:                         This component can be used to receive IPv4 Ethernet Packets.    --
-- Additional Comments:                                                                                                                                                                         --
--                                                                                                                                                                                                                                      --
--              The receiver does not operate properly for data section of 1 or 2 bytes only.    --
--                                                                                                                                                                                                                                      --
-----------------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity IPv4_PACKET_RECEIVER is
  port (rst                  : in  std_logic;
         clk_125Mhz          : in  std_logic;
         rx_sof              : in  std_logic;
         rx_eof              : in  std_logic;
         input_bus           : in  std_logic_vector(7 downto 0);
         valid_out_usr_data  : out std_logic;
         usr_data_output_bus : out std_logic_vector (7 downto 0));
end IPv4_PACKET_RECEIVER;

architecture Behavioral of IPv4_PACKET_RECEIVER is

  component PACKET_RECEIVER_FSM is
    port (
      rst : in std_logic;
      clk : in std_logic;

      -- Signals from EMAC
      rx_sof : in std_logic;            -- active low input
      rx_eof : in std_logic;            -- active low input

      -- Signals to Counter and Comparator
      sel_comp_Bval : out std_logic;
      comp_Bval     : out std_logic_vector(10 downto 0);
      rst_count     : out std_logic;
      en_count      : out std_logic;

      -- Signal from Comparator
      comp_eq : in std_logic;

      -- Signals to Length Register                       
      wren_MSbyte : out std_logic;
      wren_LSbyte : out std_logic;

      -- Signal to user interface
      valid_out_usr_data : out std_logic);
  end component;

  component REG_8b_wren is
    port (rst         : in    std_logic;
           clk        : in    std_logic;
           wren       : in    std_logic;
           input_val  : in    std_logic_vector (7 downto 0);
           output_val : inout std_logic_vector(7 downto 0));
  end component;

  component COUNTER_11B_EN_RECEIV is
    port (rst       : in    std_logic;
           clk      : in    std_logic;
           count_en : in    std_logic;
           value_O  : inout std_logic_vector (10 downto 0));
  end component;

  component comp_11b_equal is
    port (
      qa_eq_b : out std_logic;
      clk     : in  std_logic := 'X';
      a       : in  std_logic_vector (10 downto 0);
      b       : in  std_logic_vector (10 downto 0)
      );
  end component;

  signal sel_comp_Bval,
    rst_count,
    en_count,
    comp_eq,
    wren_MSbyte,
    wren_LSbyte : std_logic;
  
  signal MSbyte_reg_val_out,
    LSbyte_reg_val_out : std_logic_vector(7 downto 0);
  
  signal counter_val,
    match_val,
    comp_Bval,
    comp_sel_val_vec,
    comp_n_sel_val_vec,
    length_val : std_logic_vector(10 downto 0);

  constant length_offest : std_logic_vector(7 downto 0) := "00001010";
-- This value is formed as 2 (1 clock the latency of comparator and 1 clock fro changing the FSM state) + 8 (number of bytes of UDP header section) 

begin

  usr_data_output_bus <= input_bus;

  PACKET_RECEIVER_FSM_port_map : PACKET_RECEIVER_FSM port map
    (
      rst => rst,
      clk => clk_125MHz,

      rx_sof => rx_sof,
      rx_eof => rx_eof,

      sel_comp_Bval => sel_comp_Bval,
      comp_Bval     => comp_Bval,
      rst_count     => rst_count,
      en_count      => en_count,

      comp_eq => comp_eq,

      wren_MSbyte => wren_MSbyte,
      wren_LSbyte => wren_LSbyte,

      valid_out_usr_data => valid_out_usr_data
      );

  MSbyte_REG : REG_8b_wren port map
    (
      rst        => rst,
      clk        => clk_125MHz,
      wren       => wren_MSbyte,
      input_val  => input_bus,
      output_val => MSbyte_reg_val_out
      );                        

  LSbyte_REG : REG_8b_wren port map
    (
      rst        => rst,
      clk        => clk_125MHz,
      wren       => wren_LSbyte,
      input_val  => input_bus,
      output_val => LSbyte_reg_val_out
      );

  COUNTER_11B_EN_port_map : COUNTER_11B_EN_RECEIV port map
    (
      rst      => rst_count,
      clk      => clk_125MHz,
      count_en => en_count,
      value_O  => counter_val
      );

  Comp_11b_equal_port_map : Comp_11b_equal port map
    (
      qa_eq_b => comp_eq,
      clk     => clk_125MHz,
      a       => counter_val,
      b       => match_val
      );

  length_val(7 downto 0)  <= LSbyte_reg_val_out-length_offest;
  length_val(10 downto 8) <= MSbyte_reg_val_out (2 downto 0);

  comp_sel_val_vec   <= (others => sel_comp_Bval);
  comp_n_sel_val_vec <= (others => not sel_comp_Bval);

  match_val <= (comp_sel_val_vec and length_val) or (comp_n_sel_val_vec and comp_Bval);

  
end Behavioral;

