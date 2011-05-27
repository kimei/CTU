--------------------------------------------------------------------------------
--     This file is owned and controlled by Xilinx and must be used           --
--     solely for design, simulation, implementation and creation of          --
--     design files limited to Xilinx devices or technologies. Use            --
--     with non-Xilinx devices or technologies is expressly prohibited        --
--     and immediately terminates your license.                               --
--                                                                            --
--     XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS"          --
--     SOLELY FOR USE IN DEVELOPING PROGRAMS AND SOLUTIONS FOR                --
--     XILINX DEVICES.  BY PROVIDING THIS DESIGN, CODE, OR INFORMATION        --
--     AS ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE, APPLICATION            --
--     OR STANDARD, XILINX IS MAKING NO REPRESENTATION THAT THIS              --
--     IMPLEMENTATION IS FREE FROM ANY CLAIMS OF INFRINGEMENT,                --
--     AND YOU ARE RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE       --
--     FOR YOUR IMPLEMENTATION.  XILINX EXPRESSLY DISCLAIMS ANY               --
--     WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF THE                --
--     IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR         --
--     REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS OF        --
--     INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS        --
--     FOR A PARTICULAR PURPOSE.                                              --
--                                                                            --
--     Xilinx products are not intended for use in life support               --
--     appliances, devices, or systems. Use in such applications are          --
--     expressly prohibited.                                                  --
--                                                                            --
--     (c) Copyright 1995-2007 Xilinx, Inc.                                   --
--     All rights reserved.                                                   --
--------------------------------------------------------------------------------
-- You must compile the wrapper file comp_6b_equal.vhd when simulating
-- the core, comp_6b_equal. When compiling the wrapper file, be sure to
-- reference the XilinxCoreLib VHDL simulation library. For detailed
-- instructions, please refer to the "CORE Generator Help".

-- The synthesis directives "translate_off/translate_on" specified
-- below are supported by Xilinx, Mentor Graphics and Synplicity
-- synthesis tools. Ensure they are correct for your synthesis tool(s).

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
-- synthesis translate_off
Library XilinxCoreLib;
-- synthesis translate_on
ENTITY comp_6b_equal IS
	port (
	a: IN std_logic_VECTOR(5 downto 0);
	b: IN std_logic_VECTOR(5 downto 0);
	clk: IN std_logic;
	qa_eq_b: OUT std_logic);
END comp_6b_equal;

ARCHITECTURE comp_6b_equal_a OF comp_6b_equal IS
-- synthesis translate_off
component wrapped_comp_6b_equal
	port (
	a: IN std_logic_VECTOR(5 downto 0);
	b: IN std_logic_VECTOR(5 downto 0);
	clk: IN std_logic;
	qa_eq_b: OUT std_logic);
end component;

-- Configuration specification 
	for all : wrapped_comp_6b_equal use entity XilinxCoreLib.c_compare_v9_0(behavioral)
		generic map(
			c_has_qa_ge_b => 0,
			c_has_aset => 0,
			c_has_qa_lt_b => 0,
			c_has_qa_ne_b => 0,
			c_has_a_gt_b => 0,
			c_has_a_eq_b => 0,
			c_data_type => 1,
			c_sync_priority => 1,
			c_has_sclr => 0,
			c_has_qa_gt_b => 0,
			c_width => 6,
			c_has_qa_eq_b => 1,
			c_enable_rlocs => 0,
			c_infered_rtl_const_compare => 0,
			c_carry_chain_eq_ne => 0,
			c_has_a_le_b => 0,
			c_ainit_val => "0",
			c_dense_lut_packing => 0,
			c_has_ce => 0,
			c_pipe_stages => 0,
			c_has_aclr => 0,
			c_sync_enable => 0,
			c_has_sset => 0,
			c_has_qa_le_b => 0,
			c_b_constant => 0,
			c_has_a_ge_b => 0,
			c_has_a_ne_b => 0,
			c_has_a_lt_b => 0,
			c_b_value => "0000000000000000");
-- synthesis translate_on
BEGIN
-- synthesis translate_off
U0 : wrapped_comp_6b_equal
		port map (
			a => a,
			b => b,
			clk => clk,
			qa_eq_b => qa_eq_b);
-- synthesis translate_on

END comp_6b_equal_a;

