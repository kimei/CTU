
-- VHDL Instantiation Created from source file SwitchDebouncer.vhd -- 10:55:35 06/22/2011
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT SwitchDebouncer
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;
		switchesIn : IN std_logic;          
		switchesOut : OUT std_logic
		);
	END COMPONENT;

	Inst_SwitchDebouncer: SwitchDebouncer PORT MAP(
		clk => ,
		reset => ,
		switchesIn => ,
		switchesOut => 
	);


