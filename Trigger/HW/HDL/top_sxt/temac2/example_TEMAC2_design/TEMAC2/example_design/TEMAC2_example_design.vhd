-------------------------------------------------------------------------------
-- Title      : Virtex-5 Ethernet MAC Example Design Wrapper
-- Project    : Virtex-5 Embedded Tri-Mode Ethernet MAC Wrapper
-- File       : TEMAC2_example_design.vhd
-- Version    : 1.8
-------------------------------------------------------------------------------
--
-- (c) Copyright 2004-2010 Xilinx, Inc. All rights reserved.
--
-- This file contains confidential and proprietary information
-- of Xilinx, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
--
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Xilinx, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the
-- possibility of the same.
--
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of Xilinx products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
--
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES.
--
-------------------------------------------------------------------------------
-- Description:  This is the VHDL example design for the Virtex-5 
--               Embedded Ethernet MAC.  It is intended that
--               this example design can be quickly adapted and downloaded onto
--               an FPGA to provide a real hardware test environment.
--
--               This level:
--
--               * instantiates the TEMAC local link file that instantiates 
--                 the TEMAC top level together with a RX and TX FIFO with a 
--                 local link interface;
--
--               * instantiates a simple client I/F side example design,
--                 providing an address swap and a simple
--                 loopback function;
--
--               * Instantiates IBUFs on the GTX_CLK, REFCLK and HOSTCLK inputs 
--                 if required;
--
--               Please refer to the Datasheet, Getting Started Guide, and
--               the Virtex-5 Embedded Tri-Mode Ethernet MAC User Gude for
--               further information.
--
--
--
--    ---------------------------------------------------------------------
--    | EXAMPLE DESIGN WRAPPER                                            |
--    |           --------------------------------------------------------|
--    |           |LOCAL LINK WRAPPER                                     |
--    |           |              -----------------------------------------|
--    |           |              |BLOCK LEVEL WRAPPER                     |
--    |           |              |    ---------------------               |
--    | --------  |  ----------  |    | ETHERNET MAC      |               |
--    | |      |  |  |        |  |    | WRAPPER           |  ---------    |
--    | |      |->|->|        |--|--->| Tx            Tx  |--|       |--->|
--    | |      |  |  |        |  |    | client        PHY |  |       |    |
--    | | ADDR |  |  | LOCAL  |  |    | I/F           I/F |  |       |    |  
--    | | SWAP |  |  |  LINK  |  |    |                   |  | PHY   |    |
--    | |      |  |  |  FIFO  |  |    |                   |  | I/F   |    |
--    | |      |  |  |        |  |    |                   |  |       |    |
--    | |      |  |  |        |  |    | Rx            Rx  |  |       |    |
--    | |      |  |  |        |  |    | client        PHY |  |       |    |
--    | |      |<-|<-|        |<-|----| I/F           I/F |<-|       |<---|
--    | |      |  |  |        |  |    |                   |  ---------    |
--    | --------  |  ----------  |    ---------------------               |
--    |           |              -----------------------------------------|
--    |           --------------------------------------------------------|
--    ---------------------------------------------------------------------
--
-------------------------------------------------------------------------------


library unisim;
use unisim.vcomponents.all;

use work.constants.all;                 --! Global constants



library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;


-------------------------------------------------------------------------------
-- The entity declaration for the example design.
-------------------------------------------------------------------------------
entity TEMAC2_example_design is
  port(
    -- Client Receiver Interface - EMAC1
    EMAC1CLIENTRXDVLD         : out std_logic;
    EMAC1CLIENTRXFRAMEDROP    : out std_logic;
    EMAC1CLIENTRXSTATS        : out std_logic_vector(6 downto 0);
    EMAC1CLIENTRXSTATSVLD     : out std_logic;
    EMAC1CLIENTRXSTATSBYTEVLD : out std_logic;

    -- Client Transmitter Interface - EMAC1
    CLIENTEMAC1TXIFGDELAY     : in  std_logic_vector(7 downto 0);
    EMAC1CLIENTTXSTATS        : out std_logic;
    EMAC1CLIENTTXSTATSVLD     : out std_logic;
    EMAC1CLIENTTXSTATSBYTEVLD : out std_logic;

    -- MAC Control Interface - EMAC1
    CLIENTEMAC1PAUSEREQ : in std_logic;
    CLIENTEMAC1PAUSEVAL : in std_logic_vector(15 downto 0);


    -- Clock Signals - EMAC1
    GTX_CLK_1 : in std_logic;

    -- GMII Interface - EMAC1
    GMII_TXD_1    : out std_logic_vector(7 downto 0);
    GMII_TX_EN_1  : out std_logic;
    GMII_TX_ER_1  : out std_logic;
    GMII_TX_CLK_1 : out std_logic;
    GMII_RXD_1    : in  std_logic_vector(7 downto 0);
    GMII_RX_DV_1  : in  std_logic;
    GMII_RX_ER_1  : in  std_logic;
    GMII_RX_CLK_1 : in  std_logic;

    -- Reference clock for RGMII IODELAYs
    REFCLK : in std_logic;


    -- Asynchronous Reset
    RESET       : in  std_logic;
    PHY_RESET_1 : out std_logic;


    -- user data:
    mclk                             : in std_logic;
    rst_b_from_rocs_to_async_trigger : in std_logic;
    en_or_trigger                    : in std_logic;
    en_rand_trigger                  : in std_logic;
    rst_b                            : in std_logic
    );
