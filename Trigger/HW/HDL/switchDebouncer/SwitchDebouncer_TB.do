vlib work

vcom -93 -quiet -pedanticerrors -lint +acc=v SwitchDebouncer.vhdl
vcom -93 -quiet -pedanticerrors -lint SwitchDebouncer_TB.vhdl
vsim -t 1ps -quiet -voptargs="+acc" SwitchDebouncer_TB

configure wave -signalnamewidth 1
view wave -undock

add wave -height 20 -color green													clk
add wave -height 20 -color orange												reset

add wave -divider "SamplePulse"
add wave -height 20 -color salmon												UUT/SampleGen/counter
add wave -height 20 -color fireBrick											UUT/sample

set num [examine UUT/NUM_SWITCHES]

for { set i 0 } { $i < $num } { incr i } {
	add wave -divider "Switch $i"
	add wave -height 20 -color seaGreen												UUT/switchesIn($i)
	add wave -height 20 -color powderBlue											UUT/DebounceGen__$i/sync(0)
	add wave -height 20 -color powderBlue											UUT/DebounceGen__$i/sync(1)
	add wave -height 20 -color khaki -decimal -format analog -height 60	UUT/DebounceGen__$i/counter
	add wave -height 20 -color pink													UUT/switchesOut($i)
}

run 100 ms

wave zoomfull
