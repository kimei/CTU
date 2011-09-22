//-----------------------------------------------------------------------------
// Title      : Verilog instantiation template
// Project    : Virtex-5 Embedded Tri-Mode Ethernet MAC Wrapper
// File       : TEMAC2.veo
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
// Description: Verilog instantiation template for the Virtex-5 Embedded
//              Tri-Mode Ethernet MAC Wrapper (block-level wrapper).
//-----------------------------------------------------------------------------


// The following must be inserted into your Verilog file for this core to
// be instantiated. Change the port connections to your own signal names.

    //------------------------------------------------------------------------
    // Instantiate the EMAC Wrapper (TEMAC2_block.v)
    //------------------------------------------------------------------------
    TEMAC2_block v5_emac_block_inst
    (
    // EMAC1 Clocking
    // EMAC1 TX Clock input from BUFG
    .TX_CLK_1                            (TX_CLK_1),

    // Client Receiver Interface - EMAC1
    .EMAC1CLIENTRXD                      (EMAC1CLIENTRXD),
    .EMAC1CLIENTRXDVLD                   (EMAC1CLIENTRXDVLD),
    .EMAC1CLIENTRXGOODFRAME              (EMAC1CLIENTRXGOODFRAME),
    .EMAC1CLIENTRXBADFRAME               (EMAC1CLIENTRXBADFRAME),
    .EMAC1CLIENTRXFRAMEDROP              (EMAC1CLIENTRXFRAMEDROP),
    .EMAC1CLIENTRXSTATS                  (EMAC1CLIENTRXSTATS),
    .EMAC1CLIENTRXSTATSVLD               (EMAC1CLIENTRXSTATSVLD),
    .EMAC1CLIENTRXSTATSBYTEVLD           (EMAC1CLIENTRXSTATSBYTEVLD),

    // Client Transmitter Interface - EMAC1
    .CLIENTEMAC1TXD                      (CLIENTEMAC1TXD),
    .CLIENTEMAC1TXDVLD                   (CLIENTEMAC1TXDVLD),
    .EMAC1CLIENTTXACK                    (EMAC1CLIENTTXACK),
    .CLIENTEMAC1TXFIRSTBYTE              (CLIENTEMAC1TXFIRSTBYTE),
    .CLIENTEMAC1TXUNDERRUN               (CLIENTEMAC1TXUNDERRUN),
    .EMAC1CLIENTTXCOLLISION              (EMAC1CLIENTTXCOLLISION),
    .EMAC1CLIENTTXRETRANSMIT             (EMAC1CLIENTTXRETRANSMIT),
    .CLIENTEMAC1TXIFGDELAY               (CLIENTEMAC1TXIFGDELAY),
    .EMAC1CLIENTTXSTATS                  (EMAC1CLIENTTXSTATS),
    .EMAC1CLIENTTXSTATSVLD               (EMAC1CLIENTTXSTATSVLD),
    .EMAC1CLIENTTXSTATSBYTEVLD           (EMAC1CLIENTTXSTATSBYTEVLD),

    // MAC Control Interface - EMAC1
    .CLIENTEMAC1PAUSEREQ                 (CLIENTEMAC1PAUSEREQ),
    .CLIENTEMAC1PAUSEVAL                 (CLIENTEMAC1PAUSEVAL),

    .GTX_CLK_1                           (GTX_CLK_1),

    // GMII Interface - EMAC1
    .GMII_TXD_1                          (GMII_TXD_1),
    .GMII_TX_EN_1                        (GMII_TX_EN_1),
    .GMII_TX_ER_1                        (GMII_TX_ER_1),
    .GMII_TX_CLK_1                       (GMII_TX_CLK_1),
    .GMII_RXD_1                          (GMII_RXD_1),
    .GMII_RX_DV_1                        (GMII_RX_DV_1),
    .GMII_RX_ER_1                        (GMII_RX_ER_1),
    .GMII_RX_CLK_1                       (GMII_RX_CLK_1),

    // Asynchronous Reset Input
    .RESET                               (RESET));
