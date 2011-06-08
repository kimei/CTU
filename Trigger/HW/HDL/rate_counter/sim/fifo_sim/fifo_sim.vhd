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

    rate_cards  : in std_logic_vector(NUMBER_OF_ROCS - 1 downto 0);
    coincidence : in std_logic_vector(NUMBER_OF_ROCS - 1 downto 0)
    );
end v5_emac_v1_5_example_design;


architecture TOP_LEVEL of v5_emac_v1_5_example_design is
  signal reset : std_logic;



  -- fifo interface
  signal we_rate_counter  : std_logic;
  signal we_others        : std_logic;
  signal din_rate_counter : std_logic_vector(7 downto 0);
  signal din_fifo         : std_logic_vector(7 downto 0);
  signal rd_en_fifo       : std_logic;

  signal wr_en_fifo      : std_logic;
  signal data_count_fifo : std_logic_vector(7 downto 0);
  signal dout_fifo       : std_logic_vector(7 downto 0);
  signal empty_fifo      : std_logic;
  signal full_fifo       : std_logic;



  
-----------------------------------------------------------------------
-- Signal Declarations
-----------------------------------------------------------------------

    -- Global asynchronous reset
    signal reset_i : std_logic;

  -- client interface clocking signals - EMAC0
  signal ll_clk_0_i : std_logic;


  signal counter : integer range 0 to 30000;

begin
  reset       <= not rst_b;
  reset_i     <= not rst_b;


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

  -- purpose: <[description]>
  rstproc: process (clk200, rst_b)
  begin  -- process rstproc
    if rst_b = '0' then                 -- asynchronous reset (active low)
      rd_en_fifo <= '0';

    elsif clk200'event and clk200 = '1' then  -- rising clock edge
      
    end if;
  end process rstproc;


  rate_counter_1 : rate_counter
    port map(
      clk         => clk200,
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
      clk        => clk200,
      din        => din_fifo,
      rd_en      => rd_en_fifo,
      rst        => reset,
      wr_en      => wr_en_fifo,
      data_count => data_count_fifo,
      dout       => dout_fifo,
      empty      => empty_fifo,
      full       => full_fifo
      );





  
end TOP_LEVEL;