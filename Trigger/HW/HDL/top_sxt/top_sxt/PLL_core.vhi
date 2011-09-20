
-- VHDL Instantiation Created from source file PLL_core.vhd -- 13:14:11 09/15/2011
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT PLL_core
	PORT(
		CLKIN1_IN : IN std_logic;
		RST_IN : IN std_logic;          
		CLKOUT0_OUT : OUT std_logic;
		CLKOUT1_OUT : OUT std_logic;
		CLKOUT2_OUT : OUT std_logic;
		CLKOUT3_OUT : OUT std_logic;
		LOCKED_OUT : OUT std_logic
		);
	END COMPONENT;

	Inst_PLL_core: PLL_core PORT MAP(
		CLKIN1_IN => ,
		RST_IN => ,
		CLKOUT0_OUT => ,
		CLKOUT1_OUT => ,
		CLKOUT2_OUT => ,
		CLKOUT3_OUT => ,
		LOCKED_OUT => 
	);


