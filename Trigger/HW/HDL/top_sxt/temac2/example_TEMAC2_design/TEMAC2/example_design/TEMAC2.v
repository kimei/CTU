//-----------------------------------------------------------------------------
// Title      : Virtex-5 Ethernet MAC Wrapper
// Project    : Virtex-5 Embedded Tri-Mode Ethernet MAC Wrapper
// File       : TEMAC2.v
// Version    : 1.8
//-----------------------------------------------------------------------------
//
// (c) Copyright 2004-2010 Xilinx, Inc. All rights reserved.
//
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
//
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
//
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
//
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
//
//------------------------------------------------------------------------------
// Description:  This wrapper file instantiates the full Virtex-5 Ethernet 
//               MAC (EMAC) primitive.  For one or both of the two Ethernet MACs
//               (EMAC0/EMAC1):
//
//               * all unused input ports on the primitive will be tied to the
//                 appropriate logic level;
//
//               * all unused output ports on the primitive will be left 
//                 unconnected;
//
//               * the Tie-off Vector will be connected based on the options 
//                 selected from CORE Generator;
//
//               * only used ports will be connected to the ports of this 
//                 wrapper file.
//
//               This simplified wrapper should therefore be used as the 
//               instantiation template for the EMAC in customer designs.
//------------------------------------------------------------------------------

