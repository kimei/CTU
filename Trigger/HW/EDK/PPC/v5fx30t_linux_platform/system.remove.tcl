cd M:/MASTER/COMPET/Trigger/HW/EDK/PPC/v5fx30t_linux_platform
if { [xload xmp system.xmp] != 0 } {
  exit -1
}
xset intstyle default
save proj
exit 0
