-------------------------------------------------------------------------------
-- Title      : Virtex-5 Ethernet MAC Example Design Wrapper
-- Project    : Virtex-5 Ethernet MAC Wrappers
-------------------------------------------------------------------------------
-- File       : v5_emac_v1_5_example_design.vhd
-------------------------------------------------------------------------------
-- Copyright (c) 2004-2008 by Xilinx, Inc. All rights reserved.
-- This text/file contains proprietary, confidential
-- information of Xilinx, Inc., is distributed under license
-- from Xilinx, Inc., and may be used, copied and/or
-- disclosed only pursuant to the terms of a valid license
-- agreement with Xilinx, Inc. Xilinx hereby grants you
-- a license to use this text/file solely for design, simulation,
-- implementation and creation of design files limited
-- to Xilinx devices or technologies. Use with non-Xilinx
-- devices or technologies is expressly prohibited and
-- immediately terminates your license unless covered by
-- a separate agreement.
--
-- Xilinx is providing this design, code, or information
-- "as is" solely for use in developing programs and
-- solutions for Xilinx devices. By providing this design,
-- code, or information as one possible implementation of
-- this feature, application or standard, Xilinx is making no
-- representation that this implementation is free from any
-- claims of infringement. You are responsible for
-- obtaining any rights you may require for your implementation.
-- Xilinx expressly disclaims any warranty whatsoever with
-- respect to the adequacy of the implementation, including
-- but not limited to any warranties or representations that this
-- implementation is free from claims of infringement, implied
-- warranties of merchantability or fitness for a particular
-- purpose.
--
-- Xilinx products are not intended for use in life support
-- appliances, devices, or systems. Use in such applications are
-- expressly prohibited.
--
-- This copyright and support notice must be retained as part
-- of this text at all times. (c) Copyright 2004-2008 Xilinx, Inc.
-- All rights reserved.

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

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.components.all;
use work.constants.all;


-------------------------------------------------------------------------------
-- The entity declaration for the example design.
-------------------------------------------------------------------------------
entity v5_emac_v1_5_example_design is
  port(
    clk200 : in std_logic;
    rst_b  : in std_logic;

    rate_cards                : in  std_logic_vector(NUMBER_OF_ROCS - 1 downto 0);
    coincidence               : in  std_logic_vector(NUMBER_OF_ROCS - 1 downto 0);
    -- Client Receiver Interface - EMAC0
    EMAC0CLIENTRXDVLD         : out std_logic;
    EMAC0CLIENTRXFRAMEDROP    : out std_logic;
    EMAC0CLIENTRXSTATS        : out std_logic_vector(6 downto 0);
    EMAC0CLIENTRXSTATSVLD     : out std_logic;
    EMAC0CLIENTRXSTATSBYTEVLD : out std_logic;

    -- Client Transmitter Interface - EMAC0
    CLIENTEMAC0TXIFGDELAY     : in  std_logic_vector(7 downto 0);
    EMAC0CLIENTTXSTATS        : out std_logic;
    EMAC0CLIENTTXSTATSVLD     : out std_logic;
    EMAC0CLIENTTXSTATSBYTEVLD : out std_logic;

    -- MAC Control Interface - EMAC0
    CLIENTEMAC0PAUSEREQ : in std_logic;
    CLIENTEMAC0PAUSEVAL : in std_logic_vector(15 downto 0);


    -- Clock Signals - EMAC0
    GTX_CLK_0 : in std_logic;

    -- GMII Interface - EMAC0
    GMII_TXD_0    : out std_logic_vector(7 downto 0);
    GMII_TX_EN_0  : out std_logic;
    GMII_TX_ER_0  : out std_logic;
    GMII_TX_CLK_0 : out std_logic;
    GMII_RXD_0    : in  std_logic_vector(7 downto 0);
    GMII_RX_DV_0  : in  std_logic;
    GMII_RX_ER_0  : in  std_logic;
    GMII_RX_CLK_0 : in  std_logic;

    MII_TX_CLK_0 : in  std_logic;
    PHY_RESET_0  : out std_logic;
    GMII_COL_0   : in  std_logic;
    GMII_CRS_0   : in  std_logic

    -- Reference clock for RGMII IODELAYs
    --REFCLK                          : in  std_logic 
    );