end TEMAC2_example_design;


architecture TOP_LEVEL of TEMAC2_example_design is

-------------------------------------------------------------------------------
-- Component Declarations for lower hierarchial level entities
-------------------------------------------------------------------------------
  -- Component Declaration for the TEMAC wrapper with 
  -- Local Link FIFO.
  component TEMAC2_locallink is
    port(
      -- EMAC1 Clocking
      -- EMAC1 TX Clock input from BUFG
      TX_CLK_1 : in std_logic;

      -- Local link Receiver Interface - EMAC1
      RX_LL_CLOCK_1       : in  std_logic;
      RX_LL_RESET_1       : in  std_logic;
      RX_LL_DATA_1        : out std_logic_vector(7 downto 0);
      RX_LL_SOF_N_1       : out std_logic;
      RX_LL_EOF_N_1       : out std_logic;
      RX_LL_SRC_RDY_N_1   : out std_logic;
      RX_LL_DST_RDY_N_1   : in  std_logic;
      RX_LL_FIFO_STATUS_1 : out std_logic_vector(3 downto 0);

      -- Local link Transmitter Interface - EMAC1
      TX_LL_CLOCK_1     : in  std_logic;
      TX_LL_RESET_1     : in  std_logic;
      TX_LL_DATA_1      : in  std_logic_vector(7 downto 0);
      TX_LL_SOF_N_1     : in  std_logic;
      TX_LL_EOF_N_1     : in  std_logic;
      TX_LL_SRC_RDY_N_1 : in  std_logic;
      TX_LL_DST_RDY_N_1 : out std_logic;

      -- Client Receiver Interface - EMAC1
      EMAC1CLIENTRXDVLD         : out std_logic;
      EMAC1CLIENTRXFRAMEDROP    : out std_logic;
      EMAC1CLIENTRXSTATS        : out std_logic_vector(6 downto 0);
      EMAC1CLIENTRXSTATSVLD     : out std_logic;
      EMAC1CLIENTRXSTATSBYTEVLD : out std_logic;

      -- Client Transmitter Interface - EMAC1
      CLIENTEMAC1TXIFGDELAY     : in  std_logic_vector(7 downto 0);
      EMAC1CLIENTTXSTATS        : out std_logic;
      EMAC1CLIENTTXSTATSVLD     : out std_logic;
      EMAC1CLIENTTXSTATSBYTEVLD : out std_logic;

      -- MAC Control Interface - EMAC1
      CLIENTEMAC1PAUSEREQ : in std_logic;
      CLIENTEMAC1PAUSEVAL : in std_logic_vector(15 downto 0);


      -- Clock Signals - EMAC1
      GTX_CLK_1 : in std_logic;

      -- GMII Interface - EMAC1
      GMII_TXD_1    : out std_logic_vector(7 downto 0);
      GMII_TX_EN_1  : out std_logic;
      GMII_TX_ER_1  : out std_logic;
      GMII_TX_CLK_1 : out std_logic;
      GMII_RXD_1    : in  std_logic_vector(7 downto 0);
      GMII_RX_DV_1  : in  std_logic;
      GMII_RX_ER_1  : in  std_logic;
      GMII_RX_CLK_1 : in  std_logic;



      -- Asynchronous Reset
      RESET : in std_logic
      );
  end component;



