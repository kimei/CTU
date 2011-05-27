
-- VHDL Instantiation Created from source file pll.vhd -- 13:31:15 04/08/2011
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT pll
	PORT(
		CLKIN1_IN : IN std_logic;
		RST_IN : IN std_logic;          
		CLKOUT0_OUT : OUT std_logic;
		CLKOUT1_OUT : OUT std_logic;
		CLKOUT2_OUT : OUT std_logic;
		CLKOUT3_OUT : OUT std_logic;
		CLKOUT4_OUT : OUT std_logic;
		CLKOUT5_OUT : OUT std_logic;
		LOCKED_OUT : OUT std_logic
		);
	END COMPONENT;

	Inst_pll: pll PORT MAP(
		CLKIN1_IN => ,
		RST_IN => ,
		CLKOUT0_OUT => ,
		CLKOUT1_OUT => ,
		CLKOUT2_OUT => ,
		CLKOUT3_OUT => ,
		CLKOUT4_OUT => ,
		CLKOUT5_OUT => ,
		LOCKED_OUT => 
	);


