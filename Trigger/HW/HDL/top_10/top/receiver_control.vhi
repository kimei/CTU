
-- VHDL Instantiation Created from source file receiver_control.vhd -- 13:29:52 08/17/2011
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT receiver_control
	PORT(
		clk : IN std_logic;
		rst_b : IN std_logic;
		udp_data_in : IN std_logic_vector(7 downto 0);
		valid_data : IN std_logic;
		port_number : IN std_logic;
		send_fifo_we_others : IN std_logic;
		send_fifo_empty : IN std_logic;          
		mrst_from_udp_b : OUT std_logic;
		send_fifo_we : OUT std_logic;
		send_fifo_data_in : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;

	Inst_receiver_control: receiver_control PORT MAP(
		clk => ,
		rst_b => ,
		udp_data_in => ,
		valid_data => ,
		port_number => ,
		mrst_from_udp_b => ,
		send_fifo_we => ,
		send_fifo_we_others => ,
		send_fifo_empty => ,
		send_fifo_data_in => 
	);