-----------------------------------------------------------------------
-- Signal Declarations
-----------------------------------------------------------------------

  -- Global asynchronous reset
  signal reset_i : std_logic;

  -- client interface clocking signals - EMAC1
  signal ll_clk_1_i : std_logic;

  -- address swap transmitter connections - EMAC1
  signal tx_ll_data_1_i      : std_logic_vector(7 downto 0);
  signal tx_ll_sof_n_1_i     : std_logic;
  signal tx_ll_eof_n_1_i     : std_logic;
  signal tx_ll_src_rdy_n_1_i : std_logic;
  signal tx_ll_dst_rdy_n_1_i : std_logic;

  -- address swap receiver connections - EMAC1
  signal rx_ll_data_1_i      : std_logic_vector(7 downto 0);
  signal rx_ll_sof_n_1_i     : std_logic;
  signal rx_ll_eof_n_1_i     : std_logic;
  signal rx_ll_src_rdy_n_1_i : std_logic;
  signal rx_ll_dst_rdy_n_1_i : std_logic;

  -- create a synchronous reset in the transmitter clock domain
  signal ll_pre_reset_1_i : std_logic_vector(5 downto 0);
  signal ll_reset_1_i     : std_logic;


  attribute async_reg                     : string;
  attribute async_reg of ll_pre_reset_1_i : signal is "true";

  -- Reference clock for RGMII IODELAYs
  signal refclk_ibufg_i : std_logic;
  signal refclk_bufg_i  : std_logic;


  -- EMAC1 Clocking signals

  signal tx_clk_1            : std_logic;
  signal rx_clk_1_i          : std_logic;
  signal gmii_rx_clk_1_delay : std_logic;

  -- IDELAY controller
  signal idelayctrl_reset_1_r : std_logic_vector(12 downto 0);
  signal idelayctrl_reset_1_i : std_logic;

  -- Setting attribute for RGMII/GMII IDELAY
  -- For more information on IDELAYCTRL and IDELAY, please refer to
  -- the Virtex-5 User Guide.
  attribute syn_noprune : boolean;
  --attribute syn_noprune of dlyctrl1  : label is true;


  attribute buffer_type : string;

  signal gtx_clk_1_i                   : std_logic;
  attribute buffer_type of gtx_clk_1_i : signal is "none";


  -- UP stuff: 
  signal transmit_data_output_bus     : std_logic_vector(7 downto 0);
  signal transmit_data_output_bus_reg : std_logic_vector(7 downto 0);
  signal source_ready                 : std_logic;


  signal end_of_frame_O   : std_logic;
  signal start_of_frame_O : std_logic;
  signal input_bus        : std_logic_vector(7 downto 0);
  signal rx_eof           : std_logic;

  signal rx_sof : std_logic;

  signal transmit_start_enable   : std_logic;
  signal transmit_data_length    : std_logic_vector(15 downto 0);
  signal usr_data_trans_phase_on : std_logic;

  signal transmit_data_input_bus : std_logic_vector(7 downto 0);
  signal valid_out_usr_data      : std_logic;
  signal usr_data_output_bus     : std_logic_vector(7 downto 0);


  signal DSwitch : std_logic_vector(7 downto 0);




