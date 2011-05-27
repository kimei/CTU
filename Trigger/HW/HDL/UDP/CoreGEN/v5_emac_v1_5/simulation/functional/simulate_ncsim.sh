#!/bin/sh
mkdir work

ncvhdl -v93 -work work ../../example_design/client/address_swap_module_8.vhd
ncvhdl -v93 -work work ../../example_design/client/fifo/tx_client_fifo_8.vhd
ncvhdl -v93 -work work ../../example_design/client/fifo/rx_client_fifo_8.vhd
ncvhdl -v93 -work work ../../example_design/client/fifo/eth_fifo_8.vhd
ncvhdl -v93 -work work ../../example_design/physical/gmii_if.vhd
ncvhdl -v93 -work work ../../example_design/v5_emac_v1_5.vhd
ncvhdl -v93 -work work ../../example_design/v5_emac_v1_5_block.vhd
ncvhdl -v93 -work work ../../example_design/v5_emac_v1_5_locallink.vhd
ncvhdl -v93 -work work ../../example_design/v5_emac_v1_5_example_design.vhd
ncvhdl -v93 -work work ../configuration_tb.vhd
ncvhdl -v93 -work work ../emac0_phy_tb.vhd
ncvhdl -v93 -work work ../demo_tb.vhd
ncelab -vhdl_time_precision 1ps -NOWARN DLCPTH -NOWARN CUVWSI -NOWARN CSINFI -NOWARN NTCNNC -NOWARN CUVWSP -NOWARN NCCDELW -loadpli1 swiftpli:swift_boot -access +rw work.testbench:behavioral
ncsim -gui work.testbench:behavioral -input @"simvision -input wave_ncsim.sv"
