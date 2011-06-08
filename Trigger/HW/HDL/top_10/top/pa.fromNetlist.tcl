
# PlanAhead Launch Script for Post-Synthesis pin planning, created by Project Navigator

create_project -name top -dir "/media/disk2/trigger/Trigger/HW/HDL/top_10/top/planAhead_run_1" -part xc5vfx30tff665-1
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "/media/disk2/trigger/Trigger/HW/HDL/top_10/top/top.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {/media/disk2/trigger/Trigger/HW/HDL/top_10/top} {../../rate_counter/fifo} {../../UDP/UDP_mr} }
set_param project.pinAheadLayout  yes
set_param project.paUcfFile  "/media/disk2/trigger/Trigger/HW/HDL/top/top.ucf"
add_files "/media/disk2/trigger/Trigger/HW/HDL/top/emac.ucf" -fileset [get_property constrset [current_run]]
add_files "/media/disk2/trigger/Trigger/HW/HDL/top/top.ucf" -fileset [get_property constrset [current_run]]
open_netlist_design