-------------------------------------------------------------------------------
-- Main Body of Code
-------------------------------------------------------------------------------
  -- fifo interface
  signal we_rate_counter  : std_logic;
  signal we_others        : std_logic;
  signal din_rate_counter : std_logic_vector(7 downto 0);
  signal din_fifo         : std_logic_vector(7 downto 0);
  signal rd_en_fifo       : std_logic;

  signal wr_en_fifo      : std_logic;
  signal data_count_fifo : std_logic_vector(8 downto 0);
  signal dout_fifo       : std_logic_vector(7 downto 0);
  signal empty_fifo      : std_logic;
  signal full_fifo       : std_logic;


  -- signals to and from the UDP/IP core




  signal transmit_start_enable_FF    : std_logic;
  signal transmit_data_length_FF     : std_logic_vector (15 downto 0);
  signal usr_data_trans_phase_on_FF  : std_logic;
  signal transmit_data_input_bus_FF  : std_logic_vector (7 downto 0);
  signal start_of_frame_O_FF         : std_logic;
  signal end_of_frame_O_FF           : std_logic;
  signal source_ready_FF             : std_logic;
  signal transmit_data_output_bus_FF : std_logic_vector (7 downto 0);

  signal input_bus_FF           : std_logic_vector(7 downto 0);
  signal valid_out_usr_data_FF  : std_logic;
  signal usr_data_output_bus_FF : std_logic_vector (7 downto 0);


  signal transmit_start_enable_i    : std_logic;
  signal transmit_data_length_i     : std_logic_vector (15 downto 0);
  signal usr_data_trans_phase_on_i  : std_logic;
  signal transmit_data_input_bus_i  : std_logic_vector (7 downto 0);
  signal start_of_frame_O_i         : std_logic;
  signal end_of_frame_O_i           : std_logic;
  signal source_ready_i             : std_logic;
  signal transmit_data_output_bus_i : std_logic_vector (7 downto 0);
  signal rx_sof_i                   : std_logic;
  signal rx_eof_i                   : std_logic;
  signal input_bus_i                : std_logic_vector(7 downto 0);
  signal valid_out_usr_data_i       : std_logic;
  signal usr_data_output_bus_i      : std_logic_vector (7 downto 0);


  signal counter : integer range 0 to 1023;

  signal udp_data_out    : std_logic_vector(7 downto 0);
  signal udp_valid_data  : std_logic;
  signal udp_port_number : std_logic_vector(15 downto 0);

  signal udp_data_out_buf   : std_logic_vector(7 downto 0);
  signal udp_valid_data_buf : std_logic;
  signal udp_counter        : integer range 0 to 63;

  signal we_udp        : std_logic;
  signal dout_fifo_udp : std_logic_vector(7 downto 0);


  signal send_fifo_we_rec_contr      : std_logic;
  signal send_fifo_data_in_rec_contr : std_logic_vector(7 downto 0);

  signal send_fifo_we_async_trigger      : std_logic;
  signal send_fifo_data_in_async_trigger : std_logic_vector(7 downto 0);

  signal mrst_from_udp_b : std_logic;


  signal sender_ip : std_logic_vector(7 downto 0);

  -- signals for the UDP sender FSM
  type   state_types is (INIT, WAIT_FOR_WR_EN, PREP_TRANS, PREP_TRANS2, START_TRANS, START_TRANS2, PREP_FIRST_BYTE, WAIT_FOR_UDP, SEND_DATA);
  signal state         : state_types;
  signal bytes_to_send : unsigned(8 downto 0);
  signal dout_fifo_tmp : std_logic_vector(7 downto 0);
  signal where_to_send : std_logic;

  signal ll_reset_1_i_b : std_logic;


  signal CONTROL0 : std_logic_vector(35 downto 0);
  component cs_controller
    port (
      CONTROL0 : inout std_logic_vector(35 downto 0));
  end component;
  component ila_cs
    port (
      CONTROL : inout std_logic_vector(35 downto 0);
      CLK     : in    std_logic;
      TRIG0   : in    std_logic_vector(127 downto 0));
  end component;
  signal cs_trig : std_logic_vector(127 downto 0);

begin
  cs_contr : cs_controller
    port map (
      CONTROL0 => CONTROL0);
  your_instance_name : ila_cs
    port map (
      CONTROL => CONTROL0,
      CLK     => ll_clk_1_i,
      TRIG0   => cs_trig);

  cs_trig(7 downto 0) <= usr_data_output_bus;
  cs_trig(8)          <= valid_out_usr_data;

  cs_trig(17 downto 10) <= udp_data_out;
  cs_trig(18)           <= udp_valid_data;
  cs_trig(27 downto 20) <= sender_ip;




  PHY_RESET_1 <= not reset_i;

  reset_i        <= not rst_b;
  --RESET <= not rst_b;
  ll_reset_1_i_b <= not ll_reset_1_i;


  DSwitch <= "00111101";  --set the ip, we don't have a dip-switch her
  -- we_others <= send_fifo_we_rec_contr or we_rate_counter;
  --we_others <= (we_rate_counter or (send_fifo_we_rec_contr or send_fifo_we_async_trigger));

  we_others <= send_fifo_we_async_trigger;  --or we_rate_counter;

  wr_en_fifo <= we_others;

  --din_fifo <= din_rate_counter when we_rate_counter = '1' else send_fifo_data_in_rec_contr;


  din_fifo <= send_fifo_data_in_async_trigger;  --or din_rate_counter;


  rx_ll_dst_rdy_n_1_i <= tx_ll_dst_rdy_n_1_i;

  tx_ll_sof_n_1_i     <= start_of_frame_O_i;
  tx_ll_eof_n_1_i     <= end_of_frame_O_i;
  tx_ll_data_1_i      <= transmit_data_output_bus_i;
  tx_ll_src_rdy_n_1_i <= source_ready_i;

  --RX:
  rx_sof                   <= rx_ll_sof_n_1_i;
  rx_eof                   <= rx_ll_eof_n_1_i;
  input_bus                <= rx_ll_data_1_i;
