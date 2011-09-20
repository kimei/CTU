-------------------------------------------------------------------------------
-- Title      : Virtex-5 Ethernet MAC Wrapper
-- Project    : Virtex-5 Embedded Tri-Mode Ethernet MAC Wrapper
-- File       : TEMAC2.vhd
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
--------------------------------------------------------------------------------
-- Description:  This wrapper file instantiates the full Virtex-5 Ethernet 
--               MAC (EMAC) primitive.  For one or both of the two Ethernet MACs
--               (EMAC0/EMAC1):
--
--               * all unused input ports on the primitive will be tied to the
--                 appropriate logic level;
--
--               * all unused output ports on the primitive will be left 
--                 unconnected;
--
--               * the Tie-off Vector will be connected based on the options 
--                 selected from CORE Generator;
--
--               * only used ports will be connected to the ports of this 
--                 wrapper file.
--
--               This simplified wrapper should therefore be used as the 
--               instantiation template for the EMAC in customer designs.
--------------------------------------------------------------------------------

library unisim;
use unisim.vcomponents.all;

library ieee;
use ieee.std_logic_1164.all;

--------------------------------------------------------------------------------
-- The entity declaration for the Virtex-5 Embedded Ethernet MAC wrapper.
--------------------------------------------------------------------------------

entity TEMAC2 is
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

        -- Clock Signal - EMAC1
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
end TEMAC2;



