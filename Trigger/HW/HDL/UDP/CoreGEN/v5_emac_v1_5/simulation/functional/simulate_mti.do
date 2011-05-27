vlib work
vmap work work
vcom -work work ../../example_design/client/address_swap_module_8.vhd
vcom -work work ../../example_design/client/fifo/tx_client_fifo_8.vhd
vcom -work work ../../example_design/client/fifo/rx_client_fifo_8.vhd
vcom -work work ../../example_design/client/fifo/eth_fifo_8.vhd
vcom -work work ../../example_design/physical/gmii_if.vhd
vcom -work work ../../example_design/v5_emac_v1_5.vhd
vcom -work work ../../example_design/v5_emac_v1_5_block.vhd
vcom -work work ../../example_design/v5_emac_v1_5_locallink.vhd
vcom -work work ../../example_design/v5_emac_v1_5_example_design.vhd
vcom -work work ../configuration_tb.vhd
vcom -work work ../emac0_phy_tb.vhd
vcom -work work ../demo_tb.vhd
vsim -voptargs="+acc" -t ps work.testbench
do wave_mti.do
run -all
