
-- VHDL Instantiation Created from source file v5_emac_v1_5_block.vhd -- 14:14:52 04/14/2011
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

------------- Begin Cut here for COMPONENT Declaration ------ COMP_TAG
	COMPONENT v5_emac_v1_5_block
	PORT(
		TX_CLIENT_CLK_0 : IN std_logic;
		RX_CLIENT_CLK_0 : IN std_logic;
		TX_PHY_CLK_0 : IN std_logic;
		CLIENTEMAC0TXD : IN std_logic_vector(7 downto 0);
		CLIENTEMAC0TXDVLD : IN std_logic;
		CLIENTEMAC0TXFIRSTBYTE : IN std_logic;
		CLIENTEMAC0TXUNDERRUN : IN std_logic;
		CLIENTEMAC0TXIFGDELAY : IN std_logic_vector(7 downto 0);
		CLIENTEMAC0PAUSEREQ : IN std_logic;
		CLIENTEMAC0PAUSEVAL : IN std_logic_vector(15 downto 0);
		GTX_CLK_0 : IN std_logic;
		GMII_RXD_0 : IN std_logic_vector(7 downto 0);
		GMII_RX_DV_0 : IN std_logic;
		GMII_RX_ER_0 : IN std_logic;
		GMII_RX_CLK_0 : IN std_logic;
		MII_TX_CLK_0 : IN std_logic;
		GMII_COL_0 : IN std_logic;
		GMII_CRS_0 : IN std_logic;
		RESET : IN std_logic;          
		TX_CLIENT_CLK_OUT_0 : OUT std_logic;
		RX_CLIENT_CLK_OUT_0 : OUT std_logic;
		TX_PHY_CLK_OUT_0 : OUT std_logic;
		EMAC0CLIENTRXD : OUT std_logic_vector(7 downto 0);
		EMAC0CLIENTRXDVLD : OUT std_logic;
		EMAC0CLIENTRXGOODFRAME : OUT std_logic;
		EMAC0CLIENTRXBADFRAME : OUT std_logic;
		EMAC0CLIENTRXFRAMEDROP : OUT std_logic;
		EMAC0CLIENTRXSTATS : OUT std_logic_vector(6 downto 0);
		EMAC0CLIENTRXSTATSVLD : OUT std_logic;
		EMAC0CLIENTRXSTATSBYTEVLD : OUT std_logic;
		EMAC0CLIENTTXACK : OUT std_logic;
		EMAC0CLIENTTXCOLLISION : OUT std_logic;
		EMAC0CLIENTTXRETRANSMIT : OUT std_logic;
		EMAC0CLIENTTXSTATS : OUT std_logic;
		EMAC0CLIENTTXSTATSVLD : OUT std_logic;
		EMAC0CLIENTTXSTATSBYTEVLD : OUT std_logic;
		GMII_TXD_0 : OUT std_logic_vector(7 downto 0);
		GMII_TX_EN_0 : OUT std_logic;
		GMII_TX_ER_0 : OUT std_logic;
		GMII_TX_CLK_0 : OUT std_logic
		);
	END COMPONENT;

-- COMP_TAG_END ------ End COMPONENT Declaration ------------
-- The following code must appear in the VHDL architecture
-- body. Substitute your own instance name and net names.
------------- Begin Cut here for INSTANTIATION Template ----- INST_TAG
	Inst_v5_emac_v1_5_block: v5_emac_v1_5_block PORT MAP(
		TX_CLIENT_CLK_OUT_0 => ,
		RX_CLIENT_CLK_OUT_0 => ,
		TX_PHY_CLK_OUT_0 => ,
		TX_CLIENT_CLK_0 => ,
		RX_CLIENT_CLK_0 => ,
		TX_PHY_CLK_0 => ,
		EMAC0CLIENTRXD => ,
		EMAC0CLIENTRXDVLD => ,
		EMAC0CLIENTRXGOODFRAME => ,
		EMAC0CLIENTRXBADFRAME => ,
		EMAC0CLIENTRXFRAMEDROP => ,
		EMAC0CLIENTRXSTATS => ,
		EMAC0CLIENTRXSTATSVLD => ,
		EMAC0CLIENTRXSTATSBYTEVLD => ,
		CLIENTEMAC0TXD => ,
		CLIENTEMAC0TXDVLD => ,
		EMAC0CLIENTTXACK => ,
		CLIENTEMAC0TXFIRSTBYTE => ,
		CLIENTEMAC0TXUNDERRUN => ,
		EMAC0CLIENTTXCOLLISION => ,
		EMAC0CLIENTTXRETRANSMIT => ,
		CLIENTEMAC0TXIFGDELAY => ,
		EMAC0CLIENTTXSTATS => ,
		EMAC0CLIENTTXSTATSVLD => ,
		EMAC0CLIENTTXSTATSBYTEVLD => ,
		CLIENTEMAC0PAUSEREQ => ,
		CLIENTEMAC0PAUSEVAL => ,
		GTX_CLK_0 => ,
		GMII_TXD_0 => ,
		GMII_TX_EN_0 => ,
		GMII_TX_ER_0 => ,
		GMII_TX_CLK_0 => ,
		GMII_RXD_0 => ,
		GMII_RX_DV_0 => ,
		GMII_RX_ER_0 => ,
		GMII_RX_CLK_0 => ,
		MII_TX_CLK_0 => ,
		GMII_COL_0 => ,
		GMII_CRS_0 => ,
		RESET => 
	);



-- INST_TAG_END ------ End INSTANTIATION Template ------------

-- You must compile the wrapper file v5_emac_v1_5_block.vhd when simulating
-- the core, v5_emac_v1_5_block. When compiling the wrapper file, be sure to
-- reference the XilinxCoreLib VHDL simulation library. For detailed
-- instructions, please refer to the "CORE Generator Help".
