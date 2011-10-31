
@ECHO OFF

echo Uninstalling Civil Debate Wall
arh -uninstallAppSilent net.localprojects.CivilDebateWall

echo Downloading latest version
s3 auth AKIAIGEUVT5AUIS2ZM5A NTEbhuv9BwtSP3zBPCc/Nu6UcWmxHlQtqrXG4zEb
s3 get "cdw-deploy-mika/CDW Kiosk.exe" /nogui

echo Installing latest version
"CDW Kiosk.exe" -silent -eulaAccepted -desktopShortcut

echo Starting the Wall
for /f "delims==" %%i in ('arh -appLocation net.localprojects.CivilDebateWall') do set APP_LOCATION=%%i

rem The "CDW" prevents START from interpreting the quoted APP_LOCATIOn as a title
START "CDW" "%APP_LOCATION%"

