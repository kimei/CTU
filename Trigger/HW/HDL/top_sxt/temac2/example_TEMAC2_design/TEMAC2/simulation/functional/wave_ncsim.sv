# SimVision Command Script

#
# groups
#

if {[catch {group new -name {System Signals} -overlay 0}] != ""} {
    group using {System Signals}
    group set -overlay 0
    group set -comment {}
    group clear 0 end
}
group insert \
    :testbench.reset \
    :testbench.gtx_clk \
    :testbench.host_clk


if {[catch {group new -name {EMAC1 TX Client Interface} -overlay 0}] != ""} {
    group using {EMAC1 TX Client Interface}
    group set -overlay 0
    group set -comment {}
    group clear 0 end
}
group insert \
    :testbench.dut.tx_clk_1 \
    :testbench.dut.v5_emac_ll.tx_data_1_i \
    :testbench.dut.v5_emac_ll.tx_data_valid_1_i \
    :testbench.dut.v5_emac_ll.tx_ack_1_i \
    :testbench.tx_ifg_delay_1

if {[catch {group new -name {EMAC1 RX Client Interface} -overlay 0}] != ""} {
    group using {EMAC1 RX Client Interface}
    group set -overlay 0
    group set -comment {}
    group clear 0 end
}
group insert \
    :testbench.dut.rx_clk_1_i \
    :testbench.dut.v5_emac_ll.rx_data_1_i \
    :testbench.dut.v5_emac_ll.rx_data_valid_1_i \
    :testbench.dut.v5_emac_ll.rx_good_frame_1_i \
    :testbench.dut.v5_emac_ll.rx_bad_frame_1_i

if {[catch {group new -name {EMAC1 Flow Control} -overlay 0}] != ""} {
    group using {EMAC1 Flow Control}
    group set -overlay 0
    group set -comment {}
    group clear 0 end
}
group insert \
    :testbench.pause_val_1 \
    :testbench.pause_req_1

if {[catch {group new -name {EMAC1 TX GMII/MII Interface} -overlay 0}] != ""} {
    group using {EMAC1 TX GMII/MII Interface}
    group set -overlay 0
    group set -comment {}
    group clear 0 end
}
group insert \
    :testbench.gmii_tx_clk_1 \
    :testbench.gmii_txd_1 \
    :testbench.gmii_tx_en_1 \
    :testbench.gmii_tx_er_1 
if {[catch {group new -name {EMAC1 RX GMII/MII Interface} -overlay 0}] != ""} {
    group using {EMAC1 RX GMII/MII Interface}
    group set -overlay 0
    group set -comment {}
    group clear 0 end
}
group insert \
    :testbench.gmii_rx_clk_1 \
    :testbench.gmii_rxd_1 \
    :testbench.gmii_rx_dv_1 \
    :testbench.gmii_rx_er_1 

if {[catch {group new -name {Test semaphores} -overlay 0}] != ""} {
    group using {Test semaphores}
    group set -overlay 0
    group set -comment {}
    group clear 0 end
}
group insert \
    :testbench.emac1_configuration_busy \
    :testbench.emac1_monitor_finished_1g \
    :testbench.emac1_monitor_finished_100m \
    :testbench.emac1_monitor_finished_10m 

#
# Waveform windows
#
if {[window find -match exact -name "Waveform 1"] == {}} {
    window new WaveWindow -name "Waveform 1" -geometry 906x585+25+55
} else {
    window geometry "Waveform 1" 906x585+25+55
}
window target "Waveform 1" on
waveform using {Waveform 1}
waveform sidebar visibility partial
waveform set \
    -primarycursor TimeA \
    -signalnames name \
    -signalwidth 175 \
    -units fs \
    -valuewidth 75
cursor set -using TimeA -time 50,000,000,000fs
cursor set -using TimeA -marching 1
waveform baseline set -time 0

set id [waveform add -signals [list :testbench.reset \
	:testbench.gtx_clk ]]

set groupId [waveform add -groups {{System Signals}}]



set groupId [waveform add -groups {{EMAC1 TX Client Interface}}]

set groupId [waveform add -groups {{EMAC1 RX Client Interface}}]

set groupId [waveform add -groups {{EMAC1 TX GMII/MII Interface}}]

set groupId [waveform add -groups {{EMAC1 RX GMII/MII Interface}}]


set groupId [waveform add -groups {{Management Interface}}]

set groupId [waveform add -groups {{Test semaphores}}]

waveform xview limits 0fs 10us

simcontrol run -time 2000us