end v5_emac_v1_5_example_design;


architecture TOP_LEVEL of v5_emac_v1_5_example_design is
  signal DSwitch : std_logic_vector(7 downto 0);

  signal reset  : std_logic;
  signal REFCLK : std_logic;            --REFCLK

  signal input_word : std_logic_vector(15 downto 0);


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

  -- signals for the UDP sender FSM
  type state_types is (INIT, WAIT_FOR_WR_EN, PREP_TRANS, PREP_TRANS2, START_TRANS,START_TRANS2,PREP_FIRST_BYTE, WAIT_FOR_UDP, SEND_DATA);
  signal state : state_types;
  signal bytes_to_send : unsigned(8 downto 0);
   signal dout_fifo_tmp       : std_logic_vector(7 downto 0);
  signal where_to_send : std_logic;



-------------------------------------------------------------------------------
-- Component Declarations for lower hierarchial level entities
-------------------------------------------------------------------------------
  -- Component Declaration for the TEMAC wrapper with 
  -- Local Link FIFO.
  component v5_emac_v1_5_locallink is
    port(
      -- EMAC0 Clocking
      -- TX Client Clock output from EMAC0
      TX_CLIENT_CLK_OUT_0 : out std_logic;
      -- RX Client Clock output from EMAC0
      RX_CLIENT_CLK_OUT_0 : out std_logic;
      -- TX PHY Clock output from EMAC0
      TX_PHY_CLK_OUT_0    : out std_logic;
      -- EMAC0 TX Client Clock input from BUFG
      TX_CLIENT_CLK_0     : in  std_logic;
      -- EMAC0 RX Client Clock input from BUFG
      RX_CLIENT_CLK_0     : in  std_logic;
      -- EMAC0 TX PHY Clock input from BUFG
      TX_PHY_CLK_0        : in  std_logic;

      -- Local link Receiver Interface - EMAC0
      RX_LL_CLOCK_0       : in  std_logic;
      RX_LL_RESET_0       : in  std_logic;
      RX_LL_DATA_0        : out std_logic_vector(7 downto 0);
      RX_LL_SOF_N_0       : out std_logic;
      RX_LL_EOF_N_0       : out std_logic;
      RX_LL_SRC_RDY_N_0   : out std_logic;
      RX_LL_DST_RDY_N_0   : in  std_logic;
      RX_LL_FIFO_STATUS_0 : out std_logic_vector(3 downto 0);

      -- Local link Transmitter Interface - EMAC0
      TX_LL_CLOCK_0     : in  std_logic;
      TX_LL_RESET_0     : in  std_logic;
      TX_LL_DATA_0      : in  std_logic_vector(7 downto 0);
      TX_LL_SOF_N_0     : in  std_logic;
      TX_LL_EOF_N_0     : in  std_logic;
      TX_LL_SRC_RDY_N_0 : in  std_logic;
      TX_LL_DST_RDY_N_0 : out std_logic;

      -- Client Receiver Interface - EMAC0
      EMAC0CLIENTRXDVLD         : out std_logic;
      EMAC0CLIENTRXFRAMEDROP    : out std_logic;
      EMAC0CLIENTRXSTATS        : out std_logic_vector(6 downto 0);
      EMAC0CLIENTRXSTATSVLD     : out std_logic;
      EMAC0CLIENTRXSTATSBYTEVLD : out std_logic;

      -- Client Transmitter Interface - EMAC0
      CLIENTEMAC0TXIFGDELAY     : in  std_logic_vector(7 downto 0);
      EMAC0CLIENTTXSTATS        : out std_logic;
      EMAC0CLIENTTXSTATSVLD     : out std_logic;
      EMAC0CLIENTTXSTATSBYTEVLD : out std_logic;

      -- MAC Control Interface - EMAC0
      CLIENTEMAC0PAUSEREQ : in std_logic;
      CLIENTEMAC0PAUSEVAL : in std_logic_vector(15 downto 0);


      -- Clock Signals - EMAC0
      GTX_CLK_0 : in std_logic;

      -- GMII Interface - EMAC0
      GMII_TXD_0    : out std_logic_vector(7 downto 0);
      GMII_TX_EN_0  : out std_logic;
      GMII_TX_ER_0  : out std_logic;
      GMII_TX_CLK_0 : out std_logic;
      GMII_RXD_0    : in  std_logic_vector(7 downto 0);
      GMII_RX_DV_0  : in  std_logic;
      GMII_RX_ER_0  : in  std_logic;
      GMII_RX_CLK_0 : in  std_logic;

      MII_TX_CLK_0 : in std_logic;
      GMII_COL_0   : in std_logic;
      GMII_CRS_0   : in std_logic;



      -- Asynchronous Reset
      RESET : in std_logic
      );
  end component;

  ---------------------------------------------------------------------
  --  Component Declaration for 8-bit address swapping module
  ---------------------------------------------------------------------
