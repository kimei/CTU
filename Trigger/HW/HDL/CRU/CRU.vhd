----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Kim-Eigard Hines 
-- 
-- Create Date:    13:59:59 01/18/2011 
-- Design Name:  Clock and Reset unit for distribution of clock and resets
-- Module Name:    CRU - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
-- The CRU on the trigger unit shall handle the global clock, local clock and
-- system reset. The system reset, following jo-inges practice will be
-- asynchronous assert, and synchronous deassert. The reset will not deassert
-- until clk_lock goes high.
------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

library UNISIM;
use UNISIM.VComponents.all;

library work;

use work.constants.all;

entity CRU is
  port (
    fpga_100m_clk  : in std_logic;
    fpga_cpu_reset : in std_logic;

    -- Clock outputs
    mclk   : out std_logic;
    mclk_b : out std_logic;             -- Master clock
    gclk   : out std_logic;  -- single ended clock used on 'this fpga.
    clk200 : out std_logic;
    clk125 : out std_logic;

    -- Reset outputs
    mrst_b : out std_logic;             -- Global master reset
    lrst_b : out std_logic);            -- Local reset
end CRU;


architecture Behavioral of CRU is
  type   States is (INIT, RESET_PLL, WAIT1, DET_CLOCKLOSS, WAIT_CLK_LOCK, EN_OUTPUT, RESET_ROCS, RST5, WAIT2, UD10, UD11, UD12, UD13, UD14, UD15, UD16);
  signal state : States;

  -- Signals out from state machine
  ----------------------------------------------------------------------------- 
  signal enable_diff_out_b : std_logic;
  signal reset_global_b    : std_logic;
  signal rst_sync_b        : std_logic;  -- Synchronous version of reset_global_b

  signal pll_reset     : std_logic;
  signal wait_counter  : integer range 65535 downto 0;  -- To delay the reset signal (16 bit int)
  signal wait_counter2 : integer range 16 downto 0;
  signal rst_counter   : integer range (NUMBER_OF_ROCS+2) downto 0;
  -----------------------------------------------------------------------------

  signal clk_lock        : std_logic;
  signal fpga_100m_clk_s : std_logic;
  signal mclk_s          : std_logic;  -- Master clock, single ended to go into differential port
  signal mclk_o_ddr      : std_logic;   -- Out from ODDR
  signal gclk_s          : std_logic;  -- Signal of gclksignal mclk_s : std_logic;
  signal clk125_s        : std_logic;
  signal clk200_s        : std_logic;

  -----------------------------------------------------------------------------
  -- Component declarations for XILINX primitives
  -----------------------------------------------------------------------------
  component IBUFG
    port (O : out std_ulogic;
          I : in  std_ulogic);
  end component;

  component PLL_core
    port(
      CLKIN1_IN   : in  std_logic;
      RST_IN      : in  std_logic;
      CLKOUT0_OUT : out std_logic;
      CLKOUT1_OUT : out std_logic;
      CLKOUT2_OUT : out std_logic;
      CLKOUT3_OUT : out std_logic;
      LOCKED_OUT  : out std_logic
      );
  end component;

  component OBUFDS
    port (
      O  : out std_ulogic;
      OB : out std_ulogic;
      I  : in  std_ulogic);
  end component;

  component ODDR
    generic(
      DDR_CLK_EDGE : string := "OPPOSITE_EDGE";
      INIT         : bit    := '0';
      SRTYPE       : string := "SYNC");
    port(
      Q  : out std_ulogic;
      S  : in  std_ulogic;
      R  : in  std_ulogic;
      D1 : in  std_ulogic;
      D2 : in  std_ulogic;
      CE : in  std_ulogic;
      C  : in  std_ulogic);
  end component;
  
begin
  -----------------------------------------------------------------------------
  -- Component instantiations
  -----------------------------------------------------------------------------
  Inst_PLL_ALL : PLL_core port map(
    CLKIN1_IN   => fpga_100m_clk_s,
    RST_IN      => pll_reset,
    CLKOUT0_OUT => mclk_s,
    CLKOUT1_OUT => gclk_s,
    CLKOUT2_OUT => clk125_s,
    CLKOUT3_OUT => clk200_s,
    LOCKED_OUT  => clk_lock);

  MCLK_DIFF_OUT : OBUFDS port map(
    O  => mclk,
    OB => mclk_b,
    I  => mclk_o_ddr);

  MCLK_ODDR_OUT : ODDR port map(
    Q  => mclk_o_ddr,
    S  => '0',
    R  => enable_diff_out_b,
    D1 => '1',
    D2 => '0',
    CE => '1',
    C  => mclk_s);

  IBUFG_INSTANCE_NAME : IBUFG
    port map (O => fpga_100m_clk_s,
              I => fpga_100m_clk);

  fe_rst_sync : entity work.a2s port map(
    srst_b => '1' ,                     --! Synchronous  reset
    arst_b => reset_global_b ,          --! Asynchronous reset
    clk    => mclk_s,                   --! Synchronisation clock
    i      => '1' ,                     --! Asynchronous input
    o      => rst_sync_b                --! Synchronous  output (metafiltered)
    );

  -----------------------------------------------------------------------------
  -- Concurrent statements
  -----------------------------------------------------------------------------

  gclk   <= gclk_s;
  clk125 <= clk125_s;
  clk200 <= clk200_s;
  mrst_b <= rst_sync_b;
  lrst_b <= rst_sync_b;

  -----------------------------------------------------------------------------
  -- FSM
  -----------------------------------------------------------------------------

