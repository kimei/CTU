-------------------------------------------------------------------------------
-- system_stub.vhd
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

entity system_stub is
  port (
    fpga_0_RS232_sin_pin : in std_logic;
    fpga_0_RS232_sout_pin : out std_logic;
    fpga_0_LEDs_8Bit_GPIO_d_out_pin : out std_logic_vector(0 to 7);
    fpga_0_DIP_Switches_8Bit_GPIO_in_pin : in std_logic_vector(0 to 7);
    fpga_0_Push_Buttons_3Bit_GPIO_in_pin : in std_logic_vector(0 to 2);
    fpga_0_FLASH_8Mx16_Mem_DQ_pin : inout std_logic_vector(0 to 15);
    fpga_0_FLASH_8Mx16_Mem_A_pin : out std_logic_vector(7 to 31);
    fpga_0_FLASH_8Mx16_Mem_WEN_pin : out std_logic;
    fpga_0_FLASH_8Mx16_Mem_OEN_pin : out std_logic_vector(0 to 0);
    fpga_0_FLASH_8Mx16_Mem_CEN_pin : out std_logic_vector(0 to 0);
    fpga_0_FLASH_8Mx16_rpn_dummy_pin : out std_logic;
    fpga_0_FLASH_8Mx16_byte_dummy_pin : out std_logic;
    fpga_0_FLASH_8Mx16_adv_dummy_pin : out std_logic;
    fpga_0_FLASH_8Mx16_clk_dummy_pin : out std_logic;
    fpga_0_FLASH_8Mx16_wait_dummy_pin : out std_logic;
    fpga_0_DDR2_SDRAM_16Mx32_DDR2_ODT_pin : out std_logic_vector(0 to 0);
    fpga_0_DDR2_SDRAM_16Mx32_DDR2_A_pin : out std_logic_vector(12 downto 0);
    fpga_0_DDR2_SDRAM_16Mx32_DDR2_BA_pin : out std_logic_vector(1 downto 0);
    fpga_0_DDR2_SDRAM_16Mx32_DDR2_CAS_N_pin : out std_logic;
    fpga_0_DDR2_SDRAM_16Mx32_DDR2_CKE_pin : out std_logic;
    fpga_0_DDR2_SDRAM_16Mx32_DDR2_CS_N_pin : out std_logic;
    fpga_0_DDR2_SDRAM_16Mx32_DDR2_RAS_N_pin : out std_logic;
    fpga_0_DDR2_SDRAM_16Mx32_DDR2_WE_N_pin : out std_logic;
    fpga_0_DDR2_SDRAM_16Mx32_DDR2_DM_pin : out std_logic_vector(3 downto 0);
    fpga_0_DDR2_SDRAM_16Mx32_DDR2_DQS : inout std_logic_vector(3 downto 0);
    fpga_0_DDR2_SDRAM_16Mx32_DDR2_DQS_N : inout std_logic_vector(3 downto 0);
    fpga_0_DDR2_SDRAM_16Mx32_DDR2_DQ : inout std_logic_vector(31 downto 0);
    fpga_0_DDR2_SDRAM_16Mx32_DDR2_CK_pin : out std_logic_vector(1 downto 0);
    fpga_0_DDR2_SDRAM_16Mx32_DDR2_CK_N_pin : out std_logic_vector(1 downto 0);
    fpga_0_Hard_Ethernet_MAC_TemacPhy_RST_n_pin : out std_logic;
    fpga_0_Hard_Ethernet_MAC_GMII_TXD_0_pin : out std_logic_vector(7 downto 0);
    fpga_0_Hard_Ethernet_MAC_GMII_TX_EN_0_pin : out std_logic;
    fpga_0_Hard_Ethernet_MAC_GMII_TX_CLK_0_pin : out std_logic;
    fpga_0_Hard_Ethernet_MAC_GMII_TX_ER_0_pin : out std_logic;
    fpga_0_Hard_Ethernet_MAC_GMII_RX_ER_0_pin : in std_logic;
    fpga_0_Hard_Ethernet_MAC_GMII_RX_CLK_0_pin : in std_logic;
    fpga_0_Hard_Ethernet_MAC_GMII_RX_DV_0_pin : in std_logic;
    fpga_0_Hard_Ethernet_MAC_GMII_RXD_0_pin : in std_logic_vector(7 downto 0);
    fpga_0_Hard_Ethernet_MAC_MII_TX_CLK_0_pin : in std_logic;
    fpga_0_Hard_Ethernet_MAC_MDC_0_pin : out std_logic;
    fpga_0_Hard_Ethernet_MAC_MDIO_0_pin : inout std_logic;
    fpga_0_Hard_Ethernet_MAC_PHY_MII_INT_pin : out std_logic;
    sys_clk_pin : in std_logic;
    sys_rst_pin : in std_logic
  );
