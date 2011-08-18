onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /udp_rec_tb/clk
add wave -noupdate /udp_rec_tb/rst_b
add wave -noupdate /udp_rec_tb/usr_data_input_bus
add wave -noupdate /udp_rec_tb/valid_out_usr_data
add wave -noupdate /udp_rec_tb/data_out
add wave -noupdate /udp_rec_tb/valid_data
add wave -noupdate -radix hexadecimal /udp_rec_tb/port_number
add wave -noupdate /udp_rec_tb/dut/data_out
add wave -noupdate -radix hexadecimal /udp_rec_tb/dut/port_number
add wave -noupdate /udp_rec_tb/dut/header
add wave -noupdate /udp_rec_tb/dut/ip_correct
add wave -noupdate /udp_rec_tb/lclk
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2345706 ps} 0}
configure wave -namecolwidth 320
configure wave -valuecolwidth 245
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
WaveRestoreZoom {2269871 ps} {2410129 ps}
