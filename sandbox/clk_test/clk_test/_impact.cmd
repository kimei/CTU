setMode -bs
setMode -bs
setCable -port auto
Identify 
identifyMPM 
assignFile -p 1 -file "M:/MASTER/COMPET/sandbox/clk_test/clk_test/v5_emac_v1_5_example_design.bit"
Program -p 1 
setMode -bs
deleteDevice -position 1