end system_stub;

architecture STRUCTURE of system_stub is

  component system is
    port (
      fpga_0_RS232_sin_pin : in std_logic;
      fpga_0_RS232_sout_pin : out std_logic;
      fpga_0_LEDs_8Bit_GPIO_d_out_pin : out std_logic_vector(0 to 7);
      fpga_0_DIP_Switches_8Bit_GPIO_in_pin : in std_logic_vector(0 to 7);
      fpga_0_Push_Buttons_3Bit_GPIO_in_pin : in std_logic_vector(0 to 2);
      fpga_0_FLASH_8Mx16_Mem_DQ_pin : inout std_logic_vector(0 to 15);
      fpga_0_FLASH_8Mx16_Mem_A_pin : out std_logic_vector(7 to 31);
      fpga_0_FLASH_8Mx16_Mem_WEN_pin : out std_logic;
      fpga_0_FLASH_8Mx16_Mem_OEN_pin : out std_logic_vector(0 to 0);
      fpga_0_FLASH_8Mx16_Mem_CEN_pin : out std_logic_vector(0 to 0);
      fpga_0_FLASH_8Mx16_rpn_dummy_pin : out std_logic;
      fpga_0_FLASH_8Mx16_byte_dummy_pin : out std_logic;
      fpga_0_FLASH_8Mx16_adv_dummy_pin : out std_logic;
      fpga_0_FLASH_8Mx16_clk_dummy_pin : out std_logic;
      fpga_0_FLASH_8Mx16_wait_dummy_pin : out std_logic;
      fpga_0_DDR2_SDRAM_16Mx32_DDR2_ODT_pin : out std_logic_vector(0 to 0);
      fpga_0_DDR2_SDRAM_16Mx32_DDR2_A_pin : out std_logic_vector(12 downto 0);
      fpga_0_DDR2_SDRAM_16Mx32_DDR2_BA_pin : out std_logic_vector(1 downto 0);
      fpga_0_DDR2_SDRAM_16Mx32_DDR2_CAS_N_pin : out std_logic;
      fpga_0_DDR2_SDRAM_16Mx32_DDR2_CKE_pin : out std_logic;
      fpga_0_DDR2_SDRAM_16Mx32_DDR2_CS_N_pin : out std_logic;
      fpga_0_DDR2_SDRAM_16Mx32_DDR2_RAS_N_pin : out std_logic;
      fpga_0_DDR2_SDRAM_16Mx32_DDR2_WE_N_pin : out std_logic;
      fpga_0_DDR2_SDRAM_16Mx32_DDR2_DM_pin : out std_logic_vector(3 downto 0);
      fpga_0_DDR2_SDRAM_16Mx32_DDR2_DQS : inout std_logic_vector(3 downto 0);
      fpga_0_DDR2_SDRAM_16Mx32_DDR2_DQS_N : inout std_logic_vector(3 downto 0);
      fpga_0_DDR2_SDRAM_16Mx32_DDR2_DQ : inout std_logic_vector(31 downto 0);
      fpga_0_DDR2_SDRAM_16Mx32_DDR2_CK_pin : out std_logic_vector(1 downto 0);
      fpga_0_DDR2_SDRAM_16Mx32_DDR2_CK_N_pin : out std_logic_vector(1 downto 0);
      fpga_0_Hard_Ethernet_MAC_TemacPhy_RST_n_pin : out std_logic;
      fpga_0_Hard_Ethernet_MAC_GMII_TXD_0_pin : out std_logic_vector(7 downto 0);
      fpga_0_Hard_Ethernet_MAC_GMII_TX_EN_0_pin : out std_logic;
      fpga_0_Hard_Ethernet_MAC_GMII_TX_CLK_0_pin : out std_logic;
      fpga_0_Hard_Ethernet_MAC_GMII_TX_ER_0_pin : out std_logic;
      fpga_0_Hard_Ethernet_MAC_GMII_RX_ER_0_pin : in std_logic;
      fpga_0_Hard_Ethernet_MAC_GMII_RX_CLK_0_pin : in std_logic;
      fpga_0_Hard_Ethernet_MAC_GMII_RX_DV_0_pin : in std_logic;
      fpga_0_Hard_Ethernet_MAC_GMII_RXD_0_pin : in std_logic_vector(7 downto 0);
      fpga_0_Hard_Ethernet_MAC_MII_TX_CLK_0_pin : in std_logic;
      fpga_0_Hard_Ethernet_MAC_MDC_0_pin : out std_logic;
      fpga_0_Hard_Ethernet_MAC_MDIO_0_pin : inout std_logic;
      fpga_0_Hard_Ethernet_MAC_PHY_MII_INT_pin : out std_logic;
      sys_clk_pin : in std_logic;
      sys_rst_pin : in std_logic
    );
  end component;

