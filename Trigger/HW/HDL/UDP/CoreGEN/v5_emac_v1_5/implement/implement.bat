
rem Clean up the results directory
rmdir /S /Q results
mkdir results

echo 'Synthesizing sample design with XST';
xst -ifn xst.scr
copy /B v5_emac_v1_5_example_design.ngc .\results\

rem  Copy the constraints files generated by Coregen
echo 'Copying files from constraints directory to results directory'
copy /B ..\example_design\v5_emac_v1_5_example_design.ucf results\

cd results

echo 'Running ngdbuild'
ngdbuild -uc v5_emac_v1_5_example_design.ucf v5_emac_v1_5_example_design.ngc v5_emac_v1_5_example_design.ngd

echo 'Running map'
map -ol high -timing v5_emac_v1_5_example_design -o mapped.ncd

echo 'Running par'
par -ol high -w mapped.ncd routed.ncd mapped.pcf

echo 'Running trce'
trce -e 10 routed -o routed mapped.pcf

echo 'Running design through bitgen'
bitgen -w routed

echo 'Running netgen to create gate level VHDL model'
netgen -ofmt vhdl -sim -dir . -pcf mapped.pcf -tm v5_emac_v1_5_example_design -w routed.ncd routed.vhd