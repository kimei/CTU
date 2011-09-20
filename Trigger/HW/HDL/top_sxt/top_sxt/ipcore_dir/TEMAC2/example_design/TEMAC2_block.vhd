-------------------------------------------------------------------------------
-- Title      : Virtex-5 Ethernet MAC Wrapper Top Level
-- Project    : Virtex-5 Embedded Tri-Mode Ethernet MAC Wrapper
-- File       : TEMAC2_block.vhd
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
-- Description:  This is the EMAC block level VHDL design for the Virtex-5 
--               Embedded Ethernet MAC Example Design.  It is intended that
--               this example design can be quickly adapted and downloaded onto
--               an FPGA to provide a real hardware test environment.
--
--               The block level:
--
--               * instantiates all clock management logic required (BUFGs, 
--                 DCMs) to operate the EMAC and its example design;
--
--               * instantiates appropriate PHY interface modules (GMII, MII,
--                 RGMII, SGMII or 1000BASE-X) as required based on the user
--                 configuration.
--
--
--               Please refer to the Datasheet, Getting Started Guide, and
--               the Virtex-5 Embedded Tri-Mode Ethernet MAC User Gude for
--               further information.
-------------------------------------------------------------------------------


library unisim;
use unisim.vcomponents.all;

library ieee;
use ieee.std_logic_1164.all;



