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

library ieee;
use ieee.std_logic_1164.all;



-------------------------------------------------------------------------------
-- The entity declaration for the example design.
-------------------------------------------------------------------------------
entity TEMAC2_example_design is
   port(
      -- Client Receiver Interface - EMAC1
      EMAC1CLIENTRXDVLD               : out std_logic;
      EMAC1CLIENTRXFRAMEDROP          : out std_logic;
      EMAC1CLIENTRXSTATS              : out std_logic_vector(6 downto 0);
      EMAC1CLIENTRXSTATSVLD           : out std_logic;
      EMAC1CLIENTRXSTATSBYTEVLD       : out std_logic;

      -- Client Transmitter Interface - EMAC1
      CLIENTEMAC1TXIFGDELAY           : in  std_logic_vector(7 downto 0);
      EMAC1CLIENTTXSTATS              : out std_logic;
      EMAC1CLIENTTXSTATSVLD           : out std_logic;
      EMAC1CLIENTTXSTATSBYTEVLD       : out std_logic;

      -- MAC Control Interface - EMAC1
      CLIENTEMAC1PAUSEREQ             : in  std_logic;
      CLIENTEMAC1PAUSEVAL             : in  std_logic_vector(15 downto 0);

           
      -- Clock Signals - EMAC1
      GTX_CLK_1                       : in  std_logic;

      -- GMII Interface - EMAC1
      GMII_TXD_1                      : out std_logic_vector(7 downto 0);
      GMII_TX_EN_1                    : out std_logic;
      GMII_TX_ER_1                    : out std_logic;
      GMII_TX_CLK_1                   : out std_logic;
      GMII_RXD_1                      : in  std_logic_vector(7 downto 0);
      GMII_RX_DV_1                    : in  std_logic;
      GMII_RX_ER_1                    : in  std_logic;
      GMII_RX_CLK_1                   : in  std_logic;

      -- Reference clock for RGMII IODELAYs
      REFCLK                          : in  std_logic; 
        
        
      -- Asynchronous Reset
      RESET                           : in  std_logic
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
      TX_CLK_1                        : in  std_logic;

      -- Local link Receiver Interface - EMAC1
      RX_LL_CLOCK_1                   : in  std_logic; 
      RX_LL_RESET_1                   : in  std_logic;
      RX_LL_DATA_1                    : out std_logic_vector(7 downto 0);
      RX_LL_SOF_N_1                   : out std_logic;
      RX_LL_EOF_N_1                   : out std_logic;
      RX_LL_SRC_RDY_N_1               : out std_logic;
      RX_LL_DST_RDY_N_1               : in  std_logic;
      RX_LL_FIFO_STATUS_1             : out std_logic_vector(3 downto 0);

      -- Local link Transmitter Interface - EMAC1
      TX_LL_CLOCK_1                   : in  std_logic;
      TX_LL_RESET_1                   : in  std_logic;
      TX_LL_DATA_1                    : in  std_logic_vector(7 downto 0);
      TX_LL_SOF_N_1                   : in  std_logic;
      TX_LL_EOF_N_1                   : in  std_logic;
      TX_LL_SRC_RDY_N_1               : in  std_logic;
      TX_LL_DST_RDY_N_1               : out std_logic;

      -- Client Receiver Interface - EMAC1
      EMAC1CLIENTRXDVLD               : out std_logic;
      EMAC1CLIENTRXFRAMEDROP          : out std_logic;
      EMAC1CLIENTRXSTATS              : out std_logic_vector(6 downto 0);
      EMAC1CLIENTRXSTATSVLD           : out std_logic;
      EMAC1CLIENTRXSTATSBYTEVLD       : out std_logic;

      -- Client Transmitter Interface - EMAC1
      CLIENTEMAC1TXIFGDELAY           : in  std_logic_vector(7 downto 0);
      EMAC1CLIENTTXSTATS              : out std_logic;
      EMAC1CLIENTTXSTATSVLD           : out std_logic;
      EMAC1CLIENTTXSTATSBYTEVLD       : out std_logic;

      -- MAC Control Interface - EMAC1
      CLIENTEMAC1PAUSEREQ             : in  std_logic;
      CLIENTEMAC1PAUSEVAL             : in  std_logic_vector(15 downto 0);

           
      -- Clock Signals - EMAC1
      GTX_CLK_1                       : in  std_logic;

      -- GMII Interface - EMAC1
      GMII_TXD_1                      : out std_logic_vector(7 downto 0);
      GMII_TX_EN_1                    : out std_logic;
      GMII_TX_ER_1                    : out std_logic;
      GMII_TX_CLK_1                   : out std_logic;
      GMII_RXD_1                      : in  std_logic_vector(7 downto 0);
      GMII_RX_DV_1                    : in  std_logic;
      GMII_RX_ER_1                    : in  std_logic;
      GMII_RX_CLK_1                   : in  std_logic;

        
        
      -- Asynchronous Reset
      RESET                           : in  std_logic
   );
  end component;
 
   ---------------------------------------------------------------------
   --  Component Declaration for 8-bit address swapping module
   ---------------------------------------------------------------------
   component address_swap_module_8
   port (
      rx_ll_clock         : in  std_logic;                     -- Input CLK from MAC Reciever
      rx_ll_reset         : in  std_logic;                     -- Synchronous reset signal
      rx_ll_data_in       : in  std_logic_vector(7 downto 0);  -- Input data
      rx_ll_sof_in_n      : in  std_logic;                     -- Input start of frame
      rx_ll_eof_in_n      : in  std_logic;                     -- Input end of frame
      rx_ll_src_rdy_in_n  : in  std_logic;                     -- Input source ready
      rx_ll_data_out      : out std_logic_vector(7 downto 0);  -- Modified output data
      rx_ll_sof_out_n     : out std_logic;                     -- Output start of frame
      rx_ll_eof_out_n     : out std_logic;                     -- Output end of frame
      rx_ll_src_rdy_out_n : out std_logic;                     -- Output source ready
      rx_ll_dst_rdy_in_n  : in  std_logic                      -- Input destination ready
      );
   end component;

