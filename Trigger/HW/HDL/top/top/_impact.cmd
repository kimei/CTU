setMode -bs
setMode -bs
setCable -port auto
Identify 
Identify 
identifyMPM 
assignFile -p 1 -file "M:/MASTER/COMPET/Trigger/HW/HDL/top/top/top.bit"
Program -p 1 
setCable -port auto
Program -p 1 
cutDevice -p 1
setCable -port auto
setCable -port auto
setCable -port auto
Identify 
identifyMPM 
assignFile -p 1 -file "Y:/bitfile/xilinx_v5_50.bit"
Program -p 1 
saveProjectFile -file "M:/MASTER/COMPET/Trigger/HW/HDL/top/top/top.ipf"
setMode -bs
deleteDevice -position 1
setMode -ss
setMode -sm
setMode -hw140
setMode -spi
setMode -acecf
setMode -acempm
setMode -pff
setMode -bs