-- Connection of UDP multiplexing
  transmit_start_enable    <= transmit_start_enable_i when where_to_send = '1' else '0';
  transmit_start_enable_FF <= transmit_start_enable_i when where_to_send = '0' else '0';


  transmit_data_length    <= transmit_data_length_i when where_to_send = '1' else x"0000";
  transmit_data_length_FF <= transmit_data_length_i when where_to_send = '0' else x"0000";


  usr_data_trans_phase_on_i <= usr_data_trans_phase_on when where_to_send = '1' else usr_data_trans_phase_on_FF;

  transmit_data_input_bus    <= transmit_data_input_bus_i when where_to_send = '1' else x"00";
  transmit_data_input_bus_FF <= transmit_data_input_bus_i when where_to_send = '0' else x"00";

  start_of_frame_O_i <= start_of_frame_O when where_to_send = '1' else start_of_frame_O_FF;
  end_of_frame_O_i   <= end_of_frame_O   when where_to_send = '1' else end_of_frame_O_FF;

  source_ready_i <= source_ready when where_to_send = '1' else source_ready_FF;

  transmit_data_output_bus_i <= transmit_data_output_bus when where_to_send = '1' else transmit_data_output_bus_FF;


  send_fifo : entity work.fifo_generator_v4_4
    port map(
      clk        => ll_clk_1_i,         --125 mhz
      din        => din_fifo,
      rd_en      => rd_en_fifo,
      rst        => ll_reset_1_i,
      wr_en      => wr_en_fifo,
      data_count => data_count_fifo,
      dout       => dout_fifo,
      empty      => empty_fifo,
      full       => full_fifo
      );

  rate_counter_1 : entity work.rate_counter
    port map(
      clk         => ll_clk_1_i,        --125 mhz
      rst_b       => ll_reset_1_i_b,
      rate_cards  => "00",
      coincidence => "00",
      fifo_empty  => empty_fifo,
      we          => we_rate_counter,
      we_others   => we_others,
      din         => din_rate_counter
      );

  inst_async_trigger : entity work.async_trigger
    port map(

      clk          => ll_clk_1_i,
      clk100       => mclk,
      rst_b        => ll_reset_1_i_b,
      rocs_reset_b => rst_b_from_rocs_to_async_trigger,
      udp_data_in  => udp_data_out,
      valid_data   => udp_valid_data,
      port_number  => udp_port_number,
      sender_ip    => sender_ip,

      send_fifo_we        => send_fifo_we_async_trigger,
      send_fifo_we_others => we_others,
      send_fifo_empty     => empty_fifo,
      en_or_trigger       => en_or_trigger,
      en_rand_trigger     => en_rand_trigger,
      send_fifo_data_in   => send_fifo_data_in_async_trigger
      );