-- the start-up procedure has to happen in a few steps. First, the PLL must be reset. And
-- LOCK_OUT signal can not be trusted until 100 us after reset. Then the output of
-- the differential clk must be enabled, then a new reset must be issued to
-- reset the PLLs and DCMs in the read-out card. since this is daisy chained,
-- this must be repeated for every card in the chain.DCMs and PLLs on cards which are locked to
-- the master clock are not reset from every pulse. There is a local and
-- between LOCKED_bar and master reset.
-- The DCM can take up to 900 us to achieve lock, and the pll after the DCM
-- will use maximum 100 us to achieve lock. hence a total wait of 1 ms. 
  FSM_startup : process (fpga_100m_clk_s, fpga_cpu_reset)
  begin
    -- a total async reset
    if fpga_cpu_reset = '1' then
      enable_diff_out_b <= '1';
      reset_global_b    <= '0';
      wait_counter      <= 0;
      wait_counter2     <= 0;
      rst_counter       <= 0;
      state             <= INIT;

      -- the state machine is governed by the clock before the PLL, which means
      -- that it is in some sense async to the rest of the FPGA.
    elsif fpga_100m_clk_s'event and fpga_100m_clk_s = '1' then
      pll_reset      <= '0';
      reset_global_b <= '1';

      -- INIT state will only reset everything
      case state is
        when INIT =>
          enable_diff_out_b <= '1';
          wait_counter      <= 0;
          wait_counter2     <= 0;
          rst_counter       <= 0;
          state             <= RESET_PLL;
          -- Pull the pll_reset high, and go to a wait state. one clock
          -- cycle should suffice
        when RESET_PLL =>
          pll_reset <= '1';
          state     <= WAIT1;
          -- wait1, WAIT_PERIODS_1 is located i constants. We have to wait for the
          -- LOCKED_OUT signal to be stable (~100 us)
        when WAIT1 =>
          wait_counter <= wait_counter + 1;
          if wait_counter = WAIT_PERIODS_1 then
            wait_counter <= 0;
            state        <= WAIT_CLK_LOCK;
          else
            state <= WAIT1;
          end if;
          -- Wait for the PLL to lock
        when WAIT_CLK_LOCK =>
          if clk_lock = '1' then
            state <= EN_OUTPUT;
          else
            state <= WAIT_CLK_LOCK;
          end if;
          -- Send the clock out to the read-out cards      
        when EN_OUTPUT =>
          enable_diff_out_b <= '0';
          state             <= RESET_ROCS;
          -- Reset the read-out cards. 
        when RESET_ROCS =>
          reset_global_b <= '0';
          if rst_counter = (NUMBER_OF_ROCS+1) then
            rst_counter <= 0;
            state       <= DET_CLOCKLOSS;
          else
            state <= RST5;
          end if;
          -- Wait for 5 clock cycles
        when RST5 =>
          reset_global_b <= '0';
          wait_counter   <= wait_counter + 1;
          state          <= RST5;
          if wait_counter = 4 then
            state        <= WAIT2;
            wait_counter <= 0;
          end if;
          -- Pull reset low and wait 2X WAIT_PERIODS_2
        when WAIT2 =>
          state        <= WAIT2;
          wait_counter <= wait_counter + 1;
          if wait_counter = WAIT_PERIODS_2 then
            wait_counter  <= 0;
            wait_counter2 <= wait_counter2 + 1;
          end if;
          if wait_counter2 = 1 then
            wait_counter  <= 0;
            wait_counter2 <= 0;
            rst_counter   <= rst_counter + 1;
            state         <= RESET_ROCS;
          end if;
          -- Wait here until the llock_lock is lost again
        when DET_CLOCKLOSS =>
          state <= DET_CLOCKLOSS;
          if clk_lock = '0' then
            state <= INIT;
          end if;
        when others =>
          state <= INIT;
      end case;
    end if;
  end process FSM_startup;

end Behavioral;

