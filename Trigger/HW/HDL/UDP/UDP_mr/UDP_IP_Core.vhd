-----------------------------------------------------------------------------------------
-- Copyright (C) 2010 Nikolaos Ch. Alachiotis                                                                                                           --
--                                                                                                                                                                                                                                      --
-- Engineer:                            Nikolaos Ch. Alachiotis                                                                                                         --
--                                                                                                                                                                                                                                      --
-- Contact:                                     alachiot@cs.tum.edu                                                                                                                     --
--                                                              n.alachiotis@gmail.com                                                                                                          --
--                                                                                                                                                                                                                              --
-- Create Date:                 15:29:59 02/07/2010                                                                                                             --
-- Module Name:                 UDP_IP_Core                                                                                                                                             --
-- Target Devices:              Virtex 5 FPGAs                                                                                                                          --
-- Tool versions:               ISE 10.1                                                                                                                                                        --
-- Description:                         This component can be used to transmit and receive UDP/IP      --
--                                                              Ethernet Packets (IPv4).                                                                                                        --
-- Additional Comments: The core has been area-optimized and is suitable for direct    --
--                                          PC-FPGA communication at Gigabit speed.                        --
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

entity UDP_IP_Core is
 generic
    (
      DestMAC  : std_logic_vector(47 downto 0) := x"00c09fbf33b0";  --ferrari
      --DestMAC: std_logic_vector(47 downto 0):=x"000e0c333384";  --compet002
      DestIP   : std_logic_vector(31 downto 0) := x"C0A80140";  --192.168.1.64
      --DestIP: std_logic_vector(31 downto 0) :=  x"C0A80102"  --192.168.1.2
      SrcPort  : std_logic_vector(15 downto 0) := "0101010101010101";  -- for the data
      DestPort : std_logic_vector(15 downto 0) := "0101010101010100"   -- data
      );
  port (rst         : in std_logic;     -- active-high
         clk_125MHz : in std_logic;

         -- Transmit signals
         transmit_start_enable    : in  std_logic;
         transmit_data_length     : in  std_logic_vector (15 downto 0);
         usr_data_trans_phase_on  : out std_logic;
         transmit_data_input_bus  : in  std_logic_vector (7 downto 0);
         start_of_frame_O         : out std_logic;
         end_of_frame_O           : out std_logic;
         source_ready             : out std_logic;
         transmit_data_output_bus : out std_logic_vector (7 downto 0);

         --Receive Signals
         rx_sof              : in  std_logic;
         rx_eof              : in  std_logic;
         input_bus           : in  std_logic_vector(7 downto 0);
         valid_out_usr_data  : out std_logic;
         usr_data_output_bus : out std_logic_vector (7 downto 0);
         DSwitch             : in  std_logic_vector(7 downto 0)
         );
end UDP_IP_Core;

architecture Behavioral of UDP_IP_Core is

  component IPV4_PACKET_TRANSMITTER is
     generic
    (
      DestMAC  : std_logic_vector(47 downto 0) := x"00c09fbf33b0";  --ferrari
      --DestMAC: std_logic_vector(47 downto 0):=x"000e0c333384";  --compet002
      DestIP   : std_logic_vector(31 downto 0) := x"C0A80140";  --192.168.1.64
      --DestIP: std_logic_vector(31 downto 0) :=  x"C0A80102"  --192.168.1.2
      SrcPort  : std_logic_vector(15 downto 0) := "0101010101010101";  -- for the data
      DestPort : std_logic_vector(15 downto 0) := "0101010101010100"   -- data
      );
    port (rst                       : in  std_logic;
           clk_125MHz               : in  std_logic;
           transmit_start_enable    : in  std_logic;
           transmit_data_length     : in  std_logic_vector (15 downto 0);
           usr_data_trans_phase_on  : out std_logic;
           transmit_data_input_bus  : in  std_logic_vector (7 downto 0);
           start_of_frame_O         : out std_logic;
           end_of_frame_O           : out std_logic;
           source_ready             : out std_logic;
           transmit_data_output_bus : out std_logic_vector (7 downto 0);
           DSwitch                  : in  std_logic_vector(7 downto 0)
           );
  end component;

  component IPv4_PACKET_RECEIVER is
    port (rst                  : in  std_logic;
           clk_125Mhz          : in  std_logic;
           rx_sof              : in  std_logic;
           rx_eof              : in  std_logic;
           input_bus           : in  std_logic_vector(7 downto 0);
           valid_out_usr_data  : out std_logic;
           usr_data_output_bus : out std_logic_vector (7 downto 0));
  end component;

begin

  IPV4_PACKET_TRANSMITTER_port_map : IPV4_PACKET_TRANSMITTER
    generic map (
      DestMAC => DestMAC,
      DestIP   => DestIP,
      DestPort => DestPort,
      SrcPort  => SrcPort)
    port map
    (rst                       => rst,
      clk_125MHz               => clk_125MHz,
      transmit_start_enable    => transmit_start_enable,
      transmit_data_length     => transmit_data_length,
      usr_data_trans_phase_on  => usr_data_trans_phase_on,
      transmit_data_input_bus  => transmit_data_input_bus,
      start_of_frame_O         => start_of_frame_O,
      end_of_frame_O           => end_of_frame_O,
      source_ready             => source_ready,
      transmit_data_output_bus => transmit_data_output_bus,
      DSwitch                  => DSwitch
      );


  IPv4_PACKET_RECEIVER_port_map : IPv4_PACKET_RECEIVER
    port map
    (rst                  => rst,
      clk_125Mhz          => clk_125Mhz,
      rx_sof              => rx_sof,
      rx_eof              => rx_eof,
      input_bus           => input_bus,
      valid_out_usr_data  => valid_out_usr_data,
      usr_data_output_bus => usr_data_output_bus
      );

end Behavioral;

