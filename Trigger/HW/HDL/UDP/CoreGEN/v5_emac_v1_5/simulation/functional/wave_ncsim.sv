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
    :reset \
    :gtx_clk \
    :host_clk

if {[catch {group new -name {EMAC0 TX Client Interface} -overlay 0}] != ""} {
    group using {EMAC0 TX Client Interface}
    group set -overlay 0
    group set -comment {}
    group clear 0 end
}
group insert \
    :dut:tx_client_clk_0 \
    :dut:v5_emac_ll:tx_data_0_i \
    :dut:v5_emac_ll:tx_data_valid_0_i \
    :dut:v5_emac_ll:tx_ack_0_i \
    :tx_ifg_delay_0

if {[catch {group new -name {EMAC0 RX Client Interface} -overlay 0}] != ""} {
    group using {EMAC0 RX Client Interface}
    group set -overlay 0
    group set -comment {}
    group clear 0 end
}
group insert \
    :dut:rx_client_clk_0 \
    :dut:v5_emac_ll:rx_data_0_i \
    :dut:v5_emac_ll:rx_data_valid_0_i \
    :dut:v5_emac_ll:rx_good_frame_0_i \
    :dut:v5_emac_ll:rx_bad_frame_0_i

if {[catch {group new -name {EMAC0 Flow Control} -overlay 0}] != ""} {
    group using {EMAC0 Flow Control}
    group set -overlay 0
    group set -comment {}
    group clear 0 end
}
group insert \
    :pause_val_0 \
    :pause_req_0

if {[catch {group new -name {EMAC0 TX GMII/MII Interface} -overlay 0}] != ""} {
    group using {EMAC0 TX GMII/MII Interface}
    group set -overlay 0
    group set -comment {}
    group clear 0 end
}
group insert \
    :gmii_tx_clk_0 \
    :gmii_txd_0 \
    :gmii_tx_en_0 \
    :gmii_tx_er_0  \
    :gmii_col_0 \
    :gmii_crs_0

if {[catch {group new -name {EMAC0 RX GMII/MII Interface} -overlay 0}] != ""} {
    group using {EMAC0 RX GMII/MII Interface}
    group set -overlay 0
    group set -comment {}
    group clear 0 end
}
group insert \
    :gmii_rx_clk_0 \
    :gmii_rxd_0 \
    :gmii_rx_dv_0 \
    :gmii_rx_er_0 


if {[catch {group new -name {Management Interface} -overlay 0}] != ""} {
    group using {Management Interface}
    group set -overlay 0
    group set -comment {}
    group clear 0 end
}
group insert \
    :speed_vector_in_0

if {[catch {group new -name {Test semaphores} -overlay 0}] != ""} {
    group using {Test semaphores}
    group set -overlay 0
    group set -comment {}
    group clear 0 end
}
group insert \
    :emac0_configuration_busy \
    :emac0_monitor_finished_1g \
    :emac0_monitor_finished_100m \
    :emac0_monitor_finished_10m

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

set id [waveform add -signals [list :reset \
        :gtx_clk ]]

set groupId [waveform add -groups {{System Signals}}]


set groupId [waveform add -groups {{EMAC0 TX Client Interface}}]

set groupId [waveform add -groups {{EMAC0 RX Client Interface}}]

set groupId [waveform add -groups {{EMAC0 TX GMII/MII Interface}}]

set groupId [waveform add -groups {{EMAC0 RX GMII/MII Interface}}]



set groupId [waveform add -groups {{Management Interface}}]

set groupId [waveform add -groups {{Test semaphores}}]

waveform xview limits 0fs 10us

simcontrol run -time 2000us

