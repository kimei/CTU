view structure
view signals
view wave
onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {System Signals}
add wave -noupdate -format Logic /testbench/reset
add wave -noupdate -format Logic /testbench/gtx_clk
add wave -noupdate -format Logic /testbench/host_clk
add wave -noupdate -divider {EMAC1 Tx Client Interface}
add wave -noupdate -label tx_client_clk_1 -format Logic /testbench/dut/tx_clk_1
add wave -noupdate -label dut/tx_data_1_i -format Literal -hex /testbench/dut/\\v5_emac_ll/tx_data_1_i\\
add wave -noupdate -label dut/tx_data_valid_1_i -format Logic /testbench/dut/\\v5_emac_ll/tx_data_valid_1_i\\
add wave -noupdate -label dut/tx_ack_1_i -format Logic /testbench/dut/\\v5_emac_ll/tx_ack_1_i\\
add wave -noupdate -format Literal -hex /testbench/tx_ifg_delay_1
add wave -noupdate -divider {EMAC1 Rx Client Interface}
add wave -noupdate -label rx_client_clk_1 -format Logic /testbench/dut/rx_clk_1_i
add wave -noupdate -label dut/rx_data_1_i -format Literal -hex /testbench/dut/\\v5_emac_ll/rx_data_1_i\\
add wave -noupdate -label dut/rx_data_valid_1_i -format Logic /testbench/dut/EMAC1CLIENTRXDVLD
add wave -noupdate -label dut/rx_good_frame_1_i -format Logic /testbench/dut/\\v5_emac_ll/rx_good_frame_1_i\\
add wave -noupdate -label dut/rx_bad_frame_1_i -format Logic /testbench/dut/\\v5_emac_ll/rx_bad_frame_1_i\\
add wave -noupdate -divider {EMAC1 Flow Control}
add wave -noupdate -format Literal -hex /testbench/pause_val_1
add wave -noupdate -format Logic /testbench/pause_req_1
add wave -noupdate -divider {EMAC1 Tx GMII/MII Interface}
add wave -noupdate -format Logic /testbench/gmii_tx_clk_1
add wave -noupdate -format Literal -hex /testbench/gmii_txd_1
add wave -noupdate -format Logic /testbench/gmii_tx_en_1
add wave -noupdate -format Logic /testbench/gmii_tx_er_1
add wave -noupdate -divider {EMAC1 Rx GMII/MII Interface}
add wave -noupdate -format Logic /testbench/gmii_rx_clk_1
add wave -noupdate -format Literal -hex /testbench/gmii_rxd_1
add wave -noupdate -format Logic /testbench/gmii_rx_dv_1
add wave -noupdate -format Logic /testbench/gmii_rx_er_1
add wave -noupdate -divider {Test semaphores}
add wave -noupdate -format Logic /testbench/emac1_configuration_busy
add wave -noupdate -format Logic /testbench/emac1_monitor_finished_1g
add wave -noupdate -format Logic /testbench/emac1_monitor_finished_100m
add wave -noupdate -format Logic /testbench/emac1_monitor_finished_10m
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
WaveRestoreZoom {0 ps} {4310754 ps}
