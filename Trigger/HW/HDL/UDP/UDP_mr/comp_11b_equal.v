////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995-2008 Xilinx, Inc.  All rights reserved.
////////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor: Xilinx
// \   \   \/     Version: K.39
//  \   \         Application: netgen
//  /   /         Filename: comp_11b_equal.v
// /___/   /\     Timestamp: Mon May 23 13:29:39 2011
// \   \  /  \ 
//  \___\/\___\
//             
// Command	: -intstyle ise -w -sim -ofmt verilog M:\MASTER\COMPET\Trigger\HW\HDL\UDP\UDP_mr\tmp\_cg\comp_11b_equal.ngc M:\MASTER\COMPET\Trigger\HW\HDL\UDP\UDP_mr\tmp\_cg\comp_11b_equal.v 
// Device	: 5vlx50tff1136-1
// Input file	: M:/MASTER/COMPET/Trigger/HW/HDL/UDP/UDP_mr/tmp/_cg/comp_11b_equal.ngc
// Output file	: M:/MASTER/COMPET/Trigger/HW/HDL/UDP/UDP_mr/tmp/_cg/comp_11b_equal.v
// # of Modules	: 1
// Design Name	: comp_11b_equal
// Xilinx        : C:\Xilinx\10.1\ISE
//             
// Purpose:    
//     This verilog netlist is a verification model and uses simulation 
//     primitives which may not represent the true implementation of the 
//     device, however the netlist is functionally correct and should not 
//     be modified. This file cannot be synthesized and should only be used 
//     with supported simulation tools.
//             
// Reference:  
//     Development System Reference Guide, Chapter 23 and Synthesis and Simulation Design Guide, Chapter 6
//             
////////////////////////////////////////////////////////////////////////////////

