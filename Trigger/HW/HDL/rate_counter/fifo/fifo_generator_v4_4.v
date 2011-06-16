/*******************************************************************************
*     (c) Copyright 1995 - 2010 Xilinx, Inc. All rights reserved.              *
*                                                                              *
*     This file contains confidential and proprietary information              *
*     of Xilinx, Inc. and is protected under U.S. and                          *
*     international copyright and other intellectual property                  *
*     laws.                                                                    *
*                                                                              *
*     DISCLAIMER                                                               *
*     This disclaimer is not a license and does not grant any                  *
*     rights to the materials distributed herewith. Except as                  *
*     otherwise provided in a valid license issued to you by                   *
*     Xilinx, and to the maximum extent permitted by applicable                *
*     law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND                  *
*     WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES              *
*     AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING                *
*     BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-                   *
*     INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and                 *
*     (2) Xilinx shall not be liable (whether in contract or tort,             *
*     including negligence, or under any other theory of                       *
*     liability) for any loss or damage of any kind or nature                  *
*     related to, arising under or in connection with these                    *
*     materials, including for any direct, or any indirect,                    *
*     special, incidental, or consequential loss or damage                     *
*     (including loss of data, profits, goodwill, or any type of               *
*     loss or damage suffered as a result of any action brought                *
*     by a third party) even if such damage or loss was                        *
*     reasonably foreseeable or Xilinx had been advised of the                 *
*     possibility of the same.                                                 *
*                                                                              *
*     CRITICAL APPLICATIONS                                                    *
*     Xilinx products are not designed or intended to be fail-                 *
*     safe, or for use in any application requiring fail-safe                  *
*     performance, such as life-support or safety devices or                   *
*     systems, Class III medical devices, nuclear facilities,                  *
*     applications related to the deployment of airbags, or any                *
*     other applications that could lead to death, personal                    *
*     injury, or severe property or environmental damage                       *
*     (individually and collectively, "Critical                                *
*     Applications"). Customer assumes the sole risk and                       *
*     liability of any use of Xilinx products in Critical                      *
*     Applications, subject only to applicable laws and                        *
*     regulations governing limitations on product liability.                  *
*                                                                              *
*     THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS                 *
*     PART OF THIS FILE AT ALL TIMES.                                          *
*******************************************************************************/
// The synthesis directives "translate_off/translate_on" specified below are
// supported by Xilinx, Mentor Graphics and Synplicity synthesis
// tools. Ensure they are correct for your synthesis tool(s).

// You must compile the wrapper file fifo_generator_v4_4.v when simulating
// the core, fifo_generator_v4_4. When compiling the wrapper file, be sure to
// reference the XilinxCoreLib Verilog simulation library. For detailed
// instructions, please refer to the "CORE Generator Help".

`timescale 1ns/1ps

module fifo_generator_v4_4(
	clk,
	din,
	rd_en,
	rst,
	wr_en,
	data_count,
	dout,
	empty,
	full);


input clk;
input [7 : 0] din;
input rd_en;
input rst;
input wr_en;
output [8 : 0] data_count;
output [7 : 0] dout;
output empty;
output full;

// synthesis translate_off

      FIFO_GENERATOR_V4_4 #(
		.C_COMMON_CLOCK(1),
		.C_COUNT_TYPE(0),
		.C_DATA_COUNT_WIDTH(9),
		.C_DEFAULT_VALUE("BlankString"),
		.C_DIN_WIDTH(8),
		.C_DOUT_RST_VAL("0"),
		.C_DOUT_WIDTH(8),
		.C_ENABLE_RLOCS(0),
		.C_FAMILY("virtex5"),
		.C_FULL_FLAGS_RST_VAL(1),
		.C_HAS_ALMOST_EMPTY(0),
		.C_HAS_ALMOST_FULL(0),
		.C_HAS_BACKUP(0),
		.C_HAS_DATA_COUNT(1),
		.C_HAS_INT_CLK(0),
		.C_HAS_MEMINIT_FILE(0),
		.C_HAS_OVERFLOW(0),
		.C_HAS_RD_DATA_COUNT(0),
		.C_HAS_RD_RST(0),
		.C_HAS_RST(1),
		.C_HAS_SRST(0),
		.C_HAS_UNDERFLOW(0),
		.C_HAS_VALID(0),
		.C_HAS_WR_ACK(0),
		.C_HAS_WR_DATA_COUNT(0),
		.C_HAS_WR_RST(0),
		.C_IMPLEMENTATION_TYPE(0),
		.C_INIT_WR_PNTR_VAL(0),
		.C_MEMORY_TYPE(1),
		.C_MIF_FILE_NAME("BlankString"),
		.C_MSGON_VAL(1),
		.C_OPTIMIZATION_MODE(0),
		.C_OVERFLOW_LOW(0),
		.C_PRELOAD_LATENCY(0),
		.C_PRELOAD_REGS(1),
		.C_PRIM_FIFO_TYPE("512x36"),
		.C_PROG_EMPTY_THRESH_ASSERT_VAL(4),
		.C_PROG_EMPTY_THRESH_NEGATE_VAL(5),
		.C_PROG_EMPTY_TYPE(0),
		.C_PROG_FULL_THRESH_ASSERT_VAL(255),
		.C_PROG_FULL_THRESH_NEGATE_VAL(254),
		.C_PROG_FULL_TYPE(0),
		.C_RD_DATA_COUNT_WIDTH(9),
		.C_RD_DEPTH(256),
		.C_RD_FREQ(1),
		.C_RD_PNTR_WIDTH(8),
		.C_UNDERFLOW_LOW(0),
		.C_USE_DOUT_RST(1),
		.C_USE_ECC(0),
		.C_USE_EMBEDDED_REG(0),
		.C_USE_FIFO16_FLAGS(0),
		.C_USE_FWFT_DATA_COUNT(1),
		.C_VALID_LOW(0),
		.C_WR_ACK_LOW(0),
		.C_WR_DATA_COUNT_WIDTH(9),
		.C_WR_DEPTH(256),
		.C_WR_FREQ(1),
		.C_WR_PNTR_WIDTH(8),
		.C_WR_RESPONSE_LATENCY(1))
	inst (
		.CLK(clk),
		.DIN(din),
		.RD_EN(rd_en),
		.RST(rst),
		.WR_EN(wr_en),
		.DATA_COUNT(data_count),
		.DOUT(dout),
		.EMPTY(empty),
		.FULL(full),
		.INT_CLK(),
		.BACKUP(),
		.BACKUP_MARKER(),
		.PROG_EMPTY_THRESH(),
		.PROG_EMPTY_THRESH_ASSERT(),
		.PROG_EMPTY_THRESH_NEGATE(),
		.PROG_FULL_THRESH(),
		.PROG_FULL_THRESH_ASSERT(),
		.PROG_FULL_THRESH_NEGATE(),
		.RD_CLK(),
		.RD_RST(),
		.SRST(),
		.WR_CLK(),
		.WR_RST(),
		.ALMOST_EMPTY(),
		.ALMOST_FULL(),
		.OVERFLOW(),
		.PROG_EMPTY(),
		.PROG_FULL(),
		.VALID(),
		.RD_DATA_COUNT(),
		.UNDERFLOW(),
		.WR_ACK(),
		.WR_DATA_COUNT(),
		.SBITERR(),
		.DBITERR());


// synthesis translate_on

endmodule