--  component address_swap_module_8
--    port (
--      rx_ll_clock         : in  std_logic;  -- Input CLK from MAC Reciever
--      rx_ll_reset         : in  std_logic;  -- Synchronous reset signal
--      rx_ll_data_in       : in  std_logic_vector(7 downto 0);  -- Input data
--      rx_ll_sof_in_n      : in  std_logic;  -- Input start of frame
--      rx_ll_eof_in_n      : in  std_logic;  -- Input end of frame
--      rx_ll_src_rdy_in_n  : in  std_logic;  -- Input source ready
--      rx_ll_data_out      : out std_logic_vector(7 downto 0);  -- Modified output data
--      rx_ll_sof_out_n     : out std_logic;  -- Output start of frame
--      rx_ll_eof_out_n     : out std_logic;  -- Output end of frame
--      rx_ll_src_rdy_out_n : out std_logic;  -- Output source ready
--      rx_ll_dst_rdy_in_n  : in  std_logic   -- Input destination ready
--      );
--  end component;



-----------------------------------------------------------------------
-- Signal Declarations
-----------------------------------------------------------------------

  -- Global asynchronous reset
  signal reset_i : std_logic;

  -- client interface clocking signals - EMAC0
  signal ll_clk_0_i : std_logic;

  -- address swap transmitter connections - EMAC0
  signal tx_ll_data_0_i      : std_logic_vector(7 downto 0);
  signal tx_ll_sof_n_0_i     : std_logic;
  signal tx_ll_eof_n_0_i     : std_logic;
  signal tx_ll_src_rdy_n_0_i : std_logic;
  signal tx_ll_dst_rdy_n_0_i : std_logic;

  -- address swap receiver connections - EMAC0
  signal rx_ll_data_0_i      : std_logic_vector(7 downto 0);
  signal rx_ll_sof_n_0_i     : std_logic;
  signal rx_ll_eof_n_0_i     : std_logic;
  signal rx_ll_src_rdy_n_0_i : std_logic;
  signal rx_ll_dst_rdy_n_0_i : std_logic;

  -- create a synchronous reset in the transmitter clock domain
  signal ll_pre_reset_0_i : std_logic_vector(5 downto 0);
  signal ll_reset_0_i     : std_logic;

  attribute async_reg                     : string;
  attribute async_reg of ll_pre_reset_0_i : signal is "true";


  -- Reference clock for RGMII IODELAYs
  signal refclk_ibufg_i : std_logic;
  signal refclk_bufg_i  : std_logic;

  -- EMAC0 Clocking signals

  -- GMII input clocks to wrappers
  signal tx_clk_0            : std_logic;
  signal rx_clk_0_i          : std_logic;
  signal gmii_rx_clk_0_delay : std_logic;

  -- IDELAY controller
  signal idelayctrl_reset_0_r : std_logic_vector(12 downto 0);
  signal idelayctrl_reset_0_i : std_logic;

  -- Setting attribute for RGMII/GMII IDELAY
  -- For more information on IDELAYCTRL and IDELAY, please refer to
  -- the Virtex-5 User Guide.
  attribute syn_noprune             : boolean;
  attribute syn_noprune of dlyctrl0 : label is true;


  -- GMII client clocks
  signal tx_client_clk_0_o : std_logic;
  signal tx_client_clk_0   : std_logic;
  signal rx_client_clk_0_o : std_logic;
  signal rx_client_clk_0   : std_logic;
  -- GMII PHY clocks
  signal tx_phy_clk_0_o    : std_logic;
  signal tx_phy_clk_0      : std_logic;

  attribute buffer_type                : string;
  signal gtx_clk_0_i                   : std_logic;
  attribute buffer_type of gtx_clk_0_i : signal is "none";


  -- signals to and from the UDP/IP core

  signal transmit_start_enable    : std_logic;
  signal transmit_data_length     : std_logic_vector (15 downto 0);
  signal usr_data_trans_phase_on  : std_logic;
  signal transmit_data_input_bus  : std_logic_vector (7 downto 0);
  signal start_of_frame_O         : std_logic;
  signal end_of_frame_O           : std_logic;
  signal source_ready             : std_logic;
  signal transmit_data_output_bus : std_logic_vector (7 downto 0);
  signal rx_sof                   : std_logic;
  signal rx_eof                   : std_logic;
  signal input_bus                : std_logic_vector(7 downto 0);
  signal valid_out_usr_data       : std_logic;
  signal usr_data_output_bus      : std_logic_vector (7 downto 0);


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


 

