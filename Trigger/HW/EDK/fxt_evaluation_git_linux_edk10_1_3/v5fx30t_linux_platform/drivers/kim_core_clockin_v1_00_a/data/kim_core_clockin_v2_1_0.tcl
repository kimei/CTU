##############################################################################
## Filename:          M:\MASTER\COMPET\Trigger\HW\EDK\fxt_evaluation_git_linux_edk10_1_3\v5fx30t_linux_platform/drivers/kim_core_clockin_v1_00_a/data/kim_core_clockin_v2_1_0.tcl
## Description:       Microprocess Driver Command (tcl)
## Date:              Fri Apr 08 12:07:27 2011 (by Create and Import Peripheral Wizard)
##############################################################################

#uses "xillib.tcl"

proc generate {drv_handle} {
  xdefine_include_file $drv_handle "xparameters.h" "kim_core_clockin" "NUM_INSTANCES" "DEVICE_ID" "C_BASEADDR" "C_HIGHADDR" 
}