--  Inst_receiver_control : entity work.receiver_control
--    port map(
--      clk                 => ll_clk_1_i ,
--      rst_b               => ll_reset_1_i_b,
--      udp_data_in         => udp_data_out ,
  --valid_data          => udp_valid_data,
  --port_number         => udp_port_number,
  --mrst_from_udp_b     => open,
  --en_random_trigger   => open,
  --en_or_trigger       => open,
  --trigger_mask        => open,
  --module_mask         => open,
  --send_fifo_we        => send_fifo_we_rec_contr,
  --send_fifo_we_others => we_others ,
  --send_fifo_empty     => empty_fifo,
  --send_fifo_data_in   => send_fifo_data_in_rec_contr);

  
  receiver_unit : entity work.udp_rec
    port map(
      clk                => ll_clk_1_i,
      rst_b              => ll_reset_1_i_b,
      usr_data_input_bus => usr_data_output_bus,
      valid_out_usr_data => valid_out_usr_data,
      data_out           => udp_data_out,
      valid_data         => udp_valid_data,
      sender_ip          => sender_ip,
      dswitch            => dswitch,
      port_number        => udp_port_number);


  UDP_IP_Core_1 : entity work.UDP_IP_Core
    generic map (
      --DestMAC =>x"00c09fbf33b0",  --ferrari, must be readout computer eventually

      DestMAC  => x"000e0c333384",      --compet002
      DestIP   => x"C0A80140",  --192.168.1.64, change to readout computer ip.
      DestPort => x"5556",
      SrcPort  => x"5557")
    port map(
      rst                      => ll_reset_1_i,
      clk_125MHz               => ll_clk_1_i,
      transmit_start_enable    => transmit_start_enable,  --active high , It must be high for one clock cycle only.
      transmit_data_length     => transmit_data_length,  -- number of user data to be transmitted (number of bytes)
      usr_data_trans_phase_on  => usr_data_trans_phase_on,  -- is high one clock cycle before the transmittion of user data and remains high while transmitting user data
      transmit_data_input_bus  => transmit_data_input_bus,  -- input data to be transmitted. Starts transmitting one clock cycle after the usr_data_trans_phase_on is set
      start_of_frame_O         => start_of_frame_O,  -- should be connected to the local link wrapper's input port
      end_of_frame_O           => end_of_frame_O,  -- should be connected to the local link wrapper's input port
      source_ready             => source_ready,  --should be connected to the local link wrapper's input port
      transmit_data_output_bus => transmit_data_output_bus,  -- should be connected to the local link wrapper's input port
      rx_sof                   => rx_sof,  -- active low, inputs from the local link wrapper
      rx_eof                   => rx_eof,  -- active low, inputs from the local link wrapper
      input_bus                => input_bus,  -- input from the local link wrapper
      valid_out_usr_data       => valid_out_usr_data,  -- output to user, when set it indicates that the usr_data_output_bus contains the user data section of the incoming packet
      usr_data_output_bus      => usr_data_output_bus,
      Dswitch                  => DSwitch);  -- user data output bus output to the user

  
  UDP_IP_Core_2 : entity work.UDP_IP_Core
    generic map (
      --DestMAC =>x"00c09fbf33b0",  --ferrari, must be readout computer eventually

      DestMAC  => x"ffffffffffff",      --compet002
      DestIP   => x"C0A801FF",  --192.168.1.64, change to readout computer ip.
      DestPort => x"5500",
      SrcPort  => x"5501")
    port map(
      rst                      => ll_reset_1_i,
      clk_125MHz               => ll_clk_1_i,
      transmit_start_enable    => transmit_start_enable_FF,  --active high , It must be high for one clock cycle only.
      transmit_data_length     => transmit_data_length_FF,  -- number of user data to be transmitted (number of bytes)
      usr_data_trans_phase_on  => usr_data_trans_phase_on_FF,  -- is high one clock cycle before the transmittion of user data and remains high while transmitting user data
      transmit_data_input_bus  => transmit_data_input_bus_FF,  -- input data to be transmitted. Starts transmitting one clock cycle after the usr_data_trans_phase_on is set
      start_of_frame_O         => start_of_frame_O_FF,  -- should be connected to the local link wrapper's input port
      end_of_frame_O           => end_of_frame_O_FF,  -- should be connected to the local link wrapper's input port
      source_ready             => source_ready_FF,  --should be connected to the local link wrapper's input port
      transmit_data_output_bus => transmit_data_output_bus_FF,  -- should be connected to the local link wrapper's input port
      rx_sof                   => rx_sof,  -- active low, inputs from the local link wrapper
      rx_eof                   => rx_eof,  -- active low, inputs from the local link wrapper
      input_bus                => input_bus,  -- input from the local link wrapper
      valid_out_usr_data       => valid_out_usr_data_FF,  -- output to user, when set it indicates that the usr_data_output_bus contains the user data section of the incoming packet
      usr_data_output_bus      => usr_data_output_bus_FF,
      Dswitch                  => DSwitch);  -- user data output bus output to the user

  

  

  delay1rstgen : process (refclk_bufg_i, reset_i)
  begin
    if (reset_i = '1') then
      idelayctrl_reset_1_r(0)           <= '0';
      idelayctrl_reset_1_r(12 downto 1) <= (others => '1');
    elsif refclk_bufg_i'event and refclk_bufg_i = '1' then
      idelayctrl_reset_1_r(0)           <= '0';
      idelayctrl_reset_1_r(12 downto 1) <= idelayctrl_reset_1_r(11 downto 0);
    end if;
  end process delay1rstgen;

  idelayctrl_reset_1_i <= idelayctrl_reset_1_r(12);

  -- Please modify the value of the IOBDELAYs according to your design.
  -- For more information on IDELAYCTRL and IODELAY, please refer to
  -- the Virtex-5 User Guide.
  gmii_rxc1_delay : IODELAY
    generic map (
      IDELAY_TYPE    => "FIXED",
      IDELAY_VALUE   => 0,
      DELAY_SRC      => "I",
      SIGNAL_PATTERN => "CLOCK"
      )
    port map (
      IDATAIN => GMII_RX_CLK_1,
      ODATAIN => '0',
      DATAOUT => gmii_rx_clk_1_delay,
      DATAIN  => '0',
      C       => '0',
      T       => '0',
      CE      => '0',
      INC     => '0',
      RST     => '0'
      );


  -- Put the 125MHz reference clock through a BUFG.
  -- Used to clock the TX section of the EMAC wrappers.
  -- This clock can be shared between multiple MAC instances.
  bufg_tx_1 : BUFG port map (I => gtx_clk_1_i, O => tx_clk_1);

  -- Put the RX PHY clock through a BUFG.
  -- Used to clock the RX section of the EMAC wrappers.
  bufg_rx_1 : BUFG port map (I => gmii_rx_clk_1_delay, O => rx_clk_1_i);

  ll_clk_1_i <= tx_clk_1;

  ------------------------------------------------------------------------
  -- Instantiate the EMAC Wrapper with LL FIFO 
  -- (TEMAC2_locallink.v)
  ------------------------------------------------------------------------
  v5_emac_ll : TEMAC2_locallink
    port map (
      -- EMAC1 Clocking
      -- EMAC1 TX Clock input from BUFG
      TX_CLK_1            => tx_clk_1,
      -- Local link Receiver Interface - EMAC0
      RX_LL_CLOCK_1       => ll_clk_1_i,
      RX_LL_RESET_1       => ll_reset_1_i,
      RX_LL_DATA_1        => rx_ll_data_1_i,
      RX_LL_SOF_N_1       => rx_ll_sof_n_1_i,
      RX_LL_EOF_N_1       => rx_ll_eof_n_1_i,
      RX_LL_SRC_RDY_N_1   => rx_ll_src_rdy_n_1_i,
      RX_LL_DST_RDY_N_1   => rx_ll_dst_rdy_n_1_i,
      RX_LL_FIFO_STATUS_1 => open,

      -- Unused Receiver signals - EMAC1
      EMAC1CLIENTRXDVLD         => EMAC1CLIENTRXDVLD,
      EMAC1CLIENTRXFRAMEDROP    => EMAC1CLIENTRXFRAMEDROP,
      EMAC1CLIENTRXSTATS        => EMAC1CLIENTRXSTATS,
      EMAC1CLIENTRXSTATSVLD     => EMAC1CLIENTRXSTATSVLD,
      EMAC1CLIENTRXSTATSBYTEVLD => EMAC1CLIENTRXSTATSBYTEVLD,

      -- Local link Transmitter Interface - EMAC0
      TX_LL_CLOCK_1     => ll_clk_1_i,
      TX_LL_RESET_1     => ll_reset_1_i,
      TX_LL_DATA_1      => tx_ll_data_1_i,
      TX_LL_SOF_N_1     => tx_ll_sof_n_1_i,
      TX_LL_EOF_N_1     => tx_ll_eof_n_1_i,
      TX_LL_SRC_RDY_N_1 => tx_ll_src_rdy_n_1_i,
      TX_LL_DST_RDY_N_1 => tx_ll_dst_rdy_n_1_i,

      -- Unused Transmitter signals - EMAC1
      CLIENTEMAC1TXIFGDELAY     => CLIENTEMAC1TXIFGDELAY,
      EMAC1CLIENTTXSTATS        => EMAC1CLIENTTXSTATS,
      EMAC1CLIENTTXSTATSVLD     => EMAC1CLIENTTXSTATSVLD,
      EMAC1CLIENTTXSTATSBYTEVLD => EMAC1CLIENTTXSTATSBYTEVLD,

      -- MAC Control Interface - EMAC1
      CLIENTEMAC1PAUSEREQ => CLIENTEMAC1PAUSEREQ,
      CLIENTEMAC1PAUSEVAL => CLIENTEMAC1PAUSEVAL,


      -- Clock Signals - EMAC1
      GTX_CLK_1     => '0',
      -- GMII Interface - EMAC1
      GMII_TXD_1    => GMII_TXD_1,
      GMII_TX_EN_1  => GMII_TX_EN_1,
      GMII_TX_ER_1  => GMII_TX_ER_1,
      GMII_TX_CLK_1 => GMII_TX_CLK_1,
      GMII_RXD_1    => GMII_RXD_1,
      GMII_RX_DV_1  => GMII_RX_DV_1,
      GMII_RX_ER_1  => GMII_RX_ER_1,
      GMII_RX_CLK_1 => rx_clk_1_i,



      -- Asynchronous Reset
      RESET => reset_i
      );





  -- Create synchronous reset in the transmitter clock domain.
  gen_ll_reset_emac1 : process (ll_clk_1_i, reset_i)
  begin
    if reset_i = '1' then
      ll_pre_reset_1_i <= (others => '1');
      ll_reset_1_i     <= '1';
    elsif ll_clk_1_i'event and ll_clk_1_i = '1' then
      ll_pre_reset_1_i(0)          <= '0';
      ll_pre_reset_1_i(5 downto 1) <= ll_pre_reset_1_i(4 downto 0);
      ll_reset_1_i                 <= ll_pre_reset_1_i(5);
    end if;
  end process gen_ll_reset_emac1;

  ------------------------------------------------------------------------
  -- REFCLK used for RGMII IODELAYCTRL primitive - Need to supply a 200MHz clock
  ------------------------------------------------------------------------
  --refclk_ibufg : IBUFG port map(I => REFCLK, O => refclk_ibufg_i);
  -- refclk_bufg  : BUFG  port map(I => refclk_ibufg_i, O => refclk_bufg_i);

  refclk_bufg_i <= REFCLK;
  ----------------------------------------------------------------------
  -- Stop the tools from automatically adding in a BUFG on the
  -- GTX_CLK_1 line.
  ----------------------------------------------------------------------
  gtx_clk1_ibuf : IBUF port map (I => GTX_CLK_1, O => gtx_clk_1_i);
