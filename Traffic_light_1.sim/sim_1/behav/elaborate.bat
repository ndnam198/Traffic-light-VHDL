@echo off
set xv_path=C:\\Xilinx\\Vivado\\2017.2\\bin
call %xv_path%/xelab  -wto 060d0a8452dc46169c038a58749af754 -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L secureip --snapshot traffic_light_7_tb_behav xil_defaultlib.traffic_light_7_tb -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