begin

  system_i : system
    port map (
      fpga_0_RS232_sin_pin => fpga_0_RS232_sin_pin,
      fpga_0_RS232_sout_pin => fpga_0_RS232_sout_pin,
      fpga_0_LEDs_8Bit_GPIO_d_out_pin => fpga_0_LEDs_8Bit_GPIO_d_out_pin,
      fpga_0_DIP_Switches_8Bit_GPIO_in_pin => fpga_0_DIP_Switches_8Bit_GPIO_in_pin,
      fpga_0_Push_Buttons_3Bit_GPIO_in_pin => fpga_0_Push_Buttons_3Bit_GPIO_in_pin,
      fpga_0_FLASH_8Mx16_Mem_DQ_pin => fpga_0_FLASH_8Mx16_Mem_DQ_pin,
      fpga_0_FLASH_8Mx16_Mem_A_pin => fpga_0_FLASH_8Mx16_Mem_A_pin,
      fpga_0_FLASH_8Mx16_Mem_WEN_pin => fpga_0_FLASH_8Mx16_Mem_WEN_pin,
      fpga_0_FLASH_8Mx16_Mem_OEN_pin => fpga_0_FLASH_8Mx16_Mem_OEN_pin(0 to 0),
      fpga_0_FLASH_8Mx16_Mem_CEN_pin => fpga_0_FLASH_8Mx16_Mem_CEN_pin(0 to 0),
      fpga_0_FLASH_8Mx16_rpn_dummy_pin => fpga_0_FLASH_8Mx16_rpn_dummy_pin,
      fpga_0_FLASH_8Mx16_byte_dummy_pin => fpga_0_FLASH_8Mx16_byte_dummy_pin,
      fpga_0_FLASH_8Mx16_adv_dummy_pin => fpga_0_FLASH_8Mx16_adv_dummy_pin,
      fpga_0_FLASH_8Mx16_clk_dummy_pin => fpga_0_FLASH_8Mx16_clk_dummy_pin,
      fpga_0_FLASH_8Mx16_wait_dummy_pin => fpga_0_FLASH_8Mx16_wait_dummy_pin,
      fpga_0_DDR2_SDRAM_16Mx32_DDR2_ODT_pin => fpga_0_DDR2_SDRAM_16Mx32_DDR2_ODT_pin(0 to 0),
      fpga_0_DDR2_SDRAM_16Mx32_DDR2_A_pin => fpga_0_DDR2_SDRAM_16Mx32_DDR2_A_pin,
      fpga_0_DDR2_SDRAM_16Mx32_DDR2_BA_pin => fpga_0_DDR2_SDRAM_16Mx32_DDR2_BA_pin,
      fpga_0_DDR2_SDRAM_16Mx32_DDR2_CAS_N_pin => fpga_0_DDR2_SDRAM_16Mx32_DDR2_CAS_N_pin,
      fpga_0_DDR2_SDRAM_16Mx32_DDR2_CKE_pin => fpga_0_DDR2_SDRAM_16Mx32_DDR2_CKE_pin,
      fpga_0_DDR2_SDRAM_16Mx32_DDR2_CS_N_pin => fpga_0_DDR2_SDRAM_16Mx32_DDR2_CS_N_pin,
      fpga_0_DDR2_SDRAM_16Mx32_DDR2_RAS_N_pin => fpga_0_DDR2_SDRAM_16Mx32_DDR2_RAS_N_pin,
      fpga_0_DDR2_SDRAM_16Mx32_DDR2_WE_N_pin => fpga_0_DDR2_SDRAM_16Mx32_DDR2_WE_N_pin,
      fpga_0_DDR2_SDRAM_16Mx32_DDR2_DM_pin => fpga_0_DDR2_SDRAM_16Mx32_DDR2_DM_pin,
      fpga_0_DDR2_SDRAM_16Mx32_DDR2_DQS => fpga_0_DDR2_SDRAM_16Mx32_DDR2_DQS,
      fpga_0_DDR2_SDRAM_16Mx32_DDR2_DQS_N => fpga_0_DDR2_SDRAM_16Mx32_DDR2_DQS_N,
      fpga_0_DDR2_SDRAM_16Mx32_DDR2_DQ => fpga_0_DDR2_SDRAM_16Mx32_DDR2_DQ,
      fpga_0_DDR2_SDRAM_16Mx32_DDR2_CK_pin => fpga_0_DDR2_SDRAM_16Mx32_DDR2_CK_pin,
      fpga_0_DDR2_SDRAM_16Mx32_DDR2_CK_N_pin => fpga_0_DDR2_SDRAM_16Mx32_DDR2_CK_N_pin,
      fpga_0_Hard_Ethernet_MAC_TemacPhy_RST_n_pin => fpga_0_Hard_Ethernet_MAC_TemacPhy_RST_n_pin,
      fpga_0_Hard_Ethernet_MAC_GMII_TXD_0_pin => fpga_0_Hard_Ethernet_MAC_GMII_TXD_0_pin,
      fpga_0_Hard_Ethernet_MAC_GMII_TX_EN_0_pin => fpga_0_Hard_Ethernet_MAC_GMII_TX_EN_0_pin,
      fpga_0_Hard_Ethernet_MAC_GMII_TX_CLK_0_pin => fpga_0_Hard_Ethernet_MAC_GMII_TX_CLK_0_pin,
      fpga_0_Hard_Ethernet_MAC_GMII_TX_ER_0_pin => fpga_0_Hard_Ethernet_MAC_GMII_TX_ER_0_pin,
      fpga_0_Hard_Ethernet_MAC_GMII_RX_ER_0_pin => fpga_0_Hard_Ethernet_MAC_GMII_RX_ER_0_pin,
      fpga_0_Hard_Ethernet_MAC_GMII_RX_CLK_0_pin => fpga_0_Hard_Ethernet_MAC_GMII_RX_CLK_0_pin,
      fpga_0_Hard_Ethernet_MAC_GMII_RX_DV_0_pin => fpga_0_Hard_Ethernet_MAC_GMII_RX_DV_0_pin,
      fpga_0_Hard_Ethernet_MAC_GMII_RXD_0_pin => fpga_0_Hard_Ethernet_MAC_GMII_RXD_0_pin,
      fpga_0_Hard_Ethernet_MAC_MII_TX_CLK_0_pin => fpga_0_Hard_Ethernet_MAC_MII_TX_CLK_0_pin,
      fpga_0_Hard_Ethernet_MAC_MDC_0_pin => fpga_0_Hard_Ethernet_MAC_MDC_0_pin,
      fpga_0_Hard_Ethernet_MAC_MDIO_0_pin => fpga_0_Hard_Ethernet_MAC_MDIO_0_pin,
      fpga_0_Hard_Ethernet_MAC_PHY_MII_INT_pin => fpga_0_Hard_Ethernet_MAC_PHY_MII_INT_pin,
      sys_clk_pin => sys_clk_pin,
      sys_rst_pin => sys_rst_pin
    );

end architecture STRUCTURE;