architecture WRAPPER of TEMAC2 is

    ----------------------------------------------------------------------------
    -- Attribute declarations

    ----------------------------------------------------------------------------
    attribute X_CORE_INFO : string;
    attribute X_CORE_INFO of WRAPPER : architecture is "v5_emac_v1_8, Coregen 13.1";

    attribute CORE_GENERATION_INFO : string;
    attribute CORE_GENERATION_INFO of WRAPPER : architecture is "TEMAC2,v5_emac_v1_8,{c_emac0=false,c_emac1=true,c_has_mii_emac0=false,c_has_mii_emac1=false,c_has_gmii_emac0=true,c_has_gmii_emac1=true,c_has_rgmii_v1_3_emac0=false,c_has_rgmii_v1_3_emac1=false,c_has_rgmii_v2_0_emac0=false,c_has_rgmii_v2_0_emac1=false,c_has_sgmii_emac0=false,c_has_sgmii_emac1=false,c_has_gpcs_emac0=false,c_has_gpcs_emac1=false,c_tri_speed_emac0=false,c_tri_speed_emac1=false,c_speed_10_emac0=false,c_speed_10_emac1=false,c_speed_100_emac0=false,c_speed_100_emac1=false,c_speed_1000_emac0=true,c_speed_1000_emac1=true,c_has_host=false,c_has_dcr=false,c_has_mdio_emac0=false,c_has_mdio_emac1=false,c_client_16_emac0=false,c_client_16_emac1=false,c_add_filter_emac0=false,c_add_filter_emac1=false,c_has_clock_enable_emac0=false,c_has_clock_enable_emac1=false,}";

    --------
    -- EMAC1
    --------
    -- PCS/PMA logic is not in use
    constant EMAC1_PHYINITAUTONEG_ENABLE : boolean := FALSE;
    constant EMAC1_PHYISOLATE : boolean := FALSE;
    constant EMAC1_PHYLOOPBACKMSB : boolean := FALSE;
    constant EMAC1_PHYPOWERDOWN : boolean := FALSE;
    constant EMAC1_PHYRESET : boolean := TRUE;
    constant EMAC1_CONFIGVEC_79 : boolean := FALSE;
    constant EMAC1_GTLOOPBACK : boolean := FALSE;
    constant EMAC1_UNIDIRECTION_ENABLE : boolean := FALSE;
    constant EMAC1_LINKTIMERVAL : bit_vector := x"000";

    -- Configure the MAC operating mode
    -- MDIO is not enabled
    constant EMAC1_MDIO_ENABLE : boolean := FALSE;  
    -- Speed is defaulted to 1000Mb/s
    constant EMAC1_SPEED_LSB : boolean := FALSE;
    constant EMAC1_SPEED_MSB : boolean := TRUE; 
    constant EMAC1_USECLKEN : boolean := FALSE;
    constant EMAC1_BYTEPHY : boolean := FALSE;
   
    constant EMAC1_RGMII_ENABLE : boolean := FALSE;
    constant EMAC1_SGMII_ENABLE : boolean := FALSE;
    constant EMAC1_1000BASEX_ENABLE : boolean := FALSE;
    -- The Host I/F is not  in use
    constant EMAC1_HOST_ENABLE : boolean := FALSE;  
    -- 8-bit interface for Tx client
    constant EMAC1_TX16BITCLIENT_ENABLE : boolean := FALSE;
    -- 8-bit interface for Rx client  
    constant EMAC1_RX16BITCLIENT_ENABLE : boolean := FALSE;  
    -- The Address Filter (not enabled)
    constant EMAC1_ADDRFILTER_ENABLE : boolean := FALSE;  

    -- MAC configuration defaults
    -- Rx Length/Type checking enabled (standard IEEE operation)
    constant EMAC1_LTCHECK_DISABLE : boolean := FALSE;  
    -- Rx Flow Control (not enabled)
    constant EMAC1_RXFLOWCTRL_ENABLE : boolean := FALSE;  
    -- Tx Flow Control (not enabled)
    constant EMAC1_TXFLOWCTRL_ENABLE : boolean := FALSE;  
    -- Transmitter is not held in reset not asserted (normal operating mode)
    constant EMAC1_TXRESET : boolean := FALSE;  
    -- Transmitter Jumbo Frames (not enabled)
    constant EMAC1_TXJUMBOFRAME_ENABLE : boolean := FALSE;  
    -- Transmitter In-band FCS (not enabled)
    constant EMAC1_TXINBANDFCS_ENABLE : boolean := FALSE;  
    -- Transmitter Enabled
    constant EMAC1_TX_ENABLE : boolean := TRUE;  
    -- Transmitter VLAN mode (not enabled)
    constant EMAC1_TXVLAN_ENABLE : boolean := FALSE;  
    -- Transmitter Half Duplex mode (not enabled)
    constant EMAC1_TXHALFDUPLEX : boolean := FALSE;  
    -- Transmitter IFG Adjust (not enabled)
    constant EMAC1_TXIFGADJUST_ENABLE : boolean := FALSE;  
    -- Receiver is not held in reset not asserted (normal operating mode)
    constant EMAC1_RXRESET : boolean := FALSE;  
    -- Receiver Jumbo Frames (not enabled)
    constant EMAC1_RXJUMBOFRAME_ENABLE : boolean := FALSE;  
    -- Receiver In-band FCS (not enabled)
    constant EMAC1_RXINBANDFCS_ENABLE : boolean := FALSE;  
    -- Receiver Enabled
    constant EMAC1_RX_ENABLE : boolean := TRUE;  
    -- Receiver VLAN mode (not enabled)
    constant EMAC1_RXVLAN_ENABLE : boolean := FALSE;  
    -- Receiver Half Duplex mode (not enabled)
    constant EMAC1_RXHALFDUPLEX : boolean := FALSE;  

    -- Set the Pause Address Default
    constant EMAC1_PAUSEADDR : bit_vector := x"FFEEDDCCBBAA";

    constant EMAC1_UNICASTADDR : bit_vector := x"000000000000";
    constant EMAC1_DCRBASEADDR : bit_vector := X"00";
 

    ----------------------------------------------------------------------------
    -- Signals Declarations
    ----------------------------------------------------------------------------


    signal gnd_v48_i                      : std_logic_vector(47 downto 0);


    signal client_rx_data_1_i             : std_logic_vector(15 downto 0);
    signal client_tx_data_1_i             : std_logic_vector(15 downto 0);
    signal client_tx_data_valid_1_i       : std_logic;
    signal client_tx_data_valid_msb_1_i   : std_logic;