-------------------------------------------------------------------------------
-- Main Body of Code
-------------------------------------------------------------------------------

  signal counter : integer range 0 to 1023;

begin
  DSwitch     <= "00111110";  --set the ip, we don't have a dip-switch here
  reset       <= not rst_b;
  reset_i     <= not rst_b;
  PHY_RESET_0 <= rst_b;
  REFCLK      <= clk200;

  we_others  <= we_rate_counter;
  wr_en_fifo <= we_others;
  din_fifo   <= din_rate_counter;
  ---------------------------------------------------------------------------
  -- Reset Input Buffer
  ---------------------------------------------------------------------------
  --reset_ibuf : IBUF port map (I => RESET, O => reset_i);

  -- EMAC0 Clocking

  -- Use IDELAY on GMII_RX_CLK_0 to move the clock into
  -- alignment with the data



  -- Instantiate IDELAYCTRL for the IDELAY in Fixed Tap Delay Mode
  dlyctrl0 : IDELAYCTRL port map (
    RDY    => open,
    REFCLK => refclk_bufg_i,            -- This needs a 200 mhz input
    RST    => idelayctrl_reset_0_i
    );

  delay0rstgen : process (refclk_bufg_i, reset_i)
  begin
    if (reset_i = '1') then
      idelayctrl_reset_0_r(0)           <= '0';
      idelayctrl_reset_0_r(12 downto 1) <= (others => '1');
    elsif refclk_bufg_i'event and refclk_bufg_i = '1' then
      idelayctrl_reset_0_r(0)           <= '0';
      idelayctrl_reset_0_r(12 downto 1) <= idelayctrl_reset_0_r(11 downto 0);
    end if;
  end process delay0rstgen;

  idelayctrl_reset_0_i <= idelayctrl_reset_0_r(12);

  -- Please modify the value of the IOBDELAYs according to your design.
  -- For more information on IDELAYCTRL and IODELAY, please refer to
  -- the Virtex-5 User Guide.
  gmii_rxc0_delay : IODELAY
    generic map (
      IDELAY_TYPE    => "FIXED",
      IDELAY_VALUE   => 0,
      DELAY_SRC      => "I",
      SIGNAL_PATTERN => "CLOCK"
      )
    port map (
      IDATAIN => GMII_RX_CLK_0,
      ODATAIN => '0',
      DATAOUT => gmii_rx_clk_0_delay,
      DATAIN  => '0',
      C       => '0',
      T       => '0',
      CE      => '0',
      INC     => '0',
      RST     => '0'
      );


