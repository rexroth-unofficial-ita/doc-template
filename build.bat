@echo off 
:: Ver 1.1

:: Fetch data that will be used to build documentation
git clone https://github.com/rexroth-unofficial-ita/doc-build.git

:: Delete old README if exists 
IF EXIST README.md DEL /F README.md 

:: Create new README
copy ?-*.md README.md

:: Add dependency for ( js and css ) for html to work
mkdir assets
xcopy /s /i /Y  "doc-build/assets" "assets"

:: Build documentation without pandoc pre-installed
cd doc-build/pandoc
powershell Expand-Archive -LiteralPath "pandoc.zip" -DestinationPath "../pandoc" -Force
pandoc.exe ../../README.md  --template ../../doc-build/template/template.html --toc -B ../../doc-build/template/nav.html --metadata-file ../../APPLICATION-DATA.yalm -o ../../GUIDA.html
cd ../../


::setlocal
::SET /P AREYOUSURE=Move README.md to parent folder ([Y]/N)?
::IF /I "%AREYOUSURE%" EQU "N" GOTO END
	:: This part will move README.md to parent folder after having corrected images path.
	setlocal enableextensions disabledelayedexpansion
	for %%a in ("%~dp0\.") do set "parent=%%~nxa"
	for /f "delims=" %%i in ('type "README.md" ^& break ^> "README.md" ') do (
		set "line=%%i"
		setlocal enabledelayedexpansion
		>>"../README.md" echo(!line:assets=%parent%/assets!
		endlocal
	)
	del /F README.md
:::END

::setlocal
::SET /P AREYOUSURE=Archive readme files (Y/[N])?
::IF /I "%AREYOUSURE%" NEQ "Y" GOTO END
	:: Archive md files and delete them
	powershell Compress-Archive "*.md" -DestinationPath "backup.zip"
	del *.md
:::END

				
:: Remove files used for building
rd /s /q doc-build
rd /s /q .git
dir
