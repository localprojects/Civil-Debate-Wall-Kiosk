echo Running CDW Build script...

echo Refreshing from GIT...
git reset --hard HEAD
git pull

echo Building and uploading install file...
set WORKSPACE=%HOMEPATH%\Desktop\CDWBuild\lp-cdw\air_projects

"C:\Program Files (x86)\Adobe\Adobe Flash Builder 4.5\FlashBuilderC.exe" ^
	--launcher.suppressErrors ^
	-noSplash ^
	-application org.eclipse.ant.core.antRunner ^
	-data "%WORKSPACE%"
	-file "%WORKSPACE%\cdw_kiosk\build.xml"