--  -- Put the PHY clocks from the EMAC through BUFGs.
--  -- Used to clock the PHY side of the EMAC wrappers.
  bufg_phy_tx_0 : BUFG port map (I => tx_phy_clk_0_o, O => tx_phy_clk_0);
  bufg_phy_rx_0 : BUFG port map (I => gmii_rx_clk_0_delay, O => rx_clk_0_i);
--
--  -- Put the client clocks from the EMAC through BUFGs.
--  -- Used to clock the client side of the EMAC wrappers.
  bufg_client_tx_0 : BUFG port map (I => tx_client_clk_0_o, O => tx_client_clk_0);
  bufg_client_rx_0 : BUFG port map (I => rx_client_clk_0_o, O => rx_client_clk_0);
--
  ll_clk_0_i <= tx_client_clk_0;
--DEBUG SHIT
--  ll_clk_0_i <= clk200;
 -- usr_data_trans_phase_on_i <=   GMII_CRS_0;
 
 


  ------------------------------------------------------------------------
  -- Instantiate the EMAC Wrapper with LL FIFO 
  -- (v5_emac_v1_5_locallink.v)
  ------------------------------------------------------------------------
  v5_emac_ll : v5_emac_v1_5_locallink
    port map (
      -- EMAC0 Clocking
      -- TX Client Clock output from EMAC0
      TX_CLIENT_CLK_OUT_0 => tx_client_clk_0_o,
      -- RX Client Clock output from EMAC0
      RX_CLIENT_CLK_OUT_0 => rx_client_clk_0_o,
      -- TX PHY Clock output from EMAC0
      TX_PHY_CLK_OUT_0    => tx_phy_clk_0_o,
      -- EMAC0 TX Client Clock input from BUFG
      TX_CLIENT_CLK_0     => tx_client_clk_0,
      -- EMAC0 RX Client Clock input from BUFG
      RX_CLIENT_CLK_0     => rx_client_clk_0,
      -- EMAC0 TX PHY Clock input from BUFG
      TX_PHY_CLK_0        => tx_phy_clk_0,
      -- Local link Receiver Interface - EMAC0
      RX_LL_CLOCK_0       => ll_clk_0_i,
      RX_LL_RESET_0       => ll_reset_0_i,
      RX_LL_DATA_0        => rx_ll_data_0_i,

      RX_LL_SOF_N_0       => rx_ll_sof_n_0_i,
      RX_LL_EOF_N_0       => rx_ll_eof_n_0_i,
      RX_LL_SRC_RDY_N_0   => rx_ll_src_rdy_n_0_i,
      RX_LL_DST_RDY_N_0   => rx_ll_dst_rdy_n_0_i,
      RX_LL_FIFO_STATUS_0 => open,

      -- Unused Receiver signals - EMAC0
      EMAC0CLIENTRXDVLD         => EMAC0CLIENTRXDVLD,
      EMAC0CLIENTRXFRAMEDROP    => EMAC0CLIENTRXFRAMEDROP,
      EMAC0CLIENTRXSTATS        => EMAC0CLIENTRXSTATS,
      EMAC0CLIENTRXSTATSVLD     => EMAC0CLIENTRXSTATSVLD,
      EMAC0CLIENTRXSTATSBYTEVLD => EMAC0CLIENTRXSTATSBYTEVLD,

      -- Local link Transmitter Interface - EMAC0
      TX_LL_CLOCK_0     => ll_clk_0_i,
      TX_LL_RESET_0     => ll_reset_0_i,
      TX_LL_DATA_0      => tx_ll_data_0_i,
      TX_LL_SOF_N_0     => tx_ll_sof_n_0_i,
      TX_LL_EOF_N_0     => tx_ll_eof_n_0_i,
      TX_LL_SRC_RDY_N_0 => tx_ll_src_rdy_n_0_i,
      TX_LL_DST_RDY_N_0 => tx_ll_dst_rdy_n_0_i,

      -- Unused Transmitter signals - EMAC0
      CLIENTEMAC0TXIFGDELAY     => CLIENTEMAC0TXIFGDELAY,
      EMAC0CLIENTTXSTATS        => EMAC0CLIENTTXSTATS,
      EMAC0CLIENTTXSTATSVLD     => EMAC0CLIENTTXSTATSVLD,
      EMAC0CLIENTTXSTATSBYTEVLD => EMAC0CLIENTTXSTATSBYTEVLD,

      -- MAC Control Interface - EMAC0
      CLIENTEMAC0PAUSEREQ => CLIENTEMAC0PAUSEREQ,
      CLIENTEMAC0PAUSEVAL => CLIENTEMAC0PAUSEVAL,


      -- Clock Signals - EMAC0
      GTX_CLK_0     => gtx_clk_0_i,
      -- GMII Interface - EMAC0
      GMII_TXD_0    => GMII_TXD_0,
      GMII_TX_EN_0  => GMII_TX_EN_0,
      GMII_TX_ER_0  => GMII_TX_ER_0,
      GMII_TX_CLK_0 => GMII_TX_CLK_0,
      GMII_RXD_0    => GMII_RXD_0,
      GMII_RX_DV_0  => GMII_RX_DV_0,
      GMII_RX_ER_0  => GMII_RX_ER_0,
      GMII_RX_CLK_0 => rx_clk_0_i,

      MII_TX_CLK_0 => MII_TX_CLK_0,
      GMII_COL_0   => GMII_COL_0,
      GMII_CRS_0   => GMII_CRS_0,

      -- Asynchronous Reset
      RESET => reset_i
      );


  rx_ll_dst_rdy_n_0_i <= tx_ll_dst_rdy_n_0_i;

  tx_ll_sof_n_0_i     <= start_of_frame_O;
  tx_ll_eof_n_0_i     <= end_of_frame_O;
  tx_ll_data_0_i      <= transmit_data_output_bus;
  tx_ll_src_rdy_n_0_i <= source_ready;


  --RX:
  rx_sof    <= rx_ll_sof_n_0_i;
  rx_eof    <= rx_ll_eof_n_0_i;
  input_bus <= rx_ll_data_0_i;




