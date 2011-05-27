cd C:/emb_linux/fxt_evaluation_git_linux_edk10_1_2/v5fx30t_Linux
if { [xload xmp system.xmp] != 0 } {
  exit -1
}
set xpsArch [xget arch]
if { ! [ string equal -nocase $xpsArch "virtex5" ] } {
   puts "Device Family setting in XPS ($xpsArch) does not match Device Family setting in ISE (virtex5)"
   exit -1
}
set xpsDev [xget dev]
if { ! [ string equal -nocase $xpsDev "xc5vfx30t" ] } {
   puts "Device setting in XPS ($xpsDev) does not match Device setting in ISE (xc5vfx30t)"
   exit -1
}
set xpsPkg [xget package]
if { ! [ string equal -nocase $xpsPkg "ff665" ] } {
   puts "Package setting in XPS ($xpsPkg) does not match Package setting in ISE (ff665)"
   exit -1
}
set xpsSpd [xget speedgrade]
if { ! [ string equal -nocase $xpsSpd "-1" ] } {
   puts "Speed Grade setting in XPS ($xpsSpd) does not match Speed Grade setting in ISE (-1)"
   exit -1
}
xset topinst system_i
#default language
xset hdl vhdl
xset intstyle ise
save proj
exit
