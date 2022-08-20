@echo off
setlocal EnableExtensions
for /f "tokens=* USEBACKQ" %%f in (`powershell -NoProfile -ExecutionPolicy pass "gci \"C:\\Program Files*\\QGIS*\\bin\\o4w_env.bat\" | select -f 1 | %%{$_.fullname}"`) do set QPATH=%%f
call "%QPATH%"
:uniqLoop
set "tmpFileName=%tmp%\bat~%RANDOM%.tmp"
if exist "%tmpFileName%" goto :uniqLoop
C:\WINDOWS\System32\WindowsPowerShell\v1.0\powershell.exe -NoProfile -ExecutionPolicy Pass "(gc '%~f0'|select -skip (select-string -Path '%~f0' -List '^^#').linenumber)-join\"`n\" | sc -enc utf8 %tmpFileName%"
python %tmpFileName% &pause&goto :eof

# python with qgis-env

from osgeo import gdal

print("python ver: " + str(gdal.osgeo.version_info))
print("gdal ver: "   + str(gdal.osgeo.gdal_version))
