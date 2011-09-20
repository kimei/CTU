//-----------------------------------------------------------------------------
// Title      : Virtex-5 Ethernet MAC Wrapper Top Level
// Project    : Virtex-5 Embedded Tri-Mode Ethernet MAC Wrapper
// File       : TEMAC2_block.v
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
//-----------------------------------------------------------------------------
// Description:  This is the EMAC block level Verilog design for the Virtex-5 
//               Embedded Ethernet MAC Example Design.  It is intended that
//               this example design can be quickly adapted and downloaded onto
//               an FPGA to provide a real hardware test environment.
//
//               The block level:
//
//               * instantiates all clock management logic required (BUFGs, 
//                 DCMs) to operate the EMAC and its example design;
//
//               * instantiates appropriate PHY interface modules (GMII, MII,
//                 RGMII, SGMII or 1000BASE-X) as required based on the user
//                 configuration.
//
//
//               Please refer to the Datasheet, Getting Started Guide, and
//               the Virtex-5 Embedded Tri-Mode Ethernet MAC User Gude for
//               further information.
//-----------------------------------------------------------------------------


`timescale 1 ps / 1 ps


//-----------------------------------------------------------------------------
// The module declaration for the top level design.
//-----------------------------------------------------------------------------
module TEMAC2_block
(
    // EMAC1 Clocking
    // EMAC1 TX Clock input from BUFG
    TX_CLK_1,

    // Client Receiver Interface - EMAC1
    EMAC1CLIENTRXD,
    EMAC1CLIENTRXDVLD,
    EMAC1CLIENTRXGOODFRAME,
    EMAC1CLIENTRXBADFRAME,
    EMAC1CLIENTRXFRAMEDROP,
    EMAC1CLIENTRXSTATS,
    EMAC1CLIENTRXSTATSVLD,
    EMAC1CLIENTRXSTATSBYTEVLD,

    // Client Transmitter Interface - EMAC1
    CLIENTEMAC1TXD,
    CLIENTEMAC1TXDVLD,
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

    // GMII Interface - EMAC1
    GMII_TXD_1,
    GMII_TX_EN_1,
    GMII_TX_ER_1,
    GMII_TX_CLK_1,
    GMII_RXD_1,
    GMII_RX_DV_1,
    GMII_RX_ER_1,
    GMII_RX_CLK_1,

    // Asynchronous Reset Input
    RESET
);


//-----------------------------------------------------------------------------
// Port Declarations 
//-----------------------------------------------------------------------------
    // EMAC1 Clocking
    // EMAC1 TX Clock input from BUFG
    input           TX_CLK_1;

    // Client Receiver Interface - EMAC1
    output   [7:0]  EMAC1CLIENTRXD;
    output          EMAC1CLIENTRXDVLD;
    output          EMAC1CLIENTRXGOODFRAME;
    output          EMAC1CLIENTRXBADFRAME;
    output          EMAC1CLIENTRXFRAMEDROP;
    output   [6:0]  EMAC1CLIENTRXSTATS;
    output          EMAC1CLIENTRXSTATSVLD;
    output          EMAC1CLIENTRXSTATSBYTEVLD;

    // Client Transmitter Interface - EMAC1
    input    [7:0]  CLIENTEMAC1TXD;
    input           CLIENTEMAC1TXDVLD;
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

    // GMII Interface - EMAC1
    output   [7:0]  GMII_TXD_1;
    output          GMII_TX_EN_1;
    output          GMII_TX_ER_1;
    output          GMII_TX_CLK_1;
    input    [7:0]  GMII_RXD_1;
    input           GMII_RX_DV_1;
    input           GMII_RX_ER_1;
    input           GMII_RX_CLK_1;

    // Asynchronous Reset
    input           RESET;

//-----------------------------------------------------------------------------
// Wire and Reg Declarations 
//-----------------------------------------------------------------------------

    // Asynchronous reset signals
    wire            reset_ibuf_i;
    wire            reset_i;


    // EMAC1 client clocking signals
    wire            rx_client_clk_out_1_i;
    wire            rx_client_clk_in_1_i;
    wire            tx_client_clk_out_1_i;
    wire            tx_client_clk_in_1_i;
    // EMAC1 physical interface clocking signals
    wire            tx_gmii_mii_clk_out_1_i;
    wire            tx_gmii_mii_clk_in_1_i;

    // EMAC1 Physical interface signals
    wire            gmii_tx_en_1_i;
    wire            gmii_tx_er_1_i;
    wire     [7:0]  gmii_txd_1_i;
    wire            gmii_rx_dv_1_r;
    wire            gmii_rx_er_1_r;
    wire     [7:0]  gmii_rxd_1_r;
    wire            gmii_rx_clk_1_i;    

    // 125MHz reference clock for EMAC1
    wire            gtx_clk_ibufg_1_i;



//-----------------------------------------------------------------------------
// Main Body of Code 
//-----------------------------------------------------------------------------


    //-------------------------------------------------------------------------
    // Main Reset Circuitry
    //-------------------------------------------------------------------------

    assign reset_ibuf_i = RESET;

    assign reset_i = reset_ibuf_i;

    //-------------------------------------------------------------------------
    // GMII circuitry for the Physical Interface of EMAC1
    //-------------------------------------------------------------------------

    gmii_if gmii1 (
        .RESET(reset_i),
        .GMII_TXD(GMII_TXD_1),
        .GMII_TX_EN(GMII_TX_EN_1),
        .GMII_TX_ER(GMII_TX_ER_1),
        .GMII_TX_CLK(GMII_TX_CLK_1),
        .GMII_RXD(GMII_RXD_1),
        .GMII_RX_DV(GMII_RX_DV_1),
        .GMII_RX_ER(GMII_RX_ER_1),
        .TXD_FROM_MAC(gmii_txd_1_i),
        .TX_EN_FROM_MAC(gmii_tx_en_1_i),
        .TX_ER_FROM_MAC(gmii_tx_er_1_i),
        .TX_CLK(tx_gmii_mii_clk_in_1_i),
        .RXD_TO_MAC(gmii_rxd_1_r),
        .RX_DV_TO_MAC(gmii_rx_dv_1_r),
        .RX_ER_TO_MAC(gmii_rx_er_1_r),
        .RX_CLK(gmii_rx_clk_1_i));

 

    //------------------------------------------------------------------------
    // GTX_CLK Clock Management - 125 MHz clock frequency supplied by the user
    // (Connected to PHYEMAC#GTXCLK of the EMAC primitive)
    //------------------------------------------------------------------------
    assign gtx_clk_ibufg_1_i = GTX_CLK_1;



    //------------------------------------------------------------------------
    // GMII PHY side transmit clock for EMAC1
    //------------------------------------------------------------------------
    assign tx_gmii_mii_clk_in_1_i = TX_CLK_1;

    //------------------------------------------------------------------------
    // GMII PHY side Receiver Clock for EMAC1
    //------------------------------------------------------------------------
    assign gmii_rx_clk_1_i = GMII_RX_CLK_1;


    //------------------------------------------------------------------------
    // GMII client side transmit clock for EMAC1
    //------------------------------------------------------------------------
    assign tx_client_clk_in_1_i = TX_CLK_1;

    //------------------------------------------------------------------------
    // GMII client side receive clock for EMAC1
    //------------------------------------------------------------------------
    assign rx_client_clk_in_1_i = gmii_rx_clk_1_i;




    //------------------------------------------------------------------------
    // Connect previously derived client clocks to example design output ports
    //------------------------------------------------------------------------

    // EMAC1 Clocking



    //------------------------------------------------------------------------
    // Instantiate the EMAC Wrapper (TEMAC2.v) 
    //------------------------------------------------------------------------
    TEMAC2 v5_emac_wrapper_inst
    (
        // Client Receiver Interface - EMAC1
        .EMAC1CLIENTRXCLIENTCLKOUT      (rx_client_clk_out_1_i),
        .CLIENTEMAC1RXCLIENTCLKIN       (rx_client_clk_in_1_i),
        .EMAC1CLIENTRXD                 (EMAC1CLIENTRXD),
        .EMAC1CLIENTRXDVLD              (EMAC1CLIENTRXDVLD),
        .EMAC1CLIENTRXDVLDMSW           (),
        .EMAC1CLIENTRXGOODFRAME         (EMAC1CLIENTRXGOODFRAME),
        .EMAC1CLIENTRXBADFRAME          (EMAC1CLIENTRXBADFRAME),
        .EMAC1CLIENTRXFRAMEDROP         (EMAC1CLIENTRXFRAMEDROP),
        .EMAC1CLIENTRXSTATS             (EMAC1CLIENTRXSTATS),
        .EMAC1CLIENTRXSTATSVLD          (EMAC1CLIENTRXSTATSVLD),
        .EMAC1CLIENTRXSTATSBYTEVLD      (EMAC1CLIENTRXSTATSBYTEVLD),

        // Client Transmitter Interface - EMAC1
        .EMAC1CLIENTTXCLIENTCLKOUT      (tx_client_clk_out_1_i),
        .CLIENTEMAC1TXCLIENTCLKIN       (tx_client_clk_in_1_i),
        .CLIENTEMAC1TXD                 (CLIENTEMAC1TXD),
        .CLIENTEMAC1TXDVLD              (CLIENTEMAC1TXDVLD),
        .CLIENTEMAC1TXDVLDMSW           (1'b0),
        .EMAC1CLIENTTXACK               (EMAC1CLIENTTXACK),
        .CLIENTEMAC1TXFIRSTBYTE         (CLIENTEMAC1TXFIRSTBYTE),
        .CLIENTEMAC1TXUNDERRUN          (CLIENTEMAC1TXUNDERRUN),
        .EMAC1CLIENTTXCOLLISION         (EMAC1CLIENTTXCOLLISION),
        .EMAC1CLIENTTXRETRANSMIT        (EMAC1CLIENTTXRETRANSMIT),
        .CLIENTEMAC1TXIFGDELAY          (CLIENTEMAC1TXIFGDELAY),
        .EMAC1CLIENTTXSTATS             (EMAC1CLIENTTXSTATS),
        .EMAC1CLIENTTXSTATSVLD          (EMAC1CLIENTTXSTATSVLD),
        .EMAC1CLIENTTXSTATSBYTEVLD      (EMAC1CLIENTTXSTATSBYTEVLD),

        // MAC Control Interface - EMAC1
        .CLIENTEMAC1PAUSEREQ            (CLIENTEMAC1PAUSEREQ),
        .CLIENTEMAC1PAUSEVAL            (CLIENTEMAC1PAUSEVAL),

        // Clock Signals - EMAC1
        .GTX_CLK_1                      (gtx_clk_ibufg_1_i),

        .EMAC1PHYTXGMIIMIICLKOUT        (tx_gmii_mii_clk_out_1_i),
        .PHYEMAC1TXGMIIMIICLKIN         (tx_gmii_mii_clk_in_1_i),

        // GMII Interface - EMAC1
        .GMII_TXD_1                     (gmii_txd_1_i),
        .GMII_TX_EN_1                   (gmii_tx_en_1_i),
        .GMII_TX_ER_1                   (gmii_tx_er_1_i),
        .GMII_RXD_1                     (gmii_rxd_1_r),
        .GMII_RX_DV_1                   (gmii_rx_dv_1_r),
        .GMII_RX_ER_1                   (gmii_rx_er_1_r),
        .GMII_RX_CLK_1                  (gmii_rx_clk_1_i),


        .DCM_LOCKED_1                   (1'b1  ),

        // Asynchronous Reset
        .RESET                          (reset_i)
        );


  
 



endmodule
