
# PlanAhead Launch Script for Pre-Synthesis Floorplanning, created by Project Navigator

create_project -name top -dir "/home/kimei/VHDL/trigger/Trigger/HW/HDL/top_10/top/planAhead_run_2" -part xc5vfx30tff665-1
set_param project.pinAheadLayout yes
set srcset [get_property srcset [current_run -impl]]
set_property top top $srcset
set_param project.paUcfFile  "/home/kimei/VHDL/trigger/Trigger/HW/HDL/top/top.ucf"
set hdlfile [add_files [list {../../UDP/UDP_rec_kim/fifo/fifo_generator_v8_1.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../../UDP/UDP_mr/COUNTER_6B_LUT_FIFO_MODE.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../../UDP/UDP_mr/COUNTER_11B_EN_TRANS.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../../UDP/UDP_mr/comp_6b_equal.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../../UDP/UDP_mr/comp_11b_equal.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../../Shared/constants.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../../UDP/UDP_mr/TARGET_EOF.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../../UDP/UDP_mr/REG_16B_WREN.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../../UDP/UDP_mr/OVERRIDE_LUT_CONTROL.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../../UDP/UDP_mr/IPV4_LUT_INDEXER.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../../UDP/UDP_mr/IPV4WriteUDPHeader.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../../UDP/UDP_mr/ENABLE_USER_DATA_TRANSMISSION.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../../UDP/UDP_mr/dist_mem_64x8.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../../UDP/UDP_mr/ALLOW_ZERO_UDP_CHECKSUM.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../../UDP/UDPIP/udp_ip__core/trunk/UDP_IP_CORE/UDP_IP_CORE__Virtex5/REG_8b_wren.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../../UDP/UDPIP/udp_ip__core/trunk/UDP_IP_CORE/UDP_IP_CORE__Virtex5/PACKET_RECEIVER_FSM.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../../UDP/UDPIP/udp_ip__core/trunk/UDP_IP_CORE/UDP_IP_CORE__Virtex5/COUNTER_11B_EN_RECEIV.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../../UDP/CoreGEN/v5_emac_v1_5/example_design/v5_emac_v1_5.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../../UDP/CoreGEN/v5_emac_v1_5/example_design/physical/gmii_if.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../../UDP/CoreGEN/v5_emac_v1_5/example_design/client/fifo/tx_client_fifo_8.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../../UDP/CoreGEN/v5_emac_v1_5/example_design/client/fifo/rx_client_fifo_8.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../../Shared/functions.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../../Shared/components.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../../UDP/UDP_mr/IPV4_PACKET_TRANSMITTER.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../../UDP/UDPIP/udp_ip__core/trunk/UDP_IP_CORE/UDP_IP_CORE__Virtex5/IPv4_PACKET_RECEIVER.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../../UDP/CoreGEN/v5_emac_v1_5/example_design/v5_emac_v1_5_block.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../../UDP/CoreGEN/v5_emac_v1_5/example_design/client/fifo/eth_fifo_8.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../../Sync_Trigger/edge_detector.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../../UDP/UDP_rec_kim/udp_rec.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../../UDP/UDP_rec_kim/receiver_control.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../../UDP/UDPIP/udp_ip__core/trunk/UDP_IP_CORE/UDP_IP_CORE__Virtex5/UDP_IP_Core.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../../UDP/CoreGEN/v5_emac_v1_5/example_design/v5_emac_v1_5_locallink.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../../Shared/a2s.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../../rate_counter/rate_counter.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../../rate_counter/fifo/fifo_generator_v4_4.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../../CRU/COREgen/PLL_core.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../../UDP/CoreGEN/v5_emac_v1_5/example_design/v5_emac_v1_5_example_design.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../../Sync_Trigger/Sync_trigger.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../../switchDebouncer/SwitchDebouncer.vhdl}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../../random_trigger/rand_trigger.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../../CRU/CRU.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../../top/top.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
add_files [list {../../UDP/UDP_mr/comp_11b_equal.ngc}]
add_files [list {../../UDP/UDP_mr/comp_6b_equal.ngc}]
add_files [list {../../UDP/UDP_mr/dist_mem_64x8.ngc}]
add_files [list {../../rate_counter/fifo/fifo_generator_v4_4.ngc}]
add_files "/home/kimei/VHDL/trigger/Trigger/HW/HDL/top/emac.ucf" -fileset [get_property constrset [current_run]]
add_files "/home/kimei/VHDL/trigger/Trigger/HW/HDL/top/top.ucf" -fileset [get_property constrset [current_run]]
add_files "../../UDP/UDP_rec_kim/fifo/fifo_generator_v8_1.ncf" "../../async_trigger/fifo/fifo_generator_v8_1_8b.ncf" "../../async_trigger/fifo/fifo_generator_v8_1_32b.ncf" "../../UDP/UDP_mr/comp_6b_equal.ncf" "../../UDP/UDP_mr/dist_mem_64x8.ncf" "../../UDP/UDP_mr/comp_11b_equal.ncf" -fileset [get_property constrset [current_run]]
open_rtl_design -part xc5vfx30tff665-1