-- a state machine to send data (rate or trigger signal) to either
  -- the computers or the read-out cards. the first byte of the send_fifo
  -- will contain a number to decide where to send it. It will look at the
  -- we_en_fifo signal to decide when to send. it will send when this signal
  -- goes low. 
  -- The state machine will have to read out the number of bytes it will send 
  -- which comes from data_count_fifo
  -- states: 
  -- Wait for rising edge on wr_en_fifo
  -- wait for falling egde on wr_en_fifo
  -- read out number of bytes to send and where to send it

  send_udp_data_FSM : process (ll_clk_1_i, ll_reset_1_i_b)
    variable tmp_data : std_logic_vector(7 downto 0);
  begin
    if ll_reset_1_i_b = '0' then
      state      <= INIT;
      rd_en_fifo <= '0';
      
    elsif ll_clk_1_i'event and ll_clk_1_i = '1' then
      transmit_start_enable_i   <= '0';
      transmit_data_length_i    <= (others => '0');
      transmit_data_input_bus_i <= (others => '0');
      rd_en_fifo                <= '0';
      case state is
        when INIT =>
          bytes_to_send <= (others => '0');
          where_to_send <= '1';
          if wr_en_fifo = '1' then
            state <= WAIT_FOR_WR_EN;
          else
            state <= INIT;
          end if;
          
        when WAIT_FOR_WR_EN =>
          if wr_en_fifo = '0' then
            state <= PREP_TRANS;
          else
            state <= WAIT_FOR_WR_EN;
          end if;
          
        when PREP_TRANS =>
          where_to_send <= dout_fifo(0);
          bytes_to_send <= unsigned(data_count_fifo)-1;
          rd_en_fifo    <= '1';
          state         <= PREP_TRANS2;
        when PREP_TRANS2 =>
          state <= START_TRANS;
        when START_TRANS =>
          dout_fifo_tmp <= dout_fifo;
          state         <= START_TRANS2;
        when START_TRANS2 =>
          rd_en_fifo                          <= '1';
          transmit_start_enable_i             <= '1';
          transmit_data_length_i(15 downto 9) <= "0000000";
          transmit_data_length_i(8 downto 0)  <= std_logic_vector(bytes_to_send);
          state                               <= WAIT_FOR_UDP;
        when WAIT_FOR_UDP =>
          if usr_data_trans_phase_on_i = '1' then
            transmit_data_input_bus_i <= dout_fifo_tmp;
            rd_en_fifo                <= '1';
            state                     <= SEND_DATA;
          else
            state <= WAIT_FOR_UDP;
          end if;
        when SEND_DATA =>
          if usr_data_trans_phase_on_i = '1' then
            rd_en_fifo                <= '1';
            transmit_data_input_bus_i <= dout_fifo;
            state                     <= SEND_DATA;
          else
            state <= INIT;
          end if;
        when others =>
          state <= INIT;
      end case;
    end if;
  end process;

  


  
end TOP_LEVEL;