begin


    ----------------------------------------------------------------------------
    -- Main Body of Code
    ----------------------------------------------------------------------------


    gnd_v48_i <= "000000000000000000000000000000000000000000000000";


    -- 8-bit client data on EMAC1
    EMAC1CLIENTRXD <= client_rx_data_1_i(7 downto 0);
    client_tx_data_1_i <= "00000000" & CLIENTEMAC1TXD after 4 ns;
    client_tx_data_valid_1_i <= CLIENTEMAC1TXDVLD after 4 ns;
    client_tx_data_valid_msb_1_i <= '0';





    ----------------------------------------------------------------------------
    -- Instantiate the Virtex-5 Embedded Ethernet EMAC
    ----------------------------------------------------------------------------
    v5_emac : TEMAC
    generic map (
                EMAC0_LINKTIMERVAL          => "000000000",
		EMAC1_1000BASEX_ENABLE      => EMAC1_1000BASEX_ENABLE,
		EMAC1_ADDRFILTER_ENABLE     => EMAC1_ADDRFILTER_ENABLE,
		EMAC1_BYTEPHY               => EMAC1_BYTEPHY,
		EMAC1_CONFIGVEC_79          => EMAC1_CONFIGVEC_79,
		EMAC1_DCRBASEADDR           => EMAC1_DCRBASEADDR,
		EMAC1_GTLOOPBACK            => EMAC1_GTLOOPBACK,
		EMAC1_HOST_ENABLE           => EMAC1_HOST_ENABLE,
		EMAC1_LINKTIMERVAL          => EMAC1_LINKTIMERVAL(3 to 11),
		EMAC1_LTCHECK_DISABLE       => EMAC1_LTCHECK_DISABLE,
		EMAC1_MDIO_ENABLE           => EMAC1_MDIO_ENABLE,
		EMAC1_PAUSEADDR             => EMAC1_PAUSEADDR,
		EMAC1_PHYINITAUTONEG_ENABLE => EMAC1_PHYINITAUTONEG_ENABLE,
		EMAC1_PHYISOLATE            => EMAC1_PHYISOLATE,
		EMAC1_PHYLOOPBACKMSB        => EMAC1_PHYLOOPBACKMSB,
		EMAC1_PHYPOWERDOWN          => EMAC1_PHYPOWERDOWN,
		EMAC1_PHYRESET              => EMAC1_PHYRESET,
		EMAC1_RGMII_ENABLE          => EMAC1_RGMII_ENABLE,
		EMAC1_RX16BITCLIENT_ENABLE  => EMAC1_RX16BITCLIENT_ENABLE,
		EMAC1_RXFLOWCTRL_ENABLE     => EMAC1_RXFLOWCTRL_ENABLE,
		EMAC1_RXHALFDUPLEX          => EMAC1_RXHALFDUPLEX,
		EMAC1_RXINBANDFCS_ENABLE    => EMAC1_RXINBANDFCS_ENABLE,
		EMAC1_RXJUMBOFRAME_ENABLE   => EMAC1_RXJUMBOFRAME_ENABLE,
		EMAC1_RXRESET               => EMAC1_RXRESET,
		EMAC1_RXVLAN_ENABLE         => EMAC1_RXVLAN_ENABLE,
		EMAC1_RX_ENABLE             => EMAC1_RX_ENABLE,
		EMAC1_SGMII_ENABLE          => EMAC1_SGMII_ENABLE,
		EMAC1_SPEED_LSB             => EMAC1_SPEED_LSB,
		EMAC1_SPEED_MSB             => EMAC1_SPEED_MSB,
		EMAC1_TX16BITCLIENT_ENABLE  => EMAC1_TX16BITCLIENT_ENABLE,
		EMAC1_TXFLOWCTRL_ENABLE     => EMAC1_TXFLOWCTRL_ENABLE,
		EMAC1_TXHALFDUPLEX          => EMAC1_TXHALFDUPLEX,
		EMAC1_TXIFGADJUST_ENABLE    => EMAC1_TXIFGADJUST_ENABLE,
		EMAC1_TXINBANDFCS_ENABLE    => EMAC1_TXINBANDFCS_ENABLE,
		EMAC1_TXJUMBOFRAME_ENABLE   => EMAC1_TXJUMBOFRAME_ENABLE,
		EMAC1_TXRESET               => EMAC1_TXRESET,
		EMAC1_TXVLAN_ENABLE         => EMAC1_TXVLAN_ENABLE,
		EMAC1_TX_ENABLE             => EMAC1_TX_ENABLE,
		EMAC1_UNICASTADDR           => EMAC1_UNICASTADDR,
		EMAC1_UNIDIRECTION_ENABLE   => EMAC1_UNIDIRECTION_ENABLE,
		EMAC1_USECLKEN              => EMAC1_USECLKEN
)
    port map (
        RESET                           => RESET,

        -- EMAC0
        EMAC0CLIENTRXCLIENTCLKOUT       => open,
        CLIENTEMAC0RXCLIENTCLKIN        => '0',
        EMAC0CLIENTRXD                  => open,
        EMAC0CLIENTRXDVLD               => open,
        EMAC0CLIENTRXDVLDMSW            => open,
        EMAC0CLIENTRXGOODFRAME          => open,
        EMAC0CLIENTRXBADFRAME           => open,
        EMAC0CLIENTRXFRAMEDROP          => open,
        EMAC0CLIENTRXSTATS              => open,
        EMAC0CLIENTRXSTATSVLD           => open,
        EMAC0CLIENTRXSTATSBYTEVLD       => open,

        EMAC0CLIENTTXCLIENTCLKOUT       => open,
        CLIENTEMAC0TXCLIENTCLKIN        => '0',
        CLIENTEMAC0TXD                  => gnd_v48_i(15 downto 0),
        CLIENTEMAC0TXDVLD               => '0',
        CLIENTEMAC0TXDVLDMSW            => '0',
        EMAC0CLIENTTXACK                => open,
        CLIENTEMAC0TXFIRSTBYTE          => '0',
        CLIENTEMAC0TXUNDERRUN           => '0',
        EMAC0CLIENTTXCOLLISION          => open,
        EMAC0CLIENTTXRETRANSMIT         => open,
        CLIENTEMAC0TXIFGDELAY           => gnd_v48_i(7 downto 0),
        EMAC0CLIENTTXSTATS              => open,
        EMAC0CLIENTTXSTATSVLD           => open,
        EMAC0CLIENTTXSTATSBYTEVLD       => open,

        CLIENTEMAC0PAUSEREQ             => '0',
        CLIENTEMAC0PAUSEVAL             => gnd_v48_i(15 downto 0),

        PHYEMAC0GTXCLK                  => '0',
        PHYEMAC0TXGMIIMIICLKIN          => '0',
        EMAC0PHYTXGMIIMIICLKOUT         => open,

        PHYEMAC0RXCLK                   => '0',
        PHYEMAC0RXD                     => gnd_v48_i(7 downto 0),
        PHYEMAC0RXDV                    => '0',
        PHYEMAC0RXER                    => '0',
        PHYEMAC0MIITXCLK                => '0',
        EMAC0PHYTXCLK                   => open,
        EMAC0PHYTXD                     => open,
        EMAC0PHYTXEN                    => open,
        EMAC0PHYTXER                    => open,
        PHYEMAC0COL                     => '0',
        PHYEMAC0CRS                     => '0',

        CLIENTEMAC0DCMLOCKED            => '1',
        EMAC0CLIENTANINTERRUPT          => open,
        PHYEMAC0SIGNALDET               => '0',
        PHYEMAC0PHYAD                   => gnd_v48_i(4 downto 0),
        EMAC0PHYENCOMMAALIGN            => open,
        EMAC0PHYLOOPBACKMSB             => open,
        EMAC0PHYMGTRXRESET              => open,
        EMAC0PHYMGTTXRESET              => open,
        EMAC0PHYPOWERDOWN               => open,
        EMAC0PHYSYNCACQSTATUS           => open,
        PHYEMAC0RXCLKCORCNT             => gnd_v48_i(2 downto 0),
        PHYEMAC0RXBUFSTATUS             => gnd_v48_i(1 downto 0),
        PHYEMAC0RXBUFERR                => '0',
        PHYEMAC0RXCHARISCOMMA           => '0',
        PHYEMAC0RXCHARISK               => '0',
        PHYEMAC0RXCHECKINGCRC           => '0',
        PHYEMAC0RXCOMMADET              => '0',
        PHYEMAC0RXDISPERR               => '0',
        PHYEMAC0RXLOSSOFSYNC            => gnd_v48_i(1 downto 0),
        PHYEMAC0RXNOTINTABLE            => '0',
        PHYEMAC0RXRUNDISP               => '0',
        PHYEMAC0TXBUFERR                => '0',
        EMAC0PHYTXCHARDISPMODE          => open,
        EMAC0PHYTXCHARDISPVAL           => open,
        EMAC0PHYTXCHARISK               => open,

        EMAC0PHYMCLKOUT                 => open,
        PHYEMAC0MCLKIN                  => '0',
        PHYEMAC0MDIN                    => '0',
        EMAC0PHYMDOUT                   => open,
        EMAC0PHYMDTRI                   => open,

        EMAC0SPEEDIS10100               => open,

        -- EMAC1
        EMAC1CLIENTRXCLIENTCLKOUT       => EMAC1CLIENTRXCLIENTCLKOUT,
        CLIENTEMAC1RXCLIENTCLKIN        => CLIENTEMAC1RXCLIENTCLKIN,
        EMAC1CLIENTRXD                  => client_rx_data_1_i,
        EMAC1CLIENTRXDVLD               => EMAC1CLIENTRXDVLD,
        EMAC1CLIENTRXDVLDMSW            => EMAC1CLIENTRXDVLDMSW,
        EMAC1CLIENTRXGOODFRAME          => EMAC1CLIENTRXGOODFRAME,
        EMAC1CLIENTRXBADFRAME           => EMAC1CLIENTRXBADFRAME,
        EMAC1CLIENTRXFRAMEDROP          => EMAC1CLIENTRXFRAMEDROP,
        EMAC1CLIENTRXSTATS              => EMAC1CLIENTRXSTATS,
        EMAC1CLIENTRXSTATSVLD           => EMAC1CLIENTRXSTATSVLD,
        EMAC1CLIENTRXSTATSBYTEVLD       => EMAC1CLIENTRXSTATSBYTEVLD,

        EMAC1CLIENTTXCLIENTCLKOUT       => EMAC1CLIENTTXCLIENTCLKOUT,
        CLIENTEMAC1TXCLIENTCLKIN        => CLIENTEMAC1TXCLIENTCLKIN,
        CLIENTEMAC1TXD                  => client_tx_data_1_i,
        CLIENTEMAC1TXDVLD               => client_tx_data_valid_1_i,
        CLIENTEMAC1TXDVLDMSW            => client_tx_data_valid_msb_1_i,
        EMAC1CLIENTTXACK                => EMAC1CLIENTTXACK,
        CLIENTEMAC1TXFIRSTBYTE          => CLIENTEMAC1TXFIRSTBYTE,
        CLIENTEMAC1TXUNDERRUN           => CLIENTEMAC1TXUNDERRUN,
        EMAC1CLIENTTXCOLLISION          => EMAC1CLIENTTXCOLLISION,
        EMAC1CLIENTTXRETRANSMIT         => EMAC1CLIENTTXRETRANSMIT,
        CLIENTEMAC1TXIFGDELAY           => CLIENTEMAC1TXIFGDELAY,
        EMAC1CLIENTTXSTATS              => EMAC1CLIENTTXSTATS,
        EMAC1CLIENTTXSTATSVLD           => EMAC1CLIENTTXSTATSVLD,
        EMAC1CLIENTTXSTATSBYTEVLD       => EMAC1CLIENTTXSTATSBYTEVLD,

        CLIENTEMAC1PAUSEREQ             => CLIENTEMAC1PAUSEREQ,
        CLIENTEMAC1PAUSEVAL             => CLIENTEMAC1PAUSEVAL,

        PHYEMAC1GTXCLK                  => GTX_CLK_1,
        PHYEMAC1TXGMIIMIICLKIN          => PHYEMAC1TXGMIIMIICLKIN,
        EMAC1PHYTXGMIIMIICLKOUT         => EMAC1PHYTXGMIIMIICLKOUT,
        PHYEMAC1RXCLK                   => GMII_RX_CLK_1,
        PHYEMAC1RXD                     => GMII_RXD_1,
        PHYEMAC1RXDV                    => GMII_RX_DV_1,
        PHYEMAC1RXER                    => GMII_RX_ER_1,
        EMAC1PHYTXCLK                   => open,
        EMAC1PHYTXD                     => GMII_TXD_1,
        EMAC1PHYTXEN                    => GMII_TX_EN_1,
        EMAC1PHYTXER                    => GMII_TX_ER_1,
        PHYEMAC1MIITXCLK                => '0',
        PHYEMAC1COL                     => '0',
        PHYEMAC1CRS                     => '0',

        CLIENTEMAC1DCMLOCKED            => DCM_LOCKED_1,
        EMAC1CLIENTANINTERRUPT          => open,
        PHYEMAC1SIGNALDET               => '0',
        PHYEMAC1PHYAD                   => gnd_v48_i(4 downto 0),
        EMAC1PHYENCOMMAALIGN            => open,
        EMAC1PHYLOOPBACKMSB             => open,
        EMAC1PHYMGTRXRESET              => open,
        EMAC1PHYMGTTXRESET              => open,
        EMAC1PHYPOWERDOWN               => open,
        EMAC1PHYSYNCACQSTATUS           => open,
        PHYEMAC1RXCLKCORCNT             => gnd_v48_i(2 downto 0),
        PHYEMAC1RXBUFSTATUS             => gnd_v48_i(1 downto 0),
        PHYEMAC1RXBUFERR                => '0',
        PHYEMAC1RXCHARISCOMMA           => '0',
        PHYEMAC1RXCHARISK               => '0',
        PHYEMAC1RXCHECKINGCRC           => '0',
        PHYEMAC1RXCOMMADET              => '0',
        PHYEMAC1RXDISPERR               => '0',
        PHYEMAC1RXLOSSOFSYNC            => gnd_v48_i(1 downto 0),
        PHYEMAC1RXNOTINTABLE            => '0',
        PHYEMAC1RXRUNDISP               => '0',
        PHYEMAC1TXBUFERR                => '0',
        EMAC1PHYTXCHARDISPMODE          => open,
        EMAC1PHYTXCHARDISPVAL           => open,
        EMAC1PHYTXCHARISK               => open,

        EMAC1PHYMCLKOUT                 => open,
        PHYEMAC1MCLKIN                  => '0',
        PHYEMAC1MDIN                    => '1',
        EMAC1PHYMDOUT                   => open,
        EMAC1PHYMDTRI                   => open,
        EMAC1SPEEDIS10100               => open,

        -- Host Interface 
        HOSTCLK                         => '0',
 
        HOSTOPCODE                      => gnd_v48_i(1 downto 0),
        HOSTREQ                         => '0',
        HOSTMIIMSEL                     => '0',
        HOSTADDR                        => gnd_v48_i(9 downto 0),
        HOSTWRDATA                      => gnd_v48_i(31 downto 0), 
        HOSTMIIMRDY                     => open,
        HOSTRDDATA                      => open,
        HOSTEMAC1SEL                    => '0',

        -- DCR Interface
        DCREMACCLK                      => '0',
        DCREMACABUS                     => gnd_v48_i(9 downto 0),
        DCREMACREAD                     => '0',
        DCREMACWRITE                    => '0',
        DCREMACDBUS                     => gnd_v48_i(31 downto 0),
        EMACDCRACK                      => open,
        EMACDCRDBUS                     => open,
        DCREMACENABLE                   => '0',
        DCRHOSTDONEIR                   => open
        );

end WRAPPER;
