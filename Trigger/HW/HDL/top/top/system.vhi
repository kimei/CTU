
-- VHDL Instantiation Created from source file system.vhd -- 11:35:37 03/24/2011
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT system
	PORT(
		fpga_0_RS232_sin_pin : IN std_logic;
		fpga_0_DIP_Switches_8Bit_GPIO_in_pin : IN std_logic_vector(0 to 7);
		fpga_0_Push_Buttons_3Bit_GPIO_in_pin : IN std_logic_vector(0 to 2);
		fpga_0_Hard_Ethernet_MAC_GMII_RX_ER_0_pin : IN std_logic;
		fpga_0_Hard_Ethernet_MAC_GMII_RX_CLK_0_pin : IN std_logic;
		fpga_0_Hard_Ethernet_MAC_GMII_RX_DV_0_pin : IN std_logic;
		fpga_0_Hard_Ethernet_MAC_GMII_RXD_0_pin : IN std_logic_vector(7 downto 0);
		fpga_0_Hard_Ethernet_MAC_MII_TX_CLK_0_pin : IN std_logic;
		fpga_0_SysACE_CompactFlash_SysACE_CLK_pin : IN std_logic;
		fpga_0_SysACE_CompactFlash_SysACE_MPIRQ_pin : IN std_logic;
		sys_clk_pin : IN std_logic;
		sys_rst_pin : IN std_logic;    
		fpga_0_FLASH_8Mx16_Mem_DQ_pin : INOUT std_logic_vector(0 to 15);
		fpga_0_DDR2_SDRAM_16Mx32_DDR2_DQS : INOUT std_logic_vector(3 downto 0);
		fpga_0_DDR2_SDRAM_16Mx32_DDR2_DQS_N : INOUT std_logic_vector(3 downto 0);
		fpga_0_DDR2_SDRAM_16Mx32_DDR2_DQ : INOUT std_logic_vector(31 downto 0);
		fpga_0_Hard_Ethernet_MAC_MDIO_0_pin : INOUT std_logic;
		fpga_0_SysACE_CompactFlash_SysACE_MPD_pin : INOUT std_logic_vector(15 downto 0);      
		fpga_0_RS232_sout_pin : OUT std_logic;
		fpga_0_LEDs_8Bit_GPIO_d_out_pin : OUT std_logic_vector(0 to 7);
		fpga_0_FLASH_8Mx16_Mem_A_pin : OUT std_logic_vector(7 to 31);
		fpga_0_FLASH_8Mx16_Mem_WEN_pin : OUT std_logic;
		fpga_0_FLASH_8Mx16_Mem_OEN_pin : OUT std_logic_vector(0 to 0);
		fpga_0_FLASH_8Mx16_Mem_CEN_pin : OUT std_logic_vector(0 to 0);
		fpga_0_FLASH_8Mx16_rpn_dummy_pin : OUT std_logic;
		fpga_0_FLASH_8Mx16_byte_dummy_pin : OUT std_logic;
		fpga_0_FLASH_8Mx16_adv_dummy_pin : OUT std_logic;
		fpga_0_FLASH_8Mx16_clk_dummy_pin : OUT std_logic;
		fpga_0_FLASH_8Mx16_wait_dummy_pin : OUT std_logic;
		fpga_0_DDR2_SDRAM_16Mx32_DDR2_ODT_pin : OUT std_logic_vector(0 to 0);
		fpga_0_DDR2_SDRAM_16Mx32_DDR2_A_pin : OUT std_logic_vector(12 downto 0);
		fpga_0_DDR2_SDRAM_16Mx32_DDR2_BA_pin : OUT std_logic_vector(1 downto 0);
		fpga_0_DDR2_SDRAM_16Mx32_DDR2_CAS_N_pin : OUT std_logic;
		fpga_0_DDR2_SDRAM_16Mx32_DDR2_CKE_pin : OUT std_logic;
		fpga_0_DDR2_SDRAM_16Mx32_DDR2_CS_N_pin : OUT std_logic;
		fpga_0_DDR2_SDRAM_16Mx32_DDR2_RAS_N_pin : OUT std_logic;
		fpga_0_DDR2_SDRAM_16Mx32_DDR2_WE_N_pin : OUT std_logic;
		fpga_0_DDR2_SDRAM_16Mx32_DDR2_DM_pin : OUT std_logic_vector(3 downto 0);
		fpga_0_DDR2_SDRAM_16Mx32_DDR2_CK_pin : OUT std_logic_vector(1 downto 0);
		fpga_0_DDR2_SDRAM_16Mx32_DDR2_CK_N_pin : OUT std_logic_vector(1 downto 0);
		fpga_0_Hard_Ethernet_MAC_TemacPhy_RST_n_pin : OUT std_logic;
		fpga_0_Hard_Ethernet_MAC_GMII_TXD_0_pin : OUT std_logic_vector(7 downto 0);
		fpga_0_Hard_Ethernet_MAC_GMII_TX_EN_0_pin : OUT std_logic;
		fpga_0_Hard_Ethernet_MAC_GMII_TX_CLK_0_pin : OUT std_logic;
		fpga_0_Hard_Ethernet_MAC_GMII_TX_ER_0_pin : OUT std_logic;
		fpga_0_Hard_Ethernet_MAC_MDC_0_pin : OUT std_logic;
		fpga_0_Hard_Ethernet_MAC_PHY_MII_INT_pin : OUT std_logic;
		fpga_0_SysACE_CompactFlash_SysACE_MPA_pin : OUT std_logic_vector(6 downto 0);
		fpga_0_SysACE_CompactFlash_SysACE_CEN_pin : OUT std_logic;
		fpga_0_SysACE_CompactFlash_SysACE_OEN_pin : OUT std_logic;
		fpga_0_SysACE_CompactFlash_SysACE_WEN_pin : OUT std_logic
		);
	END COMPONENT;

	Inst_system: system PORT MAP(
		fpga_0_RS232_sin_pin => ,
		fpga_0_RS232_sout_pin => ,
		fpga_0_LEDs_8Bit_GPIO_d_out_pin => ,
		fpga_0_DIP_Switches_8Bit_GPIO_in_pin => ,
		fpga_0_Push_Buttons_3Bit_GPIO_in_pin => ,
		fpga_0_FLASH_8Mx16_Mem_DQ_pin => ,
		fpga_0_FLASH_8Mx16_Mem_A_pin => ,
		fpga_0_FLASH_8Mx16_Mem_WEN_pin => ,
		fpga_0_FLASH_8Mx16_Mem_OEN_pin => ,
		fpga_0_FLASH_8Mx16_Mem_CEN_pin => ,
		fpga_0_FLASH_8Mx16_rpn_dummy_pin => ,
		fpga_0_FLASH_8Mx16_byte_dummy_pin => ,
		fpga_0_FLASH_8Mx16_adv_dummy_pin => ,
		fpga_0_FLASH_8Mx16_clk_dummy_pin => ,
		fpga_0_FLASH_8Mx16_wait_dummy_pin => ,
		fpga_0_DDR2_SDRAM_16Mx32_DDR2_ODT_pin => ,
		fpga_0_DDR2_SDRAM_16Mx32_DDR2_A_pin => ,
		fpga_0_DDR2_SDRAM_16Mx32_DDR2_BA_pin => ,
		fpga_0_DDR2_SDRAM_16Mx32_DDR2_CAS_N_pin => ,
		fpga_0_DDR2_SDRAM_16Mx32_DDR2_CKE_pin => ,
		fpga_0_DDR2_SDRAM_16Mx32_DDR2_CS_N_pin => ,
		fpga_0_DDR2_SDRAM_16Mx32_DDR2_RAS_N_pin => ,
		fpga_0_DDR2_SDRAM_16Mx32_DDR2_WE_N_pin => ,
		fpga_0_DDR2_SDRAM_16Mx32_DDR2_DM_pin => ,
		fpga_0_DDR2_SDRAM_16Mx32_DDR2_DQS => ,
		fpga_0_DDR2_SDRAM_16Mx32_DDR2_DQS_N => ,
		fpga_0_DDR2_SDRAM_16Mx32_DDR2_DQ => ,
		fpga_0_DDR2_SDRAM_16Mx32_DDR2_CK_pin => ,
		fpga_0_DDR2_SDRAM_16Mx32_DDR2_CK_N_pin => ,
		fpga_0_Hard_Ethernet_MAC_TemacPhy_RST_n_pin => ,
		fpga_0_Hard_Ethernet_MAC_GMII_TXD_0_pin => ,
		fpga_0_Hard_Ethernet_MAC_GMII_TX_EN_0_pin => ,
		fpga_0_Hard_Ethernet_MAC_GMII_TX_CLK_0_pin => ,
		fpga_0_Hard_Ethernet_MAC_GMII_TX_ER_0_pin => ,
		fpga_0_Hard_Ethernet_MAC_GMII_RX_ER_0_pin => ,
		fpga_0_Hard_Ethernet_MAC_GMII_RX_CLK_0_pin => ,
		fpga_0_Hard_Ethernet_MAC_GMII_RX_DV_0_pin => ,
		fpga_0_Hard_Ethernet_MAC_GMII_RXD_0_pin => ,
		fpga_0_Hard_Ethernet_MAC_MII_TX_CLK_0_pin => ,
		fpga_0_Hard_Ethernet_MAC_MDC_0_pin => ,
		fpga_0_Hard_Ethernet_MAC_MDIO_0_pin => ,
		fpga_0_Hard_Ethernet_MAC_PHY_MII_INT_pin => ,
		fpga_0_SysACE_CompactFlash_SysACE_CLK_pin => ,
		fpga_0_SysACE_CompactFlash_SysACE_MPA_pin => ,
		fpga_0_SysACE_CompactFlash_SysACE_MPD_pin => ,
		fpga_0_SysACE_CompactFlash_SysACE_CEN_pin => ,
		fpga_0_SysACE_CompactFlash_SysACE_OEN_pin => ,
		fpga_0_SysACE_CompactFlash_SysACE_WEN_pin => ,
		fpga_0_SysACE_CompactFlash_SysACE_MPIRQ_pin => ,
		sys_clk_pin => ,
		sys_rst_pin => 
	);