-----------------------------------------------------------------------
-- Signal Declarations
-----------------------------------------------------------------------

    -- Global asynchronous reset
    signal reset_i               : std_logic;

    -- client interface clocking signals - EMAC1
    signal ll_clk_1_i            : std_logic;

    -- address swap transmitter connections - EMAC1
    signal tx_ll_data_1_i      : std_logic_vector(7 downto 0);
    signal tx_ll_sof_n_1_i     : std_logic;
    signal tx_ll_eof_n_1_i     : std_logic;
    signal tx_ll_src_rdy_n_1_i : std_logic;
    signal tx_ll_dst_rdy_n_1_i : std_logic;

    -- address swap receiver connections - EMAC1
    signal rx_ll_data_1_i           : std_logic_vector(7 downto 0);
    signal rx_ll_sof_n_1_i          : std_logic;
    signal rx_ll_eof_n_1_i          : std_logic;
    signal rx_ll_src_rdy_n_1_i      : std_logic;
    signal rx_ll_dst_rdy_n_1_i      : std_logic;

    -- create a synchronous reset in the transmitter clock domain
    signal ll_pre_reset_1_i          : std_logic_vector(5 downto 0);
    signal ll_reset_1_i              : std_logic;


    attribute async_reg : string;
    attribute async_reg of ll_pre_reset_1_i : signal is "true";

    -- Reference clock for RGMII IODELAYs
    signal refclk_ibufg_i            : std_logic;
    signal refclk_bufg_i             : std_logic;


    -- EMAC1 Clocking signals

    signal tx_clk_1                  : std_logic;
    signal rx_clk_1_i                : std_logic;
    signal gmii_rx_clk_1_delay       : std_logic;

    -- IDELAY controller
    signal idelayctrl_reset_1_r      : std_logic_vector(12 downto 0);
    signal idelayctrl_reset_1_i      : std_logic;

    -- Setting attribute for RGMII/GMII IDELAY
    -- For more information on IDELAYCTRL and IDELAY, please refer to
    -- the Virtex-5 User Guide.
    attribute syn_noprune              : boolean;
    attribute syn_noprune of dlyctrl1  : label is true;


    attribute buffer_type : string;

    signal gtx_clk_1_i               : std_logic;
    attribute buffer_type of gtx_clk_1_i  : signal is "none";




-------------------------------------------------------------------------------
-- Main Body of Code
-------------------------------------------------------------------------------