--  send_empty : process(ll_clk_0_i, reset_i)
--  begin
--    if reset_i = '1' then
--      transmit_start_enable   <= '0';
--      transmit_data_length    <= (others => '0');
--      transmit_data_input_bus <= (others => '0');
--      counter                 <= 0;
--
--    elsif ll_clk_0_i'event and ll_clk_0_i = '1' then
--
--                  transmit_start_enable   <= '0';
--                  transmit_data_length    <= "0000000000000001";
--                  transmit_data_input_bus <= "11111111";
--                                              if counter = 25000 then
--                                                      counter               <= 0;
--                                                      transmit_start_enable <= '1';
--                                              end if;
--                  counter                 <= counter + 1;
--    end if;
--  end process send_empty;


  -- Create synchronous reset in the transmitter clock domain.
  gen_ll_reset_emac0 : process (ll_clk_0_i, reset_i)
  begin
    if reset_i = '1' then
      ll_pre_reset_0_i <= (others => '1');
      ll_reset_0_i     <= '1';
    elsif ll_clk_0_i'event and ll_clk_0_i = '1' then
      ll_pre_reset_0_i(0)          <= '0';
      ll_pre_reset_0_i(5 downto 1) <= ll_pre_reset_0_i(4 downto 0);
      ll_reset_0_i                 <= ll_pre_reset_0_i(5);
    end if;
  end process gen_ll_reset_emac0;



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
  --
  --
 
    send_udp_data_FSM : process (ll_clk_0_i, rst_b)
		variable tmp_data : std_logic_vector(7 downto 0);
    begin
      if rst_b = '0' then
        state      <= INIT;
        rd_en_fifo <= '0';
        
      elsif ll_clk_0_i'event and ll_clk_0_i = '1' then
        transmit_start_enable_i   <= '0';
        transmit_data_length_i    <= (others => '0');
        transmit_data_input_bus_i <= (others => '0');
        rd_en_fifo                <= '0';

        case state is
          when INIT =>
            bytes_to_send <= (others => '0');
            where_to_send <= '0';

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
				 bytes_to_send  <= unsigned(data_count_fifo)-1;
				 rd_en_fifo <= '1';
				 state <= PREP_TRANS2;
				 
				 when PREP_TRANS2 =>
				 state <= START_TRANS;
					

          when START_TRANS =>
            
            
				dout_fifo_tmp <= dout_fifo;
            state         <= START_TRANS2;
				
			when START_TRANS2 =>
				rd_en_fifo <= '1';
				transmit_start_enable_i <= '1';
				transmit_data_length_i(15 downto 9) <= "0000000";
            transmit_data_length_i(8 downto 0)  <= std_logic_vector(bytes_to_send);
				state <= WAIT_FOR_UDP;
						
				

          when WAIT_FOR_UDP =>

            if usr_data_trans_phase_on_i = '1' then
				  transmit_data_input_bus_i <= dout_fifo_tmp;
				  rd_en_fifo <= '1';
              state                     <= SEND_DATA;
            else						  
              state <= WAIT_FOR_UDP;
            end if;
				
            
          when SEND_DATA =>
            if usr_data_trans_phase_on_i = '1' then
              rd_en_fifo                <= '1';
              transmit_data_input_bus_i <= dout_fifo;
              state <= SEND_DATA;
            else
              state <= INIT;
            end if;
            
          when others =>
            state <= INIT;
        end case;
        
      end if;
    end process;
	 
	 

     transmit_start_enable <= transmit_start_enable_i;
     transmit_data_length <= transmit_data_length_i;
     usr_data_trans_phase_on_i <= usr_data_trans_phase_on;
	  transmit_data_input_bus <= transmit_data_input_bus_i;
 
     --source_ready      
    --transmit_data_output_bus 

     -- input_bus              
 
      --usr_data_output_bus      => usr_data_output_bus,


  
