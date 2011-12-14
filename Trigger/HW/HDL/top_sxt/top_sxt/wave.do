onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /sync_trigger_tb/mclk
add wave -noupdate -divider Input
add wave -noupdate /sync_trigger_tb/trigger_in(19)
add wave -noupdate /sync_trigger_tb/trigger_in(18)
add wave -noupdate /sync_trigger_tb/trigger_in(17)
add wave -noupdate /sync_trigger_tb/trigger_in(16)
add wave -noupdate /sync_trigger_tb/trigger_in(15)
add wave -noupdate /sync_trigger_tb/trigger_in(14)
add wave -noupdate /sync_trigger_tb/trigger_in(13)
add wave -noupdate /sync_trigger_tb/trigger_in(12)
add wave -noupdate /sync_trigger_tb/trigger_in(11)
add wave -noupdate /sync_trigger_tb/trigger_in(10)
add wave -noupdate /sync_trigger_tb/trigger_in(9)
add wave -noupdate /sync_trigger_tb/trigger_in(8)
add wave -noupdate /sync_trigger_tb/trigger_in(7)
add wave -noupdate /sync_trigger_tb/trigger_in(6)
add wave -noupdate /sync_trigger_tb/trigger_in(5)
add wave -noupdate /sync_trigger_tb/trigger_in(4)
add wave -noupdate /sync_trigger_tb/trigger_in(3)
add wave -noupdate /sync_trigger_tb/trigger_in(2)
add wave -noupdate /sync_trigger_tb/trigger_in(1)
add wave -noupdate /sync_trigger_tb/trigger_in(0)
add wave -noupdate -divider Output
add wave -noupdate /sync_trigger_tb/trigger_out(0)
add wave -noupdate /sync_trigger_tb/dut/coincidence_array
add wave -noupdate /sync_trigger_tb/dut/coincidence
add wave -noupdate /sync_trigger_tb/dut/coincidence_hold
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {93440 ps} 0}
configure wave -namecolwidth 308
configure wave -valuecolwidth 65
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 20000
configure wave -gridperiod 1
configure wave -griddelta 30
configure wave -timeline 1
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {400640 ps}
