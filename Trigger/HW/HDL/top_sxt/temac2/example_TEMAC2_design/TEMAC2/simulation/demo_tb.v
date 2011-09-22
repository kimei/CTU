//----------------------------------------------------------------------
// Title      : Demo testbench
// Project    : Virtex-5 Embedded Tri-Mode Ethernet MAC Wrapper
// File       : demo_tb.v
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
//----------------------------------------------------------------------
// Description: This testbench will exercise the PHY ports of the EMAC
//              to demonstrate the functionality.
//----------------------------------------------------------------------

`timescale 1ps / 1ps


module testbench;


  //--------------------------------------------------------------------
  // testbench signals
  //--------------------------------------------------------------------
  wire        reset;

  // EMAC1
  wire        tx_client_clk_1;
  wire [7:0]  tx_ifg_delay_1;
  wire        rx_client_clk_1;
  wire [15:0] pause_val_1;
  wire        pause_req_1;

  // GMII wires
  wire        gmii_tx_clk_1;
  wire        gmii_tx_en_1;
  wire        gmii_tx_er_1;
  wire [7:0]  gmii_txd_1;
  wire        gmii_rx_clk_1;
  wire        gmii_rx_dv_1;
  wire        gmii_rx_er_1;
  wire [7:0]  gmii_rxd_1;
  // Not asserted: full duplex only testbench
  wire        mii_tx_clk_1;
  wire        gmii_crs_1;  
  wire        gmii_col_1;  


  // Clock wires
  wire        host_clk;
  reg         gtx_clk;
  reg         refclk;



  //----------------------------------------------------------------
  // Test Bench Semaphores
  //----------------------------------------------------------------
  wire        emac0_configuration_busy;
  wire        emac0_monitor_finished_1g;
  wire        emac0_monitor_finished_100m;
  wire        emac0_monitor_finished_10m;

  wire        emac1_configuration_busy;
  wire        emac1_monitor_finished_1g;
  wire        emac1_monitor_finished_100m;
  wire        emac1_monitor_finished_10m;

  //----------------------------------------------------------------
  // Wire up Device Under Test
  //----------------------------------------------------------------
  TEMAC2_example_design dut
    (
    // Client Receiver Interface - EMAC1
    .EMAC1CLIENTRXDVLD               (),
    .EMAC1CLIENTRXFRAMEDROP          (),
    .EMAC1CLIENTRXSTATS              (),
    .EMAC1CLIENTRXSTATSVLD           (),
    .EMAC1CLIENTRXSTATSBYTEVLD       (),

    // Client Transmitter Interface - EMAC1
    .CLIENTEMAC1TXIFGDELAY           (tx_ifg_delay_1),
    .EMAC1CLIENTTXSTATS              (),
    .EMAC1CLIENTTXSTATSVLD           (),
    .EMAC1CLIENTTXSTATSBYTEVLD       (),

    // MAC Control Interface - EMAC1								   
    .CLIENTEMAC1PAUSEREQ             (pause_req_1),					   
    .CLIENTEMAC1PAUSEVAL             (pause_val_1),					   
																	   
    // Clock wire - EMAC1
    .GTX_CLK_1                       (gtx_clk),

    // GMII Interface - EMAC1
    .GMII_TXD_1                      (gmii_txd_1),
    .GMII_TX_EN_1                    (gmii_tx_en_1),
    .GMII_TX_ER_1                    (gmii_tx_er_1),
    .GMII_TX_CLK_1                   (gmii_tx_clk_1),
    .GMII_RXD_1                      (gmii_rxd_1),
    .GMII_RX_DV_1                    (gmii_rx_dv_1),
    .GMII_RX_ER_1                    (gmii_rx_er_1),
    .GMII_RX_CLK_1                   (gmii_rx_clk_1),


    .REFCLK                          (refclk),
        
    // Asynchronous Reset
    .RESET                           (reset)
    );


  //--------------------------------------------------------------------------
  // Flow Control is unused in this demonstration
  //--------------------------------------------------------------------------
  assign pause_req_1 = 1'b0;
  assign pause_val_1 = 16'b0;

  // IFG stretching not used in demo.
  assign tx_ifg_delay_1 = 8'b0;





  //--------------------------------------------------------------------------
  // Clock drivers
  //--------------------------------------------------------------------------

  // Drive GTX_CLK at 125 MHz
  initial                 // drives gtx_clk at 125 MHz
  begin
    gtx_clk <= 1'b0;
  	#10000;
    forever
    begin	 
      gtx_clk <= 1'b0;
      #4000;
      gtx_clk <= 1'b1;
      #4000;
    end
  end


  // Drive refclk at 200MHz
  initial
  begin
    refclk <= 1'b0;
    #10000;
    forever
    begin
      refclk <= 1'b1;
      #2500;
      refclk <= 1'b0;
      #2500;
    end
  end




  //--------------------------------------------------------------------
  // Instantiate the EMAC1 PHY stimulus and monitor
  //--------------------------------------------------------------------

  emac1_phy_tb phy1_test
    (
      //----------------------------------------------------------------
      // GMII Interface
      //----------------------------------------------------------------
      .gmii_txd              (gmii_txd_1),  
      .gmii_tx_en            (gmii_tx_en_1),
      .gmii_tx_er            (gmii_tx_er_1),
      .gmii_tx_clk           (gmii_tx_clk_1),
      .gmii_rxd              (gmii_rxd_1),  
      .gmii_rx_dv            (gmii_rx_dv_1),
      .gmii_rx_er            (gmii_rx_er_1),
      .gmii_rx_clk           (gmii_rx_clk_1),
      .gmii_col              (gmii_col_1),
      .gmii_crs              (gmii_crs_1),
      .mii_tx_clk            (mii_tx_clk_1),

      //----------------------------------------------------------------
      // Test Bench Semaphores
      //----------------------------------------------------------------
      .configuration_busy    (emac1_configuration_busy),
      .monitor_finished_1g   (emac1_monitor_finished_1g),
      .monitor_finished_100m (emac1_monitor_finished_100m),
      .monitor_finished_10m  (emac1_monitor_finished_10m),
      .monitor_error         (monitor_error_emac1)
      );



  //--------------------------------------------------------------------
  // Instantiate the No-Host Configuration Stimulus
  //--------------------------------------------------------------------

  configuration_tb config_test 
    (
      .reset                       (reset),
      //----------------------------------------------------------------
      // Host Interface: host_clk is always required
      //----------------------------------------------------------------
      .host_clk                    (host_clk),

      //----------------------------------------------------------------
      // Test Bench Semaphores
      //----------------------------------------------------------------

      .emac0_configuration_busy    (emac0_configuration_busy),
      .emac0_monitor_finished_1g   (emac0_monitor_finished_1g),
      .emac0_monitor_finished_100m (emac0_monitor_finished_100m),
      .emac0_monitor_finished_10m  (emac0_monitor_finished_10m),

      .emac1_configuration_busy    (emac1_configuration_busy),
      .emac1_monitor_finished_1g   (emac1_monitor_finished_1g),
      .emac1_monitor_finished_100m (emac1_monitor_finished_100m),
      .emac1_monitor_finished_10m  (emac1_monitor_finished_10m),

      .monitor_error_emac1         (monitor_error_emac1)

      );



endmodule // testbench