UDP_IP_Core_1 : entity work.UDP_IP_Core
    generic map (
      --DestMAC =>x"00c09fbf33b0",  --ferrari, must be readout computer eventually

      DestMAC  => x"000e0c333384",      --compet002
      DestIP   => x"C0A80140",  --192.168.1.64, change to readout computer ip.
      DestPort => x"5556",
      SrcPort  => x"5557")
port map(
  rst => ll_reset_0_i,
    clk_125MHz => ll_clk_0_i,
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


    rate_counter_1 : rate_counter
      port map(
        clk         => ll_clk_0_i,      --125 mhz
        rst_b       => rst_b,
        rate_cards  => rate_cards,
        coincidence => coincidence,
        fifo_empty  => empty_fifo,
        we          => we_rate_counter,
        we_others   => we_others,
        din         => din_rate_counter
        );

    send_fifo : fifo_generator_v4_4
      port map(
        clk        => ll_clk_0_i,       --125 mhz
        din        => din_fifo,
        rd_en      => rd_en_fifo,
        rst        => reset,
        wr_en      => wr_en_fifo,
        data_count => data_count_fifo,
        dout       => dout_fifo,
        empty      => empty_fifo,
        full       => full_fifo
        );



    ------------------------------------------------------------------------
    -- REFCLK used for RGMII IODELAYCTRL primitive - Need to supply a 200MHz clock
    ------------------------------------------------------------------------
    --refclk_ibufg : IBUFG port map(I => REFCLK, O => refclk_ibufg_i);
 --  refclk_bufg : BUFG port map(I => refclk, O => refclk_bufg_i);
	 
refclk_bufg_i <= clk200;
    ----------------------------------------------------------------------
    -- Stop the tools from automatically adding in a BUFG on the
    -- GTX_CLK_0 line.
    ----------------------------------------------------------------------
    gtx_clk0_ibuf : IBUF port map (I => GTX_CLK_0, O => gtx_clk_0_i);




    end TOP_LEVEL;
