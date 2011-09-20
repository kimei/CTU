-------------------------------------------------------------------------------
-- Title      : Virtex-5 Ethernet MAC Local Link Wrapper
-- Project    : Virtex-5 Embedded Tri-Mode Ethernet MAC Wrapper
-- File       : TEMAC2_locallink.vhd
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
-- Description:  This level:
--
--               * instantiates the TEMAC top level file (the TEMAC
--                 wrapper with the clocking and physical interface
--				   logic;
--               
--               * instantiates TX and RX reference design FIFO's with 
--                 a local link interface.
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
-- The entity declaration for the local link design.
-------------------------------------------------------------------------------
entity TEMAC2_locallink is
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
end TEMAC2_locallink;


architecture TOP_LEVEL of TEMAC2_locallink is

-------------------------------------------------------------------------------
-- Component Declarations for lower hierarchial level entities
-------------------------------------------------------------------------------
  -- Component Declaration for the main EMAC wrapper
  component TEMAC2_block is
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
  end component;
 
   ---------------------------------------------------------------------
   -- Component Declaration for the 8-bit client side FIFO
   ---------------------------------------------------------------------
   component eth_fifo_8
   generic (
        FULL_DUPLEX_ONLY    : boolean);
   port (
        -- Transmit FIFO MAC TX Interface
        tx_clk              : in  std_logic;
        tx_reset            : in  std_logic;
        tx_enable           : in  std_logic;
        tx_data             : out std_logic_vector(7 downto 0);
        tx_data_valid       : out std_logic;
        tx_ack              : in  std_logic;
        tx_underrun         : out std_logic;
        tx_collision        : in  std_logic;
        tx_retransmit       : in  std_logic;

        -- Transmit FIFO Local-link Interface
        tx_ll_clock         : in  std_logic;
        tx_ll_reset         : in  std_logic;
        tx_ll_data_in       : in  std_logic_vector(7 downto 0);
        tx_ll_sof_in_n      : in  std_logic;
        tx_ll_eof_in_n      : in  std_logic;
        tx_ll_src_rdy_in_n  : in  std_logic;
        tx_ll_dst_rdy_out_n : out std_logic;
        tx_fifo_status      : out std_logic_vector(3 downto 0);
        tx_overflow         : out std_logic;

        -- Receive FIFO MAC RX Interface
        rx_clk              : in  std_logic;
        rx_reset            : in  std_logic;
        rx_enable           : in  std_logic;
        rx_data             : in  std_logic_vector(7 downto 0);
        rx_data_valid       : in  std_logic;
        rx_good_frame       : in  std_logic;
        rx_bad_frame        : in  std_logic;
        rx_overflow         : out std_logic;

        -- Receive FIFO Local-link Interface
        rx_ll_clock         : in  std_logic;
        rx_ll_reset         : in  std_logic;
        rx_ll_data_out      : out std_logic_vector(7 downto 0);
        rx_ll_sof_out_n     : out std_logic;
        rx_ll_eof_out_n     : out std_logic;
        rx_ll_src_rdy_out_n : out std_logic;
        rx_ll_dst_rdy_in_n  : in  std_logic;
        rx_fifo_status      : out std_logic_vector(3 downto 0)
        );
   end component;

-------------------------------------------------------------------------------
-- Signal Declarations
-------------------------------------------------------------------------------

    -- Global asynchronous reset
    signal reset_i               : std_logic;

    -- client interface clocking signals - EMAC1
    signal tx_clk_1_i            : std_logic;
    signal rx_clk_1_i            : std_logic;

    -- internal client interface connections - EMAC1
    -- transmitter interface
    signal tx_data_1_i           : std_logic_vector(7 downto 0);
    signal tx_data_valid_1_i     : std_logic;
    signal tx_underrun_1_i       : std_logic;
    signal tx_ack_1_i            : std_logic;
    signal tx_collision_1_i      : std_logic;
    signal tx_retransmit_1_i     : std_logic;
    -- receiver interface
    signal rx_data_1_i           : std_logic_vector(7 downto 0);
    signal rx_data_valid_1_i     : std_logic;
    signal rx_good_frame_1_i     : std_logic;
    signal rx_bad_frame_1_i      : std_logic;
    -- registers for the MAC receiver output
    signal rx_data_1_r           : std_logic_vector(7 downto 0);
    signal rx_data_valid_1_r     : std_logic;
    signal rx_good_frame_1_r     : std_logic;
    signal rx_bad_frame_1_r      : std_logic;

    -- create a synchronous reset in the transmitter clock domain
    signal tx_pre_reset_1_i      : std_logic_vector(5 downto 0);
    signal tx_reset_1_i          : std_logic;

    -- create a synchronous reset in the receiver clock domain
    signal rx_pre_reset_1_i      : std_logic_vector(5 downto 0);
    signal rx_reset_1_i          : std_logic;



    attribute async_reg : string;
    attribute async_reg of rx_pre_reset_1_i : signal is "true";
    attribute async_reg of tx_pre_reset_1_i : signal is "true";

    attribute keep : string;
    attribute keep of tx_data_1_i : signal is "true";
    attribute keep of tx_data_valid_1_i : signal is "true";
    attribute keep of tx_ack_1_i : signal is "true";
    attribute keep of rx_data_1_i : signal is "true";
    attribute keep of rx_data_valid_1_i : signal is "true";

-------------------------------------------------------------------------------
-- Main Body of Code
-------------------------------------------------------------------------------
begin

    ---------------------------------------------------------------------------
    -- Asynchronous Reset Input
    ---------------------------------------------------------------------------
    reset_i <= RESET;

    --------------------------------------------------------------------------
    -- Instantiate the EMAC Wrapper (TEMAC2_block.vhd)
    --------------------------------------------------------------------------
    v5_emac_block_inst : TEMAC2_block
    port map (
          -- EMAC1 Clocking
      -- EMAC1 TX Clock input from BUFG
      TX_CLK_1                        => TX_CLK_1,

      -- Client Receiver Interface - EMAC1
      EMAC1CLIENTRXD                  => rx_data_1_i,
      EMAC1CLIENTRXDVLD               => rx_data_valid_1_i,
      EMAC1CLIENTRXGOODFRAME          => rx_good_frame_1_i,
      EMAC1CLIENTRXBADFRAME           => rx_bad_frame_1_i,
      EMAC1CLIENTRXFRAMEDROP          => EMAC1CLIENTRXFRAMEDROP,
      EMAC1CLIENTRXSTATS              => EMAC1CLIENTRXSTATS,
      EMAC1CLIENTRXSTATSVLD           => EMAC1CLIENTRXSTATSVLD,
      EMAC1CLIENTRXSTATSBYTEVLD       => EMAC1CLIENTRXSTATSBYTEVLD,

      -- Client Transmitter Interface - EMAC1
      CLIENTEMAC1TXD                  => tx_data_1_i,
      CLIENTEMAC1TXDVLD               => tx_data_valid_1_i,
      EMAC1CLIENTTXACK                => tx_ack_1_i,
      CLIENTEMAC1TXFIRSTBYTE          => '0',
      CLIENTEMAC1TXUNDERRUN           => tx_underrun_1_i,
      EMAC1CLIENTTXCOLLISION          => tx_collision_1_i,
      EMAC1CLIENTTXRETRANSMIT         => tx_retransmit_1_i,
      CLIENTEMAC1TXIFGDELAY           => CLIENTEMAC1TXIFGDELAY,
      EMAC1CLIENTTXSTATS              => EMAC1CLIENTTXSTATS,
      EMAC1CLIENTTXSTATSVLD           => EMAC1CLIENTTXSTATSVLD,
      EMAC1CLIENTTXSTATSBYTEVLD       => EMAC1CLIENTTXSTATSBYTEVLD,

      -- MAC Control Interface - EMAC1
      CLIENTEMAC1PAUSEREQ             => CLIENTEMAC1PAUSEREQ,
      CLIENTEMAC1PAUSEVAL             => CLIENTEMAC1PAUSEVAL,

           
      -- Clock Signals - EMAC1
      GTX_CLK_1                       => GTX_CLK_1,
      -- GMII Interface - EMAC1
      GMII_TXD_1                      => GMII_TXD_1,
      GMII_TX_EN_1                    => GMII_TX_EN_1,
      GMII_TX_ER_1                    => GMII_TX_ER_1,
      GMII_TX_CLK_1                   => GMII_TX_CLK_1,
      GMII_RXD_1                      => GMII_RXD_1,
      GMII_RX_DV_1                    => GMII_RX_DV_1,
      GMII_RX_ER_1                    => GMII_RX_ER_1,
      GMII_RX_CLK_1                   => GMII_RX_CLK_1,

        
        
      -- Asynchronous Reset
      RESET                           => reset_i
   );

   ----------------------------------------------------------------------
   -- Instantiate the client side FIFO for EMAC1
   ----------------------------------------------------------------------
   client_side_FIFO_emac1 : eth_fifo_8
     generic map (
       FULL_DUPLEX_ONLY     => false)
     port map (
       -- Transmitter MAC Client Interface
       tx_clk               => tx_clk_1_i,
       tx_reset             => tx_reset_1_i,
       tx_enable            => '1',
       tx_data              => tx_data_1_i,
       tx_data_valid        => tx_data_valid_1_i,
       tx_ack               => tx_ack_1_i,
       tx_underrun          => tx_underrun_1_i,
       tx_collision         => tx_collision_1_i,
       tx_retransmit        => tx_retransmit_1_i,

       -- Transmitter Local Link Interface
       tx_ll_clock          => TX_LL_CLOCK_1,
       tx_ll_reset          => TX_LL_RESET_1,
       tx_ll_data_in        => TX_LL_DATA_1,
       tx_ll_sof_in_n       => TX_LL_SOF_N_1,
       tx_ll_eof_in_n       => TX_LL_EOF_N_1,
       tx_ll_src_rdy_in_n   => TX_LL_SRC_RDY_N_1,
       tx_ll_dst_rdy_out_n  => TX_LL_DST_RDY_N_1,
       tx_fifo_status       => open,
       tx_overflow          => open,

       -- Receiver MAC Client Interface
       rx_clk               => rx_clk_1_i,
       rx_reset             => rx_reset_1_i,
       rx_enable            => '1',
       rx_data              => rx_data_1_r,
       rx_data_valid        => rx_data_valid_1_r,
       rx_good_frame        => rx_good_frame_1_r,
       rx_bad_frame         => rx_bad_frame_1_r,
       rx_overflow          => open,

       -- Receiver Local Link Interface
       rx_ll_clock          => RX_LL_CLOCK_1,
       rx_ll_reset          => RX_LL_RESET_1,
       rx_ll_data_out       => RX_LL_DATA_1,
       rx_ll_sof_out_n      => RX_LL_SOF_N_1,
       rx_ll_eof_out_n      => RX_LL_EOF_N_1,
       rx_ll_src_rdy_out_n  => RX_LL_SRC_RDY_N_1,
       rx_ll_dst_rdy_in_n   => RX_LL_DST_RDY_N_1,
       rx_fifo_status       => RX_LL_FIFO_STATUS_1
       );


   -- Create synchronous reset in the transmitter clock domain.
   gen_tx_reset_emac1 : process (tx_clk_1_i, reset_i)
   begin
     if reset_i = '1' then
       tx_pre_reset_1_i <= (others => '1');
       tx_reset_1_i     <= '1';
     elsif tx_clk_1_i'event and tx_clk_1_i = '1' then
         tx_pre_reset_1_i(0)          <= '0';
         tx_pre_reset_1_i(5 downto 1) <= tx_pre_reset_1_i(4 downto 0);
         tx_reset_1_i                 <= tx_pre_reset_1_i(5);
     end if;
   end process gen_tx_reset_emac1;

   -- Create synchronous reset in the receiver clock domain.
   gen_rx_reset_emac1 : process (rx_clk_1_i, reset_i)
   begin
     if reset_i = '1' then
       rx_pre_reset_1_i <= (others => '1');
       rx_reset_1_i     <= '1';
     elsif rx_clk_1_i'event and rx_clk_1_i = '1' then
         rx_pre_reset_1_i(0)          <= '0';
         rx_pre_reset_1_i(5 downto 1) <= rx_pre_reset_1_i(4 downto 0);
         rx_reset_1_i                 <= rx_pre_reset_1_i(5);
     end if;
   end process gen_rx_reset_emac1;

   ----------------------------------------------------------------------
   -- Register the receiver outputs from EMAC1 before routing 
   -- to the FIFO
   ----------------------------------------------------------------------
   regipgen_emac1 : process(rx_clk_1_i, reset_i)
   begin
     if reset_i = '1' then
       rx_data_1_r       <= (others => '0');
       rx_data_valid_1_r <= '0';
       rx_good_frame_1_r <= '0';
       rx_bad_frame_1_r  <= '0';
     elsif rx_clk_1_i'event and rx_clk_1_i = '1' then
         rx_data_1_r       <= rx_data_1_i;
         rx_data_valid_1_r <= rx_data_valid_1_i;
         rx_good_frame_1_r <= rx_good_frame_1_i;
         rx_bad_frame_1_r  <= rx_bad_frame_1_i;
     end if;
   end process regipgen_emac1;
 
   EMAC1CLIENTRXDVLD <= rx_data_valid_1_i;

   -- EMAC1 Clocking
   tx_clk_1_i  <= TX_CLK_1;
   rx_clk_1_i  <= GMII_RX_CLK_1;
 
end TOP_LEVEL;
