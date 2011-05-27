cd M:/MASTER/COMPET/Trigger/HW/EDK/fxt_evaluation_git_linux_edk10_1_3/v5fx30t_linux_platform
if { [xload xmp system.xmp] != 0 } {
  exit -1
}
xset intstyle default
save proj
exit 0
