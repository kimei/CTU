--! \file
--! \brief The Clock Reset Unit


--! Standard library
library ieee;
use ieee.std_logic_1164.all;  --! Standard logic

--! Xilinx Unisim library
library unisim;
use unisim.vcomponents.all;   --! For simulation

--! Work library (self-composed)
library work;
use work.constants.all;       --! Global constants
use work.types.all;           --! Global types
-- use work.components.all;      --! Global component declarations


--! \brief Entity
entity cru is
  port(
    fpga_100m_clk     : in  std_logic; --! 100Mhz single-ended board clock
--     fpga_33m_clk      : in  std_logic; -- 33MHz  single-ended, same as Xilinx System ACE utilises
--     fpga_27m_clk      : in  std_logic; -- 27MHz  single-ended, same as USB controller utilises 
--     fpga_200m_clk     : in  std_logic; -- 200MHz differential clock

    fpga_cpu_reset_b  : in  std_logic; --! Active low system reset (only connected to the IO pad)

    up_clk            : out std_logic; --! 100MHz Microblaze clock
    fe_clk            : out std_logic; --! Front-end clock
    mclk              : out std_logic; --! 50 MHz master (global) clock

    up_rst_b          : out std_logic; --! Microblaze reset (synchronous assert/deassert)
    fe_rst_b          : out std_logic; --! Front-end reset (async. assert, sync. deassert)
    mrst_b            : out std_logic; --! Master (global) reset (async. assert, sync. deassert)

    cs_vio            : cs_vio_type    --! ChipScope input/output
  );
end entity;


---------------------------------------------------------------------------------------------------
--! \brief Architecture
architecture rtl of cru is
---------------------------------------------------------------------------------------------------

signal fpga_cpu_reset : std_logic;
signal clk_stable     : std_logic;

signal mclk_i         : std_logic;
signal fe_clk_i       : std_logic;
signal up_clk_i       : std_logic;

signal mrst_b_i       : std_logic;
signal fe_rst_b_i     : std_logic;
signal up_rst_b_i     : std_logic;

begin

-- The embedded project contains its own DCM, letting this handle the clock.


--! Use a PLL to create internal clocks based on the same 100MHz board clock source.
--! This should ease adaption to dynamic switch of source clock..
fpga_cpu_reset <= not fpga_cpu_reset_b;
clk_gen_pll: entity work.pll_all port map(
  CLKIN1_IN   => fpga_100m_clk    , --! 100MHz board clock
  RST_IN      => fpga_cpu_reset   , --! Board reset
  CLKOUT0_OUT => up_clk_i         , --! Microblaze clock (100 MHz)
  CLKOUT1_OUT => fe_clk_i         , --! Front-end clock
  CLKOUT2_OUT => mclk_i           , --! Master clock (50 MHz)
  LOCKED_OUT  => clk_stable         --! Indicates whether the PLL has a clock lock
);

up_clk <= up_clk_i;
fe_clk <= fe_clk_i;
mclk   <= mclk_i;

--! For the Microblaze, use synchronous assertion and deassertion of reset
--! \todo Add soft resets etc. when available
--! \todo Fix the async hack when reset mux is done
up_rst_sync: entity work.a2s port map(
  srst_b  => '1'              , --! Synchronous  reset
  arst_b  => fpga_cpu_reset_b , --! Asynchronous reset
  clk     => up_clk_i         , --! Synchronisation clock
  i       => '1'              , --! Asynchronous input
  o       => up_rst_b_i         --! Synchronous  output (metafiltered)
);
up_rst_b <= up_rst_b_i;


fe_rst_sync: entity work.a2s port map(
  srst_b  => '1'              , --! Synchronous  reset
  arst_b  => fpga_cpu_reset_b , --! Asynchronous reset
  clk     => fe_clk_i         , --! Synchronisation clock
  i       => '1'              , --! Asynchronous input
  o       => fe_rst_b_i         --! Synchronous  output (metafiltered)
);
fe_rst_b <= fe_rst_b_i and cs_vio.fe_soft_rst_b; --! Ok since the soft reset is synchronous


mrst_sync: entity work.a2s port map(
  srst_b  => '1'              , --! Synchronous  reset
  arst_b  => fpga_cpu_reset_b , --! Asynchronous reset
  clk     => mclk_i           , --! Synchronisation clock
  i       => '1'              , --! Asynchronous input
  o       => mrst_b_i           --! Synchronous  output (metafiltered)
);
mrst_b <= mrst_b_i;


end architecture;
