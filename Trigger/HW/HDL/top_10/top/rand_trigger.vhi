
-- VHDL Instantiation Created from source file rand_trigger.vhd -- 11:43:51 06/22/2011
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT rand_trigger
	PORT(
		rst_b : IN std_logic;
		mclk : IN std_logic;          
		trigger_out : OUT std_logic_vector(1 downto 0)
		);
	END COMPONENT;

	Inst_rand_trigger: rand_trigger PORT MAP(
		rst_b => ,
		mclk => ,
		trigger_out => 
	);