begin

    ---------------------------------------------------------------------------
    -- Reset Input Buffer
    ---------------------------------------------------------------------------
    reset_ibuf : IBUF port map (I => RESET, O => reset_i);


    -- EMAC1 Clocking

    -- Use IDELAY on GMII_RX_CLK_1 to move the clock into
    -- alignment with the data

    -- Instantiate IDELAYCTRL for the IDELAY in Fixed Tap Delay Mode
    dlyctrl1 : IDELAYCTRL port map (
        RDY    => open,
        REFCLK => refclk_bufg_i,
        RST    => idelayctrl_reset_1_i
        );

    delay1rstgen :process (refclk_bufg_i, reset_i)
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
        IDATAIN    => GMII_RX_CLK_1,
        ODATAIN    => '0',
        DATAOUT    => gmii_rx_clk_1_delay,
        DATAIN     => '0',
        C          => '0',
        T          => '0',
        CE         => '0',
        INC        => '0',
        RST        => '0'
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
      TX_CLK_1                        => tx_clk_1,
      -- Local link Receiver Interface - EMAC0
      RX_LL_CLOCK_1                   => ll_clk_1_i,
      RX_LL_RESET_1                   => ll_reset_1_i,
      RX_LL_DATA_1                    => rx_ll_data_1_i,
      RX_LL_SOF_N_1                   => rx_ll_sof_n_1_i,
      RX_LL_EOF_N_1                   => rx_ll_eof_n_1_i,
      RX_LL_SRC_RDY_N_1               => rx_ll_src_rdy_n_1_i,
      RX_LL_DST_RDY_N_1               => rx_ll_dst_rdy_n_1_i,
      RX_LL_FIFO_STATUS_1             => open,

      -- Unused Receiver signals - EMAC1
      EMAC1CLIENTRXDVLD               => EMAC1CLIENTRXDVLD,
      EMAC1CLIENTRXFRAMEDROP          => EMAC1CLIENTRXFRAMEDROP,
      EMAC1CLIENTRXSTATS              => EMAC1CLIENTRXSTATS,
      EMAC1CLIENTRXSTATSVLD           => EMAC1CLIENTRXSTATSVLD,
      EMAC1CLIENTRXSTATSBYTEVLD       => EMAC1CLIENTRXSTATSBYTEVLD,

      -- Local link Transmitter Interface - EMAC0
      TX_LL_CLOCK_1                   => ll_clk_1_i,
      TX_LL_RESET_1                   => ll_reset_1_i,
      TX_LL_DATA_1                    => tx_ll_data_1_i,
      TX_LL_SOF_N_1                   => tx_ll_sof_n_1_i,
      TX_LL_EOF_N_1                   => tx_ll_eof_n_1_i,
      TX_LL_SRC_RDY_N_1               => tx_ll_src_rdy_n_1_i,
      TX_LL_DST_RDY_N_1               => tx_ll_dst_rdy_n_1_i,

      -- Unused Transmitter signals - EMAC1
      CLIENTEMAC1TXIFGDELAY           => CLIENTEMAC1TXIFGDELAY,
      EMAC1CLIENTTXSTATS              => EMAC1CLIENTTXSTATS,
      EMAC1CLIENTTXSTATSVLD           => EMAC1CLIENTTXSTATSVLD,
      EMAC1CLIENTTXSTATSBYTEVLD       => EMAC1CLIENTTXSTATSBYTEVLD,

      -- MAC Control Interface - EMAC1
      CLIENTEMAC1PAUSEREQ             => CLIENTEMAC1PAUSEREQ,
      CLIENTEMAC1PAUSEVAL             => CLIENTEMAC1PAUSEVAL,

           
      -- Clock Signals - EMAC1
      GTX_CLK_1                       => '0',
      -- GMII Interface - EMAC1
      GMII_TXD_1                      => GMII_TXD_1,
      GMII_TX_EN_1                    => GMII_TX_EN_1,
      GMII_TX_ER_1                    => GMII_TX_ER_1,
      GMII_TX_CLK_1                   => GMII_TX_CLK_1,
      GMII_RXD_1                      => GMII_RXD_1,
      GMII_RX_DV_1                    => GMII_RX_DV_1,
      GMII_RX_ER_1                    => GMII_RX_ER_1,
      GMII_RX_CLK_1                   => rx_clk_1_i,

        
        
      -- Asynchronous Reset
      RESET                           => reset_i
    );

    ---------------------------------------------------------------------
    --  Instatiate the address swapping module
    ---------------------------------------------------------------------
    client_side_asm_emac1 : address_swap_module_8
      port map (
        rx_ll_clock         => ll_clk_1_i,
        rx_ll_reset         => ll_reset_1_i,
        rx_ll_data_in       => rx_ll_data_1_i,
        rx_ll_sof_in_n      => rx_ll_sof_n_1_i,
        rx_ll_eof_in_n      => rx_ll_eof_n_1_i,
        rx_ll_src_rdy_in_n  => rx_ll_src_rdy_n_1_i,
        rx_ll_data_out      => tx_ll_data_1_i,
        rx_ll_sof_out_n     => tx_ll_sof_n_1_i,
        rx_ll_eof_out_n     => tx_ll_eof_n_1_i,
        rx_ll_src_rdy_out_n => tx_ll_src_rdy_n_1_i,
        rx_ll_dst_rdy_in_n  => tx_ll_dst_rdy_n_1_i
    );

    rx_ll_dst_rdy_n_1_i     <= tx_ll_dst_rdy_n_1_i;


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
    refclk_ibufg : IBUFG port map(I => REFCLK, O => refclk_ibufg_i);
    refclk_bufg  : BUFG  port map(I => refclk_ibufg_i, O => refclk_bufg_i);


    ----------------------------------------------------------------------
    -- Stop the tools from automatically adding in a BUFG on the
    -- GTX_CLK_1 line.
    ----------------------------------------------------------------------
    gtx_clk1_ibuf : IBUF port map (I => GTX_CLK_1, O => gtx_clk_1_i);


 
end TOP_LEVEL;
