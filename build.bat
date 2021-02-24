@echo off 

:: Fetch folder used to build documentation
xcopy /s /i /Y  "../GIT/build_tools" "build_tools"

:: Delete README if exists 
IF EXIST README.md DEL /F README.md 

:: Create new README
copy ?-*.md README.md

:: Add dependency for webpage to assets folder
mkdir assets
xcopy /s /i /Y  "../GIT/build_tools/assets" "assets"


:: Build documentation without pandoc pre-installed
cd build_tools/pandoc
pandoc.exe ../../README.md  --template ../../build_tools/template/template.html --toc -B ../../build_tools/template/nav.html --metadata-file ../../APPLICATION-DATA.yalm -o ../../GUIDA.html
cd ../../
 
:: Build documentation with pandoc pre-installed
:: pandoc README.md  --template build_tools/template/template.html --toc -B build_tools/template/nav.html --metadata-file metadata.yalm -o index.html


:: Remove files used for building
rd /s /q build_tools


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
	
	

