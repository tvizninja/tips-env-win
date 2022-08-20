@for /f "tokens=* USEBACKQ" %%f in (`powershell -NoProfile -ExecutionPolicy pass "gci \"C:\\Program Files*\\QGIS*\\bin\\o4w_env.bat\" | select -f 1 | %%{$_.fullname}"`) do set QPATH=%%f
@call "%QPATH%"
@C:\WINDOWS\System32\WindowsPowerShell\v1.0\powershell.exe -NoProfile -ExecutionPolicy Pass "&([scriptblock]::create((gc '%~f0'|select -skip (select-string -Path '%~f0' -List '^^#').linenumber)-join\"`n\"))"&pause&goto :eof

# Powershell with qgis-env

gci
gdalinfo --help
