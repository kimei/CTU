onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_udp/uut/clk200
add wave -noupdate /tb_udp/uut/state
add wave -noupdate /tb_udp/uut/usr_data_trans_phase_on_i
add wave -noupdate /tb_udp/uut/rd_en_fifo
add wave -noupdate /tb_udp/uut/bytes_to_send
add wave -noupdate /tb_udp/uut/dout_fifo
add wave -noupdate /tb_udp/uut/transmit_data_input_bus_i
add wave -noupdate -radix unsigned /tb_udp/uut/data_count_fifo
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {13883720 ps} 0}
configure wave -namecolwidth 522
configure wave -valuecolwidth 66
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
WaveRestoreZoom {13821640 ps} {14028360 ps}
