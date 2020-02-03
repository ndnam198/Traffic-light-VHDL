@echo off
set xv_path=C:\\Xilinx\\Vivado\\2017.2\\bin
call %xv_path%/xsim traffic_light_7_tb_behav -key {Behavioral:sim_1:Functional:traffic_light_7_tb} -tclbatch traffic_light_7_tb.tcl -view A:/Documents/Code_Simul/VivadoLab/Traffic_light_2/traffic_light_6_tb_behav.wcfg -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
