--! \file
--! \brief Component deptclarations.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.constants.all;                 --! Global constants


package components is
-- PLL from Xilinx ip
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


  component edge_detector
    port (
      rst_b : in  std_logic;
      mclk  : in  std_logic;
      inp   : in  std_logic;
      outp  : out std_logic);
  end component;

  component CRU
    port(
      fpga_100m_clk  : in  std_logic;
      fpga_cpu_reset : in  std_logic;
      mclk           : out std_logic;
      mclk_b         : out std_logic;
      gclk           : out std_logic;
      mrst_b         : out std_logic;
      clk125         : out std_logic;
      clk200         : out std_logic;
      lrst_b         : out std_logic
      );
  end component;

  -- a2s from Jo-Inge
  component a2s
    generic(
      depth : positive := 2);           --! FIFO depth
    port(
      arst_b : in  std_logic;           --! Asynchronous reset      
      srst_b : in  std_logic;           --! Synchronous reset
      clk    : in  std_logic;           --! Synchronisation clock
      i      : in  std_logic;           --! Input
      o      : out std_logic);          --! Output
  end component;

  component sync_trigger
    port (
      rst_b       : in  std_logic;
      mclk        : in  std_logic;
      trigger_in  : in  std_logic_vector(NUMBER_OF_ROCS-1 downto 0);
      trigger_out : out std_logic_vector(NUMBER_OF_ROCS-1 downto 0));
  end component;

  component uart
    generic (
      CLK_FREQ : integer;
      SER_FREQ : integer);
    port (
      clk      : in  std_logic;
      rst      : in  std_logic;
      rx       : in  std_logic;
      tx       : out std_logic;
      par_en   : in  std_logic;
      tx_req   : in  std_logic;
      tx_end   : out std_logic;
      tx_data  : in  std_logic_vector(7 downto 0);
      rx_ready : out std_logic;
      rx_data  : out std_logic_vector(7 downto 0));
  end component;

  component com
    port (
      mclk  : in  std_logic;
      rst_b : in  std_logic;
      rx    : in  std_logic;
      tx    : out std_logic);
  end component;

  component st_fsm
    generic (
      NO_OF_MODULES : positive);
    port (
      leading_edge_b : in  std_logic_vector(NO_OF_MODULES-1 downto 0);
      mclk           : in  std_logic;
      rst_b          : in  std_logic;
      trigger_out    : out std_logic_vector(NO_OF_MODULES-1 downto 0));
  end component;

  -- OBUFDS is a single output buffer that supports low-voltage, differential
  --signaling (1.8v CMOS). OBUFDS isolates the internal circuit and provides
  --drive current for signals leaving the chip. Its output is represented as
  --two distinct ports (O and OB), one deemed the "master" and the other the
  --"slave." The master and the slave are opposite phases of the same logical
  -- signal (for example, MYNET and MYNETB).
  component OBUFDS
    port (O  : out std_ulogic;
          OB : out std_ulogic;
          I  : in  std_ulogic);
  end component;

  component IBUFDS
    port (I  : in  std_ulogic;
          IB : in  std_ulogic;
          O  : out std_ulogic);
  end component;

  

  -- PPC core
  component system
    port(
      fpga_0_RS232_sin_pin                        : in    std_logic;
      fpga_0_DIP_Switches_8Bit_GPIO_in_pin        : in    std_logic_vector(0 to 7);
      fpga_0_Push_Buttons_3Bit_GPIO_in_pin        : in    std_logic_vector(0 to 2);
      fpga_0_Hard_Ethernet_MAC_GMII_RX_ER_0_pin   : in    std_logic;
      fpga_0_Hard_Ethernet_MAC_GMII_RX_CLK_0_pin  : in    std_logic;
      fpga_0_Hard_Ethernet_MAC_GMII_RX_DV_0_pin   : in    std_logic;
      fpga_0_Hard_Ethernet_MAC_GMII_RXD_0_pin     : in    std_logic_vector(7 downto 0);
      fpga_0_Hard_Ethernet_MAC_MII_TX_CLK_0_pin   : in    std_logic;
      sys_clk_pin                                 : in    std_logic;
      sys_rst_pin                                 : in    std_logic;
      fpga_0_FLASH_8Mx16_Mem_DQ_pin               : inout std_logic_vector(0 to 15);
      fpga_0_DDR2_SDRAM_16Mx32_DDR2_DQS           : inout std_logic_vector(3 downto 0);
      fpga_0_DDR2_SDRAM_16Mx32_DDR2_DQS_N         : inout std_logic_vector(3 downto 0);
      fpga_0_DDR2_SDRAM_16Mx32_DDR2_DQ            : inout std_logic_vector(31 downto 0);
      fpga_0_Hard_Ethernet_MAC_MDIO_0_pin         : inout std_logic;
      fpga_0_RS232_sout_pin                       : out   std_logic;
      fpga_0_LEDs_8Bit_GPIO_d_out_pin             : out   std_logic_vector(0 to 7);
      fpga_0_FLASH_8Mx16_Mem_A_pin                : out   std_logic_vector(7 to 31);
      fpga_0_FLASH_8Mx16_Mem_WEN_pin              : out   std_logic;
      fpga_0_FLASH_8Mx16_Mem_OEN_pin              : out   std_logic_vector(0 to 0);
      fpga_0_FLASH_8Mx16_Mem_CEN_pin              : out   std_logic_vector(0 to 0);
      fpga_0_FLASH_8Mx16_rpn_dummy_pin            : out   std_logic;
      fpga_0_FLASH_8Mx16_byte_dummy_pin           : out   std_logic;
      fpga_0_FLASH_8Mx16_adv_dummy_pin            : out   std_logic;
      fpga_0_FLASH_8Mx16_clk_dummy_pin            : out   std_logic;
      fpga_0_FLASH_8Mx16_wait_dummy_pin           : out   std_logic;
      fpga_0_DDR2_SDRAM_16Mx32_DDR2_ODT_pin       : out   std_logic_vector(0 to 0);
      fpga_0_DDR2_SDRAM_16Mx32_DDR2_A_pin         : out   std_logic_vector(12 downto 0);
      fpga_0_DDR2_SDRAM_16Mx32_DDR2_BA_pin        : out   std_logic_vector(1 downto 0);
      fpga_0_DDR2_SDRAM_16Mx32_DDR2_CAS_N_pin     : out   std_logic;
      fpga_0_DDR2_SDRAM_16Mx32_DDR2_CKE_pin       : out   std_logic;
      fpga_0_DDR2_SDRAM_16Mx32_DDR2_CS_N_pin      : out   std_logic;
      fpga_0_DDR2_SDRAM_16Mx32_DDR2_RAS_N_pin     : out   std_logic;
      fpga_0_DDR2_SDRAM_16Mx32_DDR2_WE_N_pin      : out   std_logic;
      fpga_0_DDR2_SDRAM_16Mx32_DDR2_DM_pin        : out   std_logic_vector(3 downto 0);
      fpga_0_DDR2_SDRAM_16Mx32_DDR2_CK_pin        : out   std_logic_vector(1 downto 0);
      fpga_0_DDR2_SDRAM_16Mx32_DDR2_CK_N_pin      : out   std_logic_vector(1 downto 0);
      fpga_0_Hard_Ethernet_MAC_TemacPhy_RST_n_pin : out   std_logic;
      fpga_0_Hard_Ethernet_MAC_GMII_TXD_0_pin     : out   std_logic_vector(7 downto 0);
      fpga_0_Hard_Ethernet_MAC_GMII_TX_EN_0_pin   : out   std_logic;
      fpga_0_Hard_Ethernet_MAC_GMII_TX_CLK_0_pin  : out   std_logic;
      fpga_0_Hard_Ethernet_MAC_GMII_TX_ER_0_pin   : out   std_logic;
      fpga_0_Hard_Ethernet_MAC_MDC_0_pin          : out   std_logic;
      fpga_0_Hard_Ethernet_MAC_PHY_MII_INT_pin    : out   std_logic
      );
  end component;

  component rate_counter
    port (
      clk         : in  std_logic;
      rst_b       : in  std_logic;
      rate_cards  : in  std_logic_vector(NUMBER_OF_ROCS-1 downto 0);
      coincidence : in  std_logic_vector(NUMBER_OF_ROCS-1 downto 0);
      we          : out std_logic;
      we_others   : in  std_logic;
      fifo_empty  : in  std_logic;
      din         : out std_logic_vector(7 downto 0));
  end component;
  
  component fifo_generator_v4_4
	port (
	clk: IN std_logic;
	din: IN std_logic_VECTOR(7 downto 0);
	rd_en: IN std_logic;
	rst: IN std_logic;
	wr_en: IN std_logic;
	data_count: OUT std_logic_VECTOR(8 downto 0);
	dout: OUT std_logic_VECTOR(7 downto 0);
	empty: OUT std_logic;
	full: OUT std_logic);
end component;
  
end package components;
