:: Documentation Builder Ver 1.0
@echo off  

echo ----------------------------------------------------------------------------------------------
echo DOCUMENTATION BUILDER V1.0
echo ----------------------------------------------------------------------------------------------

:: Get parent folder name 
setlocal enableextensions disabledelayedexpansion
for %%a in ("%~dp0\.") do set "parent=%%~nxa"

:: Prompt user for option choice
set move_readme=false
set create_zip=false

SET /P DOYOUWANT=Move README.md and LICENCE to parent folder ([Y]/N)?
IF /I "%DOYOUWANT%" EQU "N" GOTO END
	set move_readme=true
	echo ----------------------------------------------------------------------------------------------

	echo Actual parent folder name is %parent% 
	echo This will be used to address resources from inner folders.
	echo To prevent broken links consider to change it before building documentation
	echo ----------------------------------------------------------------------------------------------
	SET /P DOYOUWANT=Press N to exit Y to continue(Y/[N])?
	IF /I "%DOYOUWANT%" NEQ "Y" ( exit )  
:END
echo ----------------------------------------------------------------------------------------------
echo Markdown source files can be zipped to build.zip after the building process has finished.
SET /P AREYOUSURE=Archive markdown files after building (Y/[N])?
IF /I "%AREYOUSURE%" EQU "Y" (set create_zip=true)
echo ----------------------------------------------------------------------------------------------
echo THE FOLLOWING OPTIONS ARE SELECTED :
echo building folder : %parent%
echo move readme to parent directory : %move_readme%
echo archive markdown source to build.zip after building : %create_zip%
SET /P DOYOUWANT=Continue with this settings ([Y]/N)?
IF /I "%DOYOUWANT%" NEQ "Y" ( exit )  
echo ----------------------------------------------------------------------------------------------
echo Fetch data that will be used for building if not present locally
:: Fetch data that will be used to build documentation if not available locally 
IF EXIST ../../doc-build  ECHO Data are available locally - no need to git clone  
IF EXIST ../../doc-build  xcopy /s /i /Y  "../../doc-build" "doc-build"
IF NOT EXIST ../../doc-build git clone https://github.com/rexroth-unofficial-ita/doc-build.git
echo ----------------------------------------------------------------------------------------------
echo delete old README.md if exists
:: Delete old README if exists 
IF EXIST README.md DEL /F README.md 
echo ----------------------------------------------------------------------------------------------
echo create new README.md
::copy ?-*.md README.md
:: Create new README by joining all READMEs with 3 additional lines on top of each.
FOR %%i IN (?-*.md) DO ECHO. >> README.md && ECHO. >> README.md && ECHO. >> README.md && type %%i >> README.md 

echo ----------------------------------------------------------------------------------------------
echo add dependencies for documentation 
:: Add dependencies for ( js and css ) for html to work
mkdir assets
xcopy /s /i /Y  "doc-build/assets" "assets"
echo ----------------------------------------------------------------------------------------------
echo Documentation Building ......  
:: Build documentation without pandoc pre-installed
cd doc-build/pandoc
powershell Expand-Archive -LiteralPath "pandoc.zip" -DestinationPath "../pandoc" -Force
pandoc.exe ../../README.md  --template ../../doc-build/template/template.html --toc -B ../../doc-build/template/nav.html --metadata-file ../../APPLICATION-DATA.yaml -o ../../GUIDA.html
cd ../../
echo ----------------------------------------------------------------------------------------------
IF /I "%move_readme%" NEQ "true" goto END
	:: This part will move README.md to parent folder after having corrected images path.
	echo moving README.md and LICENCE to parent folder
	setlocal enableextensions disabledelayedexpansion
	for %%a in ("%~dp0\.") do set "parent=%%~nxa"
	for /f "delims=" %%i in ('type "README.md" ^& break ^> "README.md" ') do (
		set "line=%%i"
		setlocal enabledelayedexpansion
		>>"../README.md" echo(!line:assets/=%parent%/assets/!
		endlocal
	)
	copy /Y  "LICENSE.md" "../LICENSE.txt"
	del /F README.md
	::del /F LICENSE.md
	
:END
echo ----------------------------------------------------------------------------------------------
IF /I "%create_zip%" NEQ "true" goto END 
	:: Archive md files and delete them
	echo Archiving markdown files to backup.zip
	powershell Compress-Archive "*.md" -DestinationPath "backup.zip"
	del *.md
:END
echo ----------------------------------------------------------------------------------------------
:: Remove files used for building
echo Removing files used for building 
rd /s /q doc-build
rd /s /q .git
echo ----------------------------------------------------------------------------------------------
echo The documentation has been succefully built
echo ctrl-c to exit
echo ----------------------------------------------------------------------------------------------

timeout 10



