@echo off
set main=..\
set _7z="D:\Program Files\7-Zip\7z.exe"

:: 复制插件文件
copy %main%\plugin\LinGe_VScripts.vdf addons\LinGe_VScripts.vdf
copy %main%\plugin\LinGe_VScripts\LinGe_VScripts.dll addons\LinGe_VScripts\LinGe_VScripts.dll
copy %main%\plugin\LinGe_VScripts\LinGe_VScripts.so addons\LinGe_VScripts\LinGe_VScripts.so

:: 打包 zip
del LinGe_VScripts.zip
%_7z% a -tzip LinGe_VScripts.zip addons

pause