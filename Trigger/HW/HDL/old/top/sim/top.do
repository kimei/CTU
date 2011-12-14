

onerror {abort all} 
do compile.do

vcom -93 -explicit top_tb.vhd

quit -sim 
vsim -voptargs=+acc -t 1ps top_tb


view -undock -height 900 -width 1400 -x 0 -y 0 wave

do wave.do
run 100000 ns 
radix hex