`timescale 1 ps / 1 ps


//------------------------------------------------------------------------------
// The module declaration for the top level wrapper.
//------------------------------------------------------------------------------
(* X_CORE_INFO = "v5_emac_v1_8, Coregen 13.1" *)
(* CORE_GENERATION_INFO = "TEMAC2,v5_emac_v1_8,{c_emac0=false,c_emac1=true,c_has_mii_emac0=false,c_has_mii_emac1=false,c_has_gmii_emac0=true,c_has_gmii_emac1=true,c_has_rgmii_v1_3_emac0=false,c_has_rgmii_v1_3_emac1=false,c_has_rgmii_v2_0_emac0=false,c_has_rgmii_v2_0_emac1=false,c_has_sgmii_emac0=false,c_has_sgmii_emac1=false,c_has_gpcs_emac0=false,c_has_gpcs_emac1=false,c_tri_speed_emac0=false,c_tri_speed_emac1=false,c_speed_10_emac0=false,c_speed_10_emac1=false,c_speed_100_emac0=false,c_speed_100_emac1=false,c_speed_1000_emac0=true,c_speed_1000_emac1=true,c_has_host=false,c_has_dcr=false,c_has_mdio_emac0=false,c_has_mdio_emac1=false,c_client_16_emac0=false,c_client_16_emac1=false,c_add_filter_emac0=false,c_add_filter_emac1=false,c_has_clock_enable_emac0=false,c_has_clock_enable_emac1=false,}" *)
module TEMAC2
(

    // Client Receiver Interface - EMAC1
    EMAC1CLIENTRXCLIENTCLKOUT,
    CLIENTEMAC1RXCLIENTCLKIN,
    EMAC1CLIENTRXD,
    EMAC1CLIENTRXDVLD,
    EMAC1CLIENTRXDVLDMSW,
    EMAC1CLIENTRXGOODFRAME,
    EMAC1CLIENTRXBADFRAME,
    EMAC1CLIENTRXFRAMEDROP,
    EMAC1CLIENTRXSTATS,
    EMAC1CLIENTRXSTATSVLD,
    EMAC1CLIENTRXSTATSBYTEVLD,

    // Client Transmitter Interface - EMAC1
    EMAC1CLIENTTXCLIENTCLKOUT,
    CLIENTEMAC1TXCLIENTCLKIN,
    CLIENTEMAC1TXD,
    CLIENTEMAC1TXDVLD,
    CLIENTEMAC1TXDVLDMSW,
    EMAC1CLIENTTXACK,
    CLIENTEMAC1TXFIRSTBYTE,
    CLIENTEMAC1TXUNDERRUN,
    EMAC1CLIENTTXCOLLISION,
    EMAC1CLIENTTXRETRANSMIT,
    CLIENTEMAC1TXIFGDELAY,
    EMAC1CLIENTTXSTATS,
    EMAC1CLIENTTXSTATSVLD,
    EMAC1CLIENTTXSTATSBYTEVLD,

    // MAC Control Interface - EMAC1
    CLIENTEMAC1PAUSEREQ,
    CLIENTEMAC1PAUSEVAL,

    // Clock Signal - EMAC1
    GTX_CLK_1,
    EMAC1PHYTXGMIIMIICLKOUT,
    PHYEMAC1TXGMIIMIICLKIN,

    // GMII Interface - EMAC1
    GMII_TXD_1,
    GMII_TX_EN_1,
    GMII_TX_ER_1,
    GMII_RXD_1,
    GMII_RX_DV_1,
    GMII_RX_ER_1,
    GMII_RX_CLK_1,



    DCM_LOCKED_1,

    // Asynchronous Reset
    RESET
);

    //--------------------------------------------------------------------------
    // Port Declarations
    //--------------------------------------------------------------------------



    // Client Receiver Interface - EMAC1
    output          EMAC1CLIENTRXCLIENTCLKOUT;
    input           CLIENTEMAC1RXCLIENTCLKIN;
    output   [7:0]  EMAC1CLIENTRXD;
    output          EMAC1CLIENTRXDVLD;
    output          EMAC1CLIENTRXDVLDMSW;
    output          EMAC1CLIENTRXGOODFRAME;
    output          EMAC1CLIENTRXBADFRAME;
    output          EMAC1CLIENTRXFRAMEDROP;
    output   [6:0]  EMAC1CLIENTRXSTATS;
    output          EMAC1CLIENTRXSTATSVLD;
    output          EMAC1CLIENTRXSTATSBYTEVLD;

    // Client Transmitter Interface - EMAC1
    output          EMAC1CLIENTTXCLIENTCLKOUT;
    input           CLIENTEMAC1TXCLIENTCLKIN;
    input    [7:0]  CLIENTEMAC1TXD;
    input           CLIENTEMAC1TXDVLD;
    input           CLIENTEMAC1TXDVLDMSW;
    output          EMAC1CLIENTTXACK;
    input           CLIENTEMAC1TXFIRSTBYTE;
    input           CLIENTEMAC1TXUNDERRUN;
    output          EMAC1CLIENTTXCOLLISION;
    output          EMAC1CLIENTTXRETRANSMIT;
    input    [7:0]  CLIENTEMAC1TXIFGDELAY;
    output          EMAC1CLIENTTXSTATS;
    output          EMAC1CLIENTTXSTATSVLD;
    output          EMAC1CLIENTTXSTATSBYTEVLD;

    // MAC Control Interface - EMAC1
    input           CLIENTEMAC1PAUSEREQ;
    input   [15:0]  CLIENTEMAC1PAUSEVAL;

    // Clock Signal - EMAC1
    input           GTX_CLK_1;
    output          EMAC1PHYTXGMIIMIICLKOUT;
    input           PHYEMAC1TXGMIIMIICLKIN;

    // GMII Interface - EMAC1
    output   [7:0]  GMII_TXD_1;
    output          GMII_TX_EN_1;
    output          GMII_TX_ER_1;
    input    [7:0]  GMII_RXD_1;
    input           GMII_RX_DV_1;
    input           GMII_RX_ER_1;
    input           GMII_RX_CLK_1;



    input           DCM_LOCKED_1;

    // Asynchronous Reset
    input           RESET;


    //--------------------------------------------------------------------------
    // Wire Declarations 
    //--------------------------------------------------------------------------



    wire    [15:0]  client_rx_data_1_i;
    wire    [15:0]  client_tx_data_1_i;



    //--------------------------------------------------------------------------
    // Main Body of Code 
    //--------------------------------------------------------------------------



    // 8-bit client data on EMAC1
    assign EMAC1CLIENTRXD = client_rx_data_1_i[7:0];
    assign #4000 client_tx_data_1_i = {8'b00000000, CLIENTEMAC1TXD};



    //--------------------------------------------------------------------------
    // Instantiate the Virtex-5 Embedded Ethernet EMAC
    //--------------------------------------------------------------------------
    TEMAC v5_emac
    (
        .RESET                          (RESET),

        // EMAC0
        .EMAC0CLIENTRXCLIENTCLKOUT      (),
        .CLIENTEMAC0RXCLIENTCLKIN       (1'b0),
        .EMAC0CLIENTRXD                 (),
        .EMAC0CLIENTRXDVLD              (),
        .EMAC0CLIENTRXDVLDMSW           (),
        .EMAC0CLIENTRXGOODFRAME         (),
        .EMAC0CLIENTRXBADFRAME          (),
        .EMAC0CLIENTRXFRAMEDROP         (),
        .EMAC0CLIENTRXSTATS             (),
        .EMAC0CLIENTRXSTATSVLD          (),
        .EMAC0CLIENTRXSTATSBYTEVLD      (),

        .EMAC0CLIENTTXCLIENTCLKOUT      (),
        .CLIENTEMAC0TXCLIENTCLKIN       (1'b0),
        .CLIENTEMAC0TXD                 (16'h0000),
        .CLIENTEMAC0TXDVLD              (1'b0),
        .CLIENTEMAC0TXDVLDMSW           (1'b0),
        .EMAC0CLIENTTXACK               (),
        .CLIENTEMAC0TXFIRSTBYTE         (1'b0),
        .CLIENTEMAC0TXUNDERRUN          (1'b0),
        .EMAC0CLIENTTXCOLLISION         (),
        .EMAC0CLIENTTXRETRANSMIT        (),
        .CLIENTEMAC0TXIFGDELAY          (8'h00),
        .EMAC0CLIENTTXSTATS             (),
        .EMAC0CLIENTTXSTATSVLD          (),
        .EMAC0CLIENTTXSTATSBYTEVLD      (),

        .CLIENTEMAC0PAUSEREQ            (1'b0),
        .CLIENTEMAC0PAUSEVAL            (16'h0000),

        .PHYEMAC0GTXCLK                 (1'b0),
        .EMAC0PHYTXGMIIMIICLKOUT        (),
        .PHYEMAC0TXGMIIMIICLKIN         (1'b0),

        .PHYEMAC0RXCLK                  (1'b0),
        .PHYEMAC0RXD                    (8'h00),
        .PHYEMAC0RXDV                   (1'b0),
        .PHYEMAC0RXER                   (1'b0),
        .PHYEMAC0MIITXCLK               (1'b0),
        .EMAC0PHYTXCLK                  (),
        .EMAC0PHYTXD                    (),
        .EMAC0PHYTXEN                   (),
        .EMAC0PHYTXER                   (),
        .PHYEMAC0COL                    (1'b0),
        .PHYEMAC0CRS                    (1'b0),

        .CLIENTEMAC0DCMLOCKED           (1'b1),
        .EMAC0CLIENTANINTERRUPT         (),
        .PHYEMAC0SIGNALDET              (1'b0),
        .PHYEMAC0PHYAD                  (5'b00000),
        .EMAC0PHYENCOMMAALIGN           (),
        .EMAC0PHYLOOPBACKMSB            (),
        .EMAC0PHYMGTRXRESET             (),
        .EMAC0PHYMGTTXRESET             (),
        .EMAC0PHYPOWERDOWN              (),
        .EMAC0PHYSYNCACQSTATUS          (),
        .PHYEMAC0RXCLKCORCNT            (3'b000),
        .PHYEMAC0RXBUFSTATUS            (2'b00),
        .PHYEMAC0RXBUFERR               (1'b0),
        .PHYEMAC0RXCHARISCOMMA          (1'b0),
        .PHYEMAC0RXCHARISK              (1'b0),
        .PHYEMAC0RXCHECKINGCRC          (1'b0),
        .PHYEMAC0RXCOMMADET             (1'b0),
        .PHYEMAC0RXDISPERR              (1'b0),
        .PHYEMAC0RXLOSSOFSYNC           (2'b00),
        .PHYEMAC0RXNOTINTABLE           (1'b0),
        .PHYEMAC0RXRUNDISP              (1'b0),
        .PHYEMAC0TXBUFERR               (1'b0),
        .EMAC0PHYTXCHARDISPMODE         (),
        .EMAC0PHYTXCHARDISPVAL          (),
        .EMAC0PHYTXCHARISK              (),

        .EMAC0PHYMCLKOUT                (),
        .PHYEMAC0MCLKIN                 (1'b0),
        .PHYEMAC0MDIN                   (1'b0),
        .EMAC0PHYMDOUT                  (),
        .EMAC0PHYMDTRI                  (),
        .EMAC0SPEEDIS10100              (),

        // EMAC1
        .EMAC1CLIENTRXCLIENTCLKOUT      (EMAC1CLIENTRXCLIENTCLKOUT),
        .CLIENTEMAC1RXCLIENTCLKIN       (CLIENTEMAC1RXCLIENTCLKIN),
        .EMAC1CLIENTRXD                 (client_rx_data_1_i),
        .EMAC1CLIENTRXDVLD              (EMAC1CLIENTRXDVLD),
        .EMAC1CLIENTRXDVLDMSW           (EMAC1CLIENTRXDVLDMSW),
        .EMAC1CLIENTRXGOODFRAME         (EMAC1CLIENTRXGOODFRAME),
        .EMAC1CLIENTRXBADFRAME          (EMAC1CLIENTRXBADFRAME),
        .EMAC1CLIENTRXFRAMEDROP         (EMAC1CLIENTRXFRAMEDROP),
        .EMAC1CLIENTRXSTATS             (EMAC1CLIENTRXSTATS),
        .EMAC1CLIENTRXSTATSVLD          (EMAC1CLIENTRXSTATSVLD),
        .EMAC1CLIENTRXSTATSBYTEVLD      (EMAC1CLIENTRXSTATSBYTEVLD),

        .EMAC1CLIENTTXCLIENTCLKOUT      (EMAC1CLIENTTXCLIENTCLKOUT),
        .CLIENTEMAC1TXCLIENTCLKIN       (CLIENTEMAC1TXCLIENTCLKIN),
        .CLIENTEMAC1TXD                 (client_tx_data_1_i),
        .CLIENTEMAC1TXDVLD              (CLIENTEMAC1TXDVLD),
        .CLIENTEMAC1TXDVLDMSW           (CLIENTEMAC1TXDVLDMSW),
        .EMAC1CLIENTTXACK               (EMAC1CLIENTTXACK),
        .CLIENTEMAC1TXFIRSTBYTE         (CLIENTEMAC1TXFIRSTBYTE),
        .CLIENTEMAC1TXUNDERRUN          (CLIENTEMAC1TXUNDERRUN),
        .EMAC1CLIENTTXCOLLISION         (EMAC1CLIENTTXCOLLISION),
        .EMAC1CLIENTTXRETRANSMIT        (EMAC1CLIENTTXRETRANSMIT),
        .CLIENTEMAC1TXIFGDELAY          (CLIENTEMAC1TXIFGDELAY),
        .EMAC1CLIENTTXSTATS             (EMAC1CLIENTTXSTATS),
        .EMAC1CLIENTTXSTATSVLD          (EMAC1CLIENTTXSTATSVLD),
        .EMAC1CLIENTTXSTATSBYTEVLD      (EMAC1CLIENTTXSTATSBYTEVLD),

        .CLIENTEMAC1PAUSEREQ            (CLIENTEMAC1PAUSEREQ),
        .CLIENTEMAC1PAUSEVAL            (CLIENTEMAC1PAUSEVAL),

        .PHYEMAC1GTXCLK                 (GTX_CLK_1),
        .EMAC1PHYTXGMIIMIICLKOUT        (EMAC1PHYTXGMIIMIICLKOUT),
        .PHYEMAC1TXGMIIMIICLKIN         (PHYEMAC1TXGMIIMIICLKIN),

        .PHYEMAC1RXCLK                  (GMII_RX_CLK_1),
        .PHYEMAC1RXD                    (GMII_RXD_1),
        .PHYEMAC1RXDV                   (GMII_RX_DV_1),
        .PHYEMAC1RXER                   (GMII_RX_ER_1),
        .EMAC1PHYTXCLK                  (),
        .EMAC1PHYTXD                    (GMII_TXD_1),
        .EMAC1PHYTXEN                   (GMII_TX_EN_1),
        .EMAC1PHYTXER                   (GMII_TX_ER_1),
        .PHYEMAC1MIITXCLK               (),
        .PHYEMAC1COL                    (1'b0),
        .PHYEMAC1CRS                    (1'b0),

        .CLIENTEMAC1DCMLOCKED           (DCM_LOCKED_1),
        .EMAC1CLIENTANINTERRUPT         (),
        .PHYEMAC1SIGNALDET              (1'b0),
        .PHYEMAC1PHYAD                  (5'b00000),
        .EMAC1PHYENCOMMAALIGN           (),
        .EMAC1PHYLOOPBACKMSB            (),
        .EMAC1PHYMGTRXRESET             (),
        .EMAC1PHYMGTTXRESET             (),
        .EMAC1PHYPOWERDOWN              (),
        .EMAC1PHYSYNCACQSTATUS          (),
        .PHYEMAC1RXCLKCORCNT            (3'b000),
        .PHYEMAC1RXBUFSTATUS            (2'b00),
        .PHYEMAC1RXBUFERR               (1'b0),
        .PHYEMAC1RXCHARISCOMMA          (1'b0),
        .PHYEMAC1RXCHARISK              (1'b0),
        .PHYEMAC1RXCHECKINGCRC          (1'b0),
        .PHYEMAC1RXCOMMADET             (1'b0),
        .PHYEMAC1RXDISPERR              (1'b0),
        .PHYEMAC1RXLOSSOFSYNC           (2'b00),
        .PHYEMAC1RXNOTINTABLE           (1'b0),
        .PHYEMAC1RXRUNDISP              (1'b0),
        .PHYEMAC1TXBUFERR               (1'b0),
        .EMAC1PHYTXCHARDISPMODE         (),
        .EMAC1PHYTXCHARDISPVAL          (),
        .EMAC1PHYTXCHARISK              (),

        .EMAC1PHYMCLKOUT                (),
        .PHYEMAC1MCLKIN                 (1'b0),
        .PHYEMAC1MDIN                   (1'b1),
        .EMAC1PHYMDOUT                  (),
        .EMAC1PHYMDTRI                  (),
        .EMAC1SPEEDIS10100              (),

        // Host Interface 
        .HOSTCLK                        (1'b0),
        .HOSTOPCODE                     (2'b00),
        .HOSTREQ                        (1'b0),
        .HOSTMIIMSEL                    (1'b0),
        .HOSTADDR                       (10'b0000000000),
        .HOSTWRDATA                     (32'h00000000),
        .HOSTMIIMRDY                    (),
        .HOSTRDDATA                     (),
        .HOSTEMAC1SEL                   (1'b0),

        // DCR Interface
        .DCREMACCLK                     (1'b0),
        .DCREMACABUS                    (10'h000),
        .DCREMACREAD                    (1'b0),
        .DCREMACWRITE                   (1'b0),
        .DCREMACDBUS                    (32'h00000000),
        .EMACDCRACK                     (),
        .EMACDCRDBUS                    (),
        .DCREMACENABLE                  (1'b0),
        .DCRHOSTDONEIR                  ()
    );
    //------
    // EMAC1
    //------
    // PCS/PMA logic is not in use
    //synthesis attribute EMAC1_PHYINITAUTONEG_ENABLE of v5_emac is "FALSE"
    defparam v5_emac.EMAC1_PHYINITAUTONEG_ENABLE = "FALSE";
    //synthesis attribute EMAC1_PHYISOLATE of v5_emac is "FALSE"
    defparam v5_emac.EMAC1_PHYISOLATE = "FALSE";
    //synthesis attribute EMAC1_PHYLOOPBACKMSB of v5_emac is "FALSE"
    defparam v5_emac.EMAC1_PHYLOOPBACKMSB = "FALSE";
    //synthesis attribute EMAC1_PHYPOWERDOWN of v5_emac is "FALSE"
    defparam v5_emac.EMAC1_PHYPOWERDOWN = "FALSE";
    //synthesis attribute EMAC1_PHYRESET of v5_emac is "TRUE"
    defparam v5_emac.EMAC1_PHYRESET = "TRUE";
    //synthesis attribute EMAC1_CONFIGVEC_79 of v5_emac is "FALSE"
    defparam v5_emac.EMAC1_CONFIGVEC_79 = "FALSE";
    //synthesis attribute EMAC1_GTLOOPBACK of v5_emac is "FALSE"
    defparam v5_emac.EMAC1_GTLOOPBACK = "FALSE";
    //synthesis attribute EMAC1_UNIDIRECTION_ENABLE of v5_emac is "FALSE"
    defparam v5_emac.EMAC1_UNIDIRECTION_ENABLE = "FALSE";
    //synthesis attribute EMAC1_LINKTIMERVAL of v5_emac is 9'h000
    defparam v5_emac.EMAC1_LINKTIMERVAL = 9'h000;

    // Configure the MAC operating mode
    // MDIO is not enabled
    //synthesis attribute EMAC1_MDIO_ENABLE of v5_emac is "FALSE"
    defparam v5_emac.EMAC1_MDIO_ENABLE = "FALSE";  
    // Speed is defaulted to 1000Mb/s
    //synthesis attribute EMAC1_SPEED_LSB of v5_emac is "FALSE"
    defparam v5_emac.EMAC1_SPEED_LSB = "FALSE";
    //synthesis attribute EMAC1_SPEED_MSB of v5_emac is "TRUE"
    defparam v5_emac.EMAC1_SPEED_MSB = "TRUE"; 
    //synthesis attribute EMAC1_USECLKEN of v5_emac is "FALSE"
    defparam v5_emac.EMAC1_USECLKEN = "FALSE";
    //synthesis attribute EMAC1_BYTEPHY of v5_emac is "FALSE"
    defparam v5_emac.EMAC1_BYTEPHY = "FALSE";
   
    //synthesis attribute EMAC1_RGMII_ENABLE of v5_emac is "FALSE"
    defparam v5_emac.EMAC1_RGMII_ENABLE = "FALSE";
    //synthesis attribute EMAC1_SGMII_ENABLE of v5_emac is "FALSE"
    defparam v5_emac.EMAC1_SGMII_ENABLE = "FALSE";
    //synthesis attribute EMAC1_1000BASEX_ENABLE of v5_emac is "FALSE"
    defparam v5_emac.EMAC1_1000BASEX_ENABLE = "FALSE";
    // The Host I/F is not  in use
    //synthesis attribute EMAC1_HOST_ENABLE of v5_emac is "FALSE"
    defparam v5_emac.EMAC1_HOST_ENABLE = "FALSE";  
    // 8-bit interface for Tx client
    //synthesis attribute EMAC1_TX16BITCLIENT_ENABLE of v5_emac is "FALSE"
    defparam v5_emac.EMAC1_TX16BITCLIENT_ENABLE = "FALSE";
    // 8-bit interface for Rx client
    //synthesis attribute EMAC1_RX16BITCLIENT_ENABLE of v5_emac is "FALSE"
    defparam v5_emac.EMAC1_RX16BITCLIENT_ENABLE = "FALSE";    
    // The Address Filter (not enabled)
    //synthesis attribute EMAC1_ADDRFILTER_ENABLE of v5_emac is "FALSE"
    defparam v5_emac.EMAC1_ADDRFILTER_ENABLE = "FALSE";  

    // MAC configuration defaults
    // Rx Length/Type checking enabled (standard IEEE operation)
    //synthesis attribute EMAC1_LTCHECK_DISABLE of v5_emac is "FALSE"
    defparam v5_emac.EMAC1_LTCHECK_DISABLE = "FALSE";  
    // Rx Flow Control (not enabled)
    //synthesis attribute EMAC1_RXFLOWCTRL_ENABLE of v5_emac is "FALSE"
    defparam v5_emac.EMAC1_RXFLOWCTRL_ENABLE = "FALSE";  
    // Tx Flow Control (not enabled)
    //synthesis attribute EMAC1_TXFLOWCTRL_ENABLE of v5_emac is "FALSE"
    defparam v5_emac.EMAC1_TXFLOWCTRL_ENABLE = "FALSE";  
    // Transmitter is not held in reset not asserted (normal operating mode)
    //synthesis attribute EMAC1_TXRESET of v5_emac is "FALSE"
    defparam v5_emac.EMAC1_TXRESET = "FALSE";  
    // Transmitter Jumbo Frames (not enabled)
    //synthesis attribute EMAC1_TXJUMBOFRAME_ENABLE of v5_emac is "FALSE"
    defparam v5_emac.EMAC1_TXJUMBOFRAME_ENABLE = "FALSE";  
    // Transmitter In-band FCS (not enabled)
    //synthesis attribute EMAC1_TXINBANDFCS_ENABLE of v5_emac is "FALSE"
    defparam v5_emac.EMAC1_TXINBANDFCS_ENABLE = "FALSE";  
    // Transmitter Enabled
    //synthesis attribute EMAC1_TX_ENABLE of v5_emac is "TRUE"
    defparam v5_emac.EMAC1_TX_ENABLE = "TRUE";  
    // Transmitter VLAN mode (not enabled)
    //synthesis attribute EMAC1_TXVLAN_ENABLE of v5_emac is "FALSE"
    defparam v5_emac.EMAC1_TXVLAN_ENABLE = "FALSE";  
    // Transmitter Half Duplex mode (not enabled)
    //synthesis attribute EMAC1_TXHALFDUPLEX of v5_emac is "FALSE"
    defparam v5_emac.EMAC1_TXHALFDUPLEX = "FALSE";  
    // Transmitter IFG Adjust (not enabled)
    //synthesis attribute EMAC1_TXIFGADJUST_ENABLE of v5_emac is "FALSE"
    defparam v5_emac.EMAC1_TXIFGADJUST_ENABLE = "FALSE";  
    // Receiver is not held in reset not asserted (normal operating mode)
    //synthesis attribute EMAC1_RXRESET of v5_emac is "FALSE"
    defparam v5_emac.EMAC1_RXRESET = "FALSE";  
    // Receiver Jumbo Frames (not enabled)
    //synthesis attribute EMAC1_RXJUMBOFRAME_ENABLE of v5_emac is "FALSE"
    defparam v5_emac.EMAC1_RXJUMBOFRAME_ENABLE = "FALSE";  
    // Receiver In-band FCS (not enabled)
    //synthesis attribute EMAC1_RXINBANDFCS_ENABLE of v5_emac is "FALSE"
    defparam v5_emac.EMAC1_RXINBANDFCS_ENABLE = "FALSE";  
    // Receiver Enabled
    //synthesis attribute EMAC1_RX_ENABLE of v5_emac is "TRUE"
    defparam v5_emac.EMAC1_RX_ENABLE = "TRUE";  
    // Receiver VLAN mode (not enabled)
    //synthesis attribute EMAC1_RXVLAN_ENABLE of v5_emac is "FALSE"
    defparam v5_emac.EMAC1_RXVLAN_ENABLE = "FALSE";  
    // Receiver Half Duplex mode (not enabled)
    //synthesis attribute EMAC1_RXHALFDUPLEX of v5_emac is "FALSE"
    defparam v5_emac.EMAC1_RXHALFDUPLEX = "FALSE";  

    // Set the Pause Address Default
    //synthesis attribute EMAC1_PAUSEADDR of v5_emac is 48'hFFEEDDCCBBAA
    defparam v5_emac.EMAC1_PAUSEADDR = 48'hFFEEDDCCBBAA;

    //synthesis attribute EMAC1_UNICASTADDR of v5_emac is 48'h000000000000
    defparam v5_emac.EMAC1_UNICASTADDR = 48'h000000000000;
 
    //synthesis attribute EMAC1_DCRBASEADDR of v5_emac is 8'h00
    defparam v5_emac.EMAC1_DCRBASEADDR = 8'h00;

endmodule