-------------------------------------------------------------------------------
-- The entity declaration for the top level design.
-------------------------------------------------------------------------------
entity TEMAC2_block is
   port(
      -- EMAC1 Clocking
      -- EMAC1 TX Clock input from BUFG
      TX_CLK_1                        : in  std_logic;

      -- Client Receiver Interface - EMAC1
      EMAC1CLIENTRXD                  : out std_logic_vector(7 downto 0);
      EMAC1CLIENTRXDVLD               : out std_logic;
      EMAC1CLIENTRXGOODFRAME          : out std_logic;
      EMAC1CLIENTRXBADFRAME           : out std_logic;
      EMAC1CLIENTRXFRAMEDROP          : out std_logic;
      EMAC1CLIENTRXSTATS              : out std_logic_vector(6 downto 0);
      EMAC1CLIENTRXSTATSVLD           : out std_logic;
      EMAC1CLIENTRXSTATSBYTEVLD       : out std_logic;

      -- Client Transmitter Interface - EMAC1
      CLIENTEMAC1TXD                  : in  std_logic_vector(7 downto 0);
      CLIENTEMAC1TXDVLD               : in  std_logic;
      EMAC1CLIENTTXACK                : out std_logic;
      CLIENTEMAC1TXFIRSTBYTE          : in  std_logic;
      CLIENTEMAC1TXUNDERRUN           : in  std_logic;
      EMAC1CLIENTTXCOLLISION          : out std_logic;
      EMAC1CLIENTTXRETRANSMIT         : out std_logic;
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
end TEMAC2_block;


architecture TOP_LEVEL of TEMAC2_block is

-------------------------------------------------------------------------------
-- Component Declarations for lower hierarchial level entities
-------------------------------------------------------------------------------
  -- Component Declaration for the main EMAC wrapper
  component TEMAC2 is
    port(
      -- Client Receiver Interface - EMAC1
      EMAC1CLIENTRXCLIENTCLKOUT       : out std_logic;
      CLIENTEMAC1RXCLIENTCLKIN        : in  std_logic;
      EMAC1CLIENTRXD                  : out std_logic_vector(7 downto 0);
      EMAC1CLIENTRXDVLD               : out std_logic;
      EMAC1CLIENTRXDVLDMSW            : out std_logic;
      EMAC1CLIENTRXGOODFRAME          : out std_logic;
      EMAC1CLIENTRXBADFRAME           : out std_logic;
      EMAC1CLIENTRXFRAMEDROP          : out std_logic;
      EMAC1CLIENTRXSTATS              : out std_logic_vector(6 downto 0);
      EMAC1CLIENTRXSTATSVLD           : out std_logic;
      EMAC1CLIENTRXSTATSBYTEVLD       : out std_logic;

      -- Client Transmitter Interface - EMAC1
      EMAC1CLIENTTXCLIENTCLKOUT       : out std_logic;
      CLIENTEMAC1TXCLIENTCLKIN        : in  std_logic;
      CLIENTEMAC1TXD                  : in  std_logic_vector(7 downto 0);
      CLIENTEMAC1TXDVLD               : in  std_logic;
      CLIENTEMAC1TXDVLDMSW            : in  std_logic;
      EMAC1CLIENTTXACK                : out std_logic;
      CLIENTEMAC1TXFIRSTBYTE          : in  std_logic;
      CLIENTEMAC1TXUNDERRUN           : in  std_logic;
      EMAC1CLIENTTXCOLLISION          : out std_logic;
      EMAC1CLIENTTXRETRANSMIT         : out std_logic;
      CLIENTEMAC1TXIFGDELAY           : in  std_logic_vector(7 downto 0);
      EMAC1CLIENTTXSTATS              : out std_logic;
      EMAC1CLIENTTXSTATSVLD           : out std_logic;
      EMAC1CLIENTTXSTATSBYTEVLD       : out std_logic;

      -- MAC Control Interface - EMAC1
      CLIENTEMAC1PAUSEREQ             : in  std_logic;
      CLIENTEMAC1PAUSEVAL             : in  std_logic_vector(15 downto 0);

      -- Clock Signals - EMAC1
      GTX_CLK_1                       : in  std_logic;
      PHYEMAC1TXGMIIMIICLKIN          : in  std_logic;
      EMAC1PHYTXGMIIMIICLKOUT         : out std_logic;

      -- GMII Interface - EMAC1
      GMII_TXD_1                      : out std_logic_vector(7 downto 0);
      GMII_TX_EN_1                    : out std_logic;
      GMII_TX_ER_1                    : out std_logic;
      GMII_RXD_1                      : in  std_logic_vector(7 downto 0);
      GMII_RX_DV_1                    : in  std_logic;
      GMII_RX_ER_1                    : in  std_logic;
      GMII_RX_CLK_1                   : in  std_logic;

      DCM_LOCKED_1                    : in  std_logic;

      -- Asynchronous Reset
      RESET                           : in  std_logic
    );
  end component;


 
  -- Component Declaration for the GMII Physcial Interface 
  component gmii_if
    port(
      RESET                           : in  std_logic;
      -- GMII Interface
      GMII_TXD                        : out std_logic_vector(7 downto 0);
      GMII_TX_EN                      : out std_logic;
      GMII_TX_ER                      : out std_logic;
      GMII_TX_CLK                     : out std_logic;
      GMII_RXD                        : in  std_logic_vector(7 downto 0);
      GMII_RX_DV                      : in  std_logic;
      GMII_RX_ER                      : in  std_logic;
      -- MAC Interface
      TXD_FROM_MAC                    : in  std_logic_vector(7 downto 0);
      TX_EN_FROM_MAC                  : in  std_logic;
      TX_ER_FROM_MAC                  : in  std_logic;
      TX_CLK                          : in  std_logic;
      RXD_TO_MAC                      : out std_logic_vector(7 downto 0);
      RX_DV_TO_MAC                    : out std_logic;
      RX_ER_TO_MAC                    : out std_logic;
      RX_CLK                          : in  std_logic);
  end component;


-------------------------------------------------------------------------------
-- Signal Declarations
-------------------------------------------------------------------------------

    --  Power and ground signals
    signal gnd_i                          : std_logic;
    signal vcc_i                          : std_logic;

    -- Asynchronous reset signals
    signal reset_ibuf_i                   : std_logic;
    signal reset_i                        : std_logic;


    -- EMAC1 Client Clocking Signals
    signal rx_client_clk_out_1_i          : std_logic;
    signal rx_client_clk_in_1_i           : std_logic;
    signal tx_client_clk_out_1_i          : std_logic;
    signal tx_client_clk_in_1_i           : std_logic;
    -- EMAC1 Physical Interface Clocking Signals
    signal tx_gmii_mii_clk_out_1_i        : std_logic;
    signal tx_gmii_mii_clk_in_1_i         : std_logic;
    -- EMAC1 Physical Interface Signals
    signal gmii_tx_en_1_i                 : std_logic;
    signal gmii_tx_er_1_i                 : std_logic;
    signal gmii_txd_1_i                   : std_logic_vector(7 downto 0);
    signal gmii_rx_clk_1_i                : std_logic;
    signal gmii_rx_dv_1_r                 : std_logic;
    signal gmii_rx_er_1_r                 : std_logic;
    signal gmii_rxd_1_r                   : std_logic_vector(7 downto 0);



    -- 125MHz reference clock for EMAC1
    signal gtx_clk_ibufg_1_i              : std_logic;


-------------------------------------------------------------------------------
-- Attribute Declarations 
-------------------------------------------------------------------------------



-------------------------------------------------------------------------------
-- Main Body of Code
-------------------------------------------------------------------------------

begin

    gnd_i     <= '0';
    vcc_i     <= '1';

    ---------------------------------------------------------------------------
    -- Main Reset Circuitry
    ---------------------------------------------------------------------------
    reset_ibuf_i <= RESET;

    reset_i <= reset_ibuf_i;

    ---------------------------------------------------------------------------
    -- GMII circuitry for the Physical Interface of EMAC1
    ---------------------------------------------------------------------------

    gmii1 : gmii_if port map (
        RESET                         => reset_i,
        GMII_TXD                      => GMII_TXD_1,
        GMII_TX_EN                    => GMII_TX_EN_1,
        GMII_TX_ER                    => GMII_TX_ER_1,
        GMII_TX_CLK                   => GMII_TX_CLK_1,
        GMII_RXD                      => GMII_RXD_1,
        GMII_RX_DV                    => GMII_RX_DV_1,
        GMII_RX_ER                    => GMII_RX_ER_1,
        TXD_FROM_MAC                  => gmii_txd_1_i,
        TX_EN_FROM_MAC                => gmii_tx_en_1_i,
        TX_ER_FROM_MAC                => gmii_tx_er_1_i,
        TX_CLK                        => tx_gmii_mii_clk_in_1_i,
        RXD_TO_MAC                    => gmii_rxd_1_r,
        RX_DV_TO_MAC                  => gmii_rx_dv_1_r,
        RX_ER_TO_MAC                  => gmii_rx_er_1_r,
        RX_CLK                        => gmii_rx_clk_1_i);

 
    --------------------------------------------------------------------------
    -- GTX_CLK Clock Management - 125 MHz clock frequency supplied by the user
    -- (Connected to PHYEMAC#GTXCLK of the EMAC primitive)
    --------------------------------------------------------------------------
    gtx_clk_ibufg_1_i <= GTX_CLK_1;



    ------------------------------------------------------------------------
    -- GMII PHY side transmit clock for EMAC1
    ------------------------------------------------------------------------
    tx_gmii_mii_clk_in_1_i <= TX_CLK_1;

    ------------------------------------------------------------------------
    -- GMII PHY side Receiver Clock for EMAC1
    ------------------------------------------------------------------------
    gmii_rx_clk_1_i <= GMII_RX_CLK_1;


    ------------------------------------------------------------------------
    -- GMII client side transmit clock for EMAC1
    ------------------------------------------------------------------------
    tx_client_clk_in_1_i <= TX_CLK_1;

    ------------------------------------------------------------------------
    -- GMII client side receive clock for EMAC1
    ------------------------------------------------------------------------
    rx_client_clk_in_1_i <= gmii_rx_clk_1_i;




    ------------------------------------------------------------------------
    -- Connect previously derived client clocks to example design output ports
    ------------------------------------------------------------------------

    -- EMAC1 Clocking

 

    --------------------------------------------------------------------------
    -- Instantiate the EMAC Wrapper (TEMAC2.vhd)
    --------------------------------------------------------------------------
    v5_emac_wrapper_inst : TEMAC2
    port map (
        -- Client Receiver Interface - EMAC1
        EMAC1CLIENTRXCLIENTCLKOUT       => rx_client_clk_out_1_i,
        CLIENTEMAC1RXCLIENTCLKIN        => rx_client_clk_in_1_i,
        EMAC1CLIENTRXD                  => EMAC1CLIENTRXD,
        EMAC1CLIENTRXDVLD               => EMAC1CLIENTRXDVLD,
        EMAC1CLIENTRXDVLDMSW            => open,
        EMAC1CLIENTRXGOODFRAME          => EMAC1CLIENTRXGOODFRAME,
        EMAC1CLIENTRXBADFRAME           => EMAC1CLIENTRXBADFRAME,
        EMAC1CLIENTRXFRAMEDROP          => EMAC1CLIENTRXFRAMEDROP,
        EMAC1CLIENTRXSTATS              => EMAC1CLIENTRXSTATS,
        EMAC1CLIENTRXSTATSVLD           => EMAC1CLIENTRXSTATSVLD,
        EMAC1CLIENTRXSTATSBYTEVLD       => EMAC1CLIENTRXSTATSBYTEVLD,

        -- Client Transmitter Interface - EMAC1
        EMAC1CLIENTTXCLIENTCLKOUT       => tx_client_clk_out_1_i,
        CLIENTEMAC1TXCLIENTCLKIN        => tx_client_clk_in_1_i,
        CLIENTEMAC1TXD                  => CLIENTEMAC1TXD,
        CLIENTEMAC1TXDVLD               => CLIENTEMAC1TXDVLD,
        CLIENTEMAC1TXDVLDMSW            => gnd_i,
        EMAC1CLIENTTXACK                => EMAC1CLIENTTXACK,
        CLIENTEMAC1TXFIRSTBYTE          => CLIENTEMAC1TXFIRSTBYTE,
        CLIENTEMAC1TXUNDERRUN           => CLIENTEMAC1TXUNDERRUN,
        EMAC1CLIENTTXCOLLISION          => EMAC1CLIENTTXCOLLISION,
        EMAC1CLIENTTXRETRANSMIT         => EMAC1CLIENTTXRETRANSMIT,
        CLIENTEMAC1TXIFGDELAY           => CLIENTEMAC1TXIFGDELAY,
        EMAC1CLIENTTXSTATS              => EMAC1CLIENTTXSTATS,
        EMAC1CLIENTTXSTATSVLD           => EMAC1CLIENTTXSTATSVLD,
        EMAC1CLIENTTXSTATSBYTEVLD       => EMAC1CLIENTTXSTATSBYTEVLD,

        -- MAC Control Interface - EMAC1
        CLIENTEMAC1PAUSEREQ             => CLIENTEMAC1PAUSEREQ,
        CLIENTEMAC1PAUSEVAL             => CLIENTEMAC1PAUSEVAL,

        -- Clock Signals - EMAC1
        GTX_CLK_1                       => gtx_clk_ibufg_1_i,

        EMAC1PHYTXGMIIMIICLKOUT         => tx_gmii_mii_clk_out_1_i,
        PHYEMAC1TXGMIIMIICLKIN          => tx_gmii_mii_clk_in_1_i,
        -- GMII Interface - EMAC1
        GMII_TXD_1                      => gmii_txd_1_i,
        GMII_TX_EN_1                    => gmii_tx_en_1_i,
        GMII_TX_ER_1                    => gmii_tx_er_1_i,
        GMII_RXD_1                      => gmii_rxd_1_r,
        GMII_RX_DV_1                    => gmii_rx_dv_1_r,
        GMII_RX_ER_1                    => gmii_rx_er_1_r,
        GMII_RX_CLK_1                   => gmii_rx_clk_1_i,


        DCM_LOCKED_1                    => vcc_i,

        -- Asynchronous Reset
        RESET                           => reset_i
        );



 
end TOP_LEVEL;
