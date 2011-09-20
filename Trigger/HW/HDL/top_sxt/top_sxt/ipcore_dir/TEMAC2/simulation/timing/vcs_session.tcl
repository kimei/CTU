gui_open_window Wave
gui_list_select -id Hier.1 { glbl testbench }
gui_list_select -id Data.1 { testbench.reset }
gui_sg_create TEMAC_Group
gui_list_add_group -id Wave.1 {TEMAC_Group}
gui_list_add_divider -id Wave.1 -after TEMAC_Group { Test_semaphores }
gui_list_add_divider -id Wave.1 -after TEMAC_Group { Management_Signals }
gui_list_add_divider -id Wave.1 -after TEMAC_Group { EMAC1_Tx_GMII_MII_Interface }
gui_list_add_divider -id Wave.1 -after TEMAC_Group { EMAC1_Rx_GMII_MII_Interface }
gui_list_add_divider -id Wave.1 -after TEMAC_Group { EMAC1_Flow_Control }
gui_list_add_divider -id Wave.1 -after TEMAC_Group { EMAC1_Rx_Client_Interface }
gui_list_add_divider -id Wave.1 -after TEMAC_Group { EMAC1_Tx_Client_Interface }
gui_list_add_divider -id Wave.1 -after TEMAC_Group { System_Signals }
gui_list_add -id Wave.1 -after System_Signals {{testbench.reset} {testbench.gtx_clk} {testbench.host_clk}}

gui_list_add -id Wave.1 -after EMAC1_Tx_Client_Interface {{testbench.dut.tx_clk_1}}
gui_list_add -id Wave.1 -after EMAC1_Tx_Client_Interface {{testbench.dut.\v5_emac_ll/tx_data_1_i}}
gui_list_add -id Wave.1 -after EMAC1_Tx_Client_Interface {{testbench.dut.\v5_emac_ll/tx_data_valid_1_i}}
gui_list_add -id Wave.1 -after EMAC1_Tx_Client_Interface {{testbench.dut.\v5_emac_ll/tx_ack_1_i}}
gui_list_add -id Wave.1 -after EMAC1_Tx_Client_Interface {{testbench.tx_ifg_delay_1}}
gui_list_add -id Wave.1 -after EMAC1_Rx_Client_Interface {{testbench.dut.rx_clk_1_i}}
gui_list_add -id Wave.1 -after EMAC1_Rx_Client_Interface {{testbench.dut.\v5_emac_ll/rx_data_1_i}}
gui_list_add -id Wave.1 -after EMAC1_Rx_Client_Interface {{testbench.dut.\v5_emac_ll/rx_data_valid_1_i}}
gui_list_add -id Wave.1 -after EMAC1_Rx_Client_Interface {{testbench.dut.\v5_emac_ll/rx_good_frame_1_i}}
gui_list_add -id Wave.1 -after EMAC1_Rx_Client_Interface {{testbench.dut.\v5_emac_ll/rx_bad_frame_1_i}}
gui_list_add -id Wave.1 -after EMAC1_Flow_Control {{testbench.pause_val_1}}
gui_list_add -id Wave.1 -after EMAC1_Flow_Control {{testbench.pause_req_1}}
gui_list_add -id Wave.1 -after EMAC1_Tx_GMII_MII_Interface {{testbench.gmii_tx_clk_1} {testbench.gmii_txd_1} {testbench.gmii_tx_en_1} {testbench.gmii_tx_er_1}}
gui_list_add -id Wave.1 -after EMAC1_Rx_GMII_MII_Interface {{testbench.gmii_rx_clk_1} {testbench.gmii_rxd_1} {testbench.gmii_rx_dv_1} {testbench.gmii_rx_er_1}}

gui_list_add -id Wave.1 -after Test_semaphores {{testbench.emac1_configuration_busy} {testbench.emac1_monitor_finished_1g} {testbench.emac1_monitor_finished_100m} {testbench.emac1_monitor_finished_10m}}
gui_zoom -window Wave.1 -full
