onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /async_trigger_tb/clk
add wave -noupdate /async_trigger_tb/clk100
add wave -noupdate /async_trigger_tb/rst_b
add wave -noupdate /async_trigger_tb/rocs_reset_b
add wave -noupdate /async_trigger_tb/udp_data_in
add wave -noupdate /async_trigger_tb/valid_data
add wave -noupdate /async_trigger_tb/port_number
add wave -noupdate /async_trigger_tb/sender_ip
add wave -noupdate /async_trigger_tb/send_fifo_we
add wave -noupdate /async_trigger_tb/send_fifo_we_others
add wave -noupdate /async_trigger_tb/send_fifo_empty
add wave -noupdate /async_trigger_tb/send_fifo_data_in
add wave -noupdate /async_trigger_tb/clk_100
add wave -noupdate /async_trigger_tb/clk_125
add wave -noupdate /async_trigger_tb/clk
add wave -noupdate /async_trigger_tb/clk100
add wave -noupdate /async_trigger_tb/rst_b
add wave -noupdate /async_trigger_tb/rocs_reset_b
add wave -noupdate -radix hexadecimal /async_trigger_tb/udp_data_in
add wave -noupdate /async_trigger_tb/valid_data
add wave -noupdate /async_trigger_tb/port_number
add wave -noupdate /async_trigger_tb/sender_ip
add wave -noupdate /async_trigger_tb/send_fifo_we
add wave -noupdate /async_trigger_tb/send_fifo_we_others
add wave -noupdate /async_trigger_tb/send_fifo_empty
add wave -noupdate /async_trigger_tb/send_fifo_data_in
add wave -noupdate /async_trigger_tb/clk_100
add wave -noupdate /async_trigger_tb/clk_125
add wave -noupdate /async_trigger_tb/dut/send_tt_state
add wave -noupdate /async_trigger_tb/dut/rd_en_tt_fifo
add wave -noupdate /async_trigger_tb/dut/empty_tt_fifo
add wave -noupdate /async_trigger_tb/dut/rst_b
add wave -noupdate /async_trigger_tb/dut/atrig_state
add wave -noupdate /async_trigger_tb/dut/send_tt_state
add wave -noupdate /async_trigger_tb/dut/state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {99999921876 ps} 0}
configure wave -namecolwidth 326
configure wave -valuecolwidth 212
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {99999819858 ps} {100000009482 ps}