`timescale 1 ns/1 ps

module comp_11b_equal (
  qa_eq_b, clk, a, b
);
  output qa_eq_b;
  input clk;
  input [10 : 0] a;
  input [10 : 0] b;
  
  // synthesis translate_off
  
  wire \BU2/U0/gen_structure_logic.gen_nonpipelined.a_equal_notequal_b.i_a_eq_ne_b/i_use_carry_plus_luts.lut_and.i_gate_bit/tier_gen[1].i_tier/loop_tiles[0].i_tile/o189_29 ;
  wire \BU2/U0/gen_structure_logic.gen_nonpipelined.a_equal_notequal_b.i_a_eq_ne_b/i_use_carry_plus_luts.lut_and.i_gate_bit/tier_gen[1].i_tier/loop_tiles[0].i_tile/o139_28 ;
  wire \BU2/U0/gen_structure_logic.gen_nonpipelined.a_equal_notequal_b.i_a_eq_ne_b/i_use_carry_plus_luts.lut_and.i_gate_bit/tier_gen[1].i_tier/loop_tiles[0].i_tile/o62_27 ;
  wire \BU2/U0/gen_structure_logic.gen_nonpipelined.a_equal_notequal_b.i_a_eq_ne_b/i_use_carry_plus_luts.lut_and.i_gate_bit/tier_gen[1].i_tier/loop_tiles[0].i_tile/o26_26 ;
  wire \BU2/U0/gen_structure_logic.gen_nonpipelined.a_equal_notequal_b.i_a_eq_ne_b/temp_result ;
  wire \BU2/a_ge_b ;
  wire NLW_VCC_P_UNCONNECTED;
  wire NLW_GND_G_UNCONNECTED;
  wire [10 : 0] a_2;
  wire [10 : 0] b_3;
  assign
    a_2[10] = a[10],
    a_2[9] = a[9],
    a_2[8] = a[8],
    a_2[7] = a[7],
    a_2[6] = a[6],
    a_2[5] = a[5],
    a_2[4] = a[4],
    a_2[3] = a[3],
    a_2[2] = a[2],
    a_2[1] = a[1],
    a_2[0] = a[0],
    b_3[10] = b[10],
    b_3[9] = b[9],
    b_3[8] = b[8],
    b_3[7] = b[7],
    b_3[6] = b[6],
    b_3[5] = b[5],
    b_3[4] = b[4],
    b_3[3] = b[3],
    b_3[2] = b[2],
    b_3[1] = b[1],
    b_3[0] = b[0];
  VCC   VCC_0 (
    .P(NLW_VCC_P_UNCONNECTED)
  );
  GND   GND_1 (
    .G(NLW_GND_G_UNCONNECTED)
  );
  LUT6 #(
    .INIT ( 64'h9000000000000000 ))
  \BU2/U0/gen_structure_logic.gen_nonpipelined.a_equal_notequal_b.i_a_eq_ne_b/i_use_carry_plus_luts.lut_and.i_gate_bit/tier_gen[1].i_tier/loop_tiles[0].i_tile/o206  (
    .I0(a_2[2]),
    .I1(b_3[2]),
    .I2
(\BU2/U0/gen_structure_logic.gen_nonpipelined.a_equal_notequal_b.i_a_eq_ne_b/i_use_carry_plus_luts.lut_and.i_gate_bit/tier_gen[1].i_tier/loop_tiles[0].i_tile/o26_26 )
,
    .I3
(\BU2/U0/gen_structure_logic.gen_nonpipelined.a_equal_notequal_b.i_a_eq_ne_b/i_use_carry_plus_luts.lut_and.i_gate_bit/tier_gen[1].i_tier/loop_tiles[0].i_tile/o62_27 )
,
    .I4
(\BU2/U0/gen_structure_logic.gen_nonpipelined.a_equal_notequal_b.i_a_eq_ne_b/i_use_carry_plus_luts.lut_and.i_gate_bit/tier_gen[1].i_tier/loop_tiles[0].i_tile/o139_28 )
,
    .I5
(\BU2/U0/gen_structure_logic.gen_nonpipelined.a_equal_notequal_b.i_a_eq_ne_b/i_use_carry_plus_luts.lut_and.i_gate_bit/tier_gen[1].i_tier/loop_tiles[0].i_tile/o189_29 )
,
    .O(\BU2/U0/gen_structure_logic.gen_nonpipelined.a_equal_notequal_b.i_a_eq_ne_b/temp_result )
  );
  LUT6 #(
    .INIT ( 64'h9009000000009009 ))
  \BU2/U0/gen_structure_logic.gen_nonpipelined.a_equal_notequal_b.i_a_eq_ne_b/i_use_carry_plus_luts.lut_and.i_gate_bit/tier_gen[1].i_tier/loop_tiles[0].i_tile/o189  (
    .I0(a_2[5]),
    .I1(b_3[5]),
    .I2(a_2[6]),
    .I3(b_3[6]),
    .I4(a_2[7]),
    .I5(b_3[7]),
    .O
(\BU2/U0/gen_structure_logic.gen_nonpipelined.a_equal_notequal_b.i_a_eq_ne_b/i_use_carry_plus_luts.lut_and.i_gate_bit/tier_gen[1].i_tier/loop_tiles[0].i_tile/o189_29 )

  );
  LUT6 #(
    .INIT ( 64'h9009000000009009 ))
  \BU2/U0/gen_structure_logic.gen_nonpipelined.a_equal_notequal_b.i_a_eq_ne_b/i_use_carry_plus_luts.lut_and.i_gate_bit/tier_gen[1].i_tier/loop_tiles[0].i_tile/o139  (
    .I0(a_2[8]),
    .I1(b_3[8]),
    .I2(a_2[9]),
    .I3(b_3[9]),
    .I4(a_2[10]),
    .I5(b_3[10]),
    .O
(\BU2/U0/gen_structure_logic.gen_nonpipelined.a_equal_notequal_b.i_a_eq_ne_b/i_use_carry_plus_luts.lut_and.i_gate_bit/tier_gen[1].i_tier/loop_tiles[0].i_tile/o139_28 )

  );
  LUT4 #(
    .INIT ( 16'h9009 ))
  \BU2/U0/gen_structure_logic.gen_nonpipelined.a_equal_notequal_b.i_a_eq_ne_b/i_use_carry_plus_luts.lut_and.i_gate_bit/tier_gen[1].i_tier/loop_tiles[0].i_tile/o62  (
    .I0(a_2[3]),
    .I1(b_3[3]),
    .I2(a_2[4]),
    .I3(b_3[4]),
    .O
(\BU2/U0/gen_structure_logic.gen_nonpipelined.a_equal_notequal_b.i_a_eq_ne_b/i_use_carry_plus_luts.lut_and.i_gate_bit/tier_gen[1].i_tier/loop_tiles[0].i_tile/o62_27 )

  );
  LUT4 #(
    .INIT ( 16'h9009 ))
  \BU2/U0/gen_structure_logic.gen_nonpipelined.a_equal_notequal_b.i_a_eq_ne_b/i_use_carry_plus_luts.lut_and.i_gate_bit/tier_gen[1].i_tier/loop_tiles[0].i_tile/o26  (
    .I0(a_2[0]),
    .I1(b_3[0]),
    .I2(a_2[1]),
    .I3(b_3[1]),
    .O
(\BU2/U0/gen_structure_logic.gen_nonpipelined.a_equal_notequal_b.i_a_eq_ne_b/i_use_carry_plus_luts.lut_and.i_gate_bit/tier_gen[1].i_tier/loop_tiles[0].i_tile/o26_26 )

  );
  FD #(
    .INIT ( 1'b0 ))
  \BU2/U0/gen_structure_logic.gen_nonpipelined.a_equal_notequal_b.i_a_eq_ne_b/gen_output_reg.output_reg/fd/output_1  (
    .C(clk),
    .D(\BU2/U0/gen_structure_logic.gen_nonpipelined.a_equal_notequal_b.i_a_eq_ne_b/temp_result ),
    .Q(qa_eq_b)
  );
  GND   \BU2/XST_GND  (
    .G(\BU2/a_ge_b )
  );

// synthesis translate_on

endmodule

// synthesis translate_off

`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;

    wire GSR;
    wire GTS;
    wire PRLD;

    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (weak1, weak0) GSR = GSR_int;
    assign (weak1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

endmodule

// synthesis translate_on
