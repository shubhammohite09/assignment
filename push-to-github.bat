@echo off
setlocal
cd /d "%~dp0"
where git >nul 2>nul || (echo Git is not installed. Get it from https://git-scm.com & pause & exit /b 1)

if exist ".git" (
  echo This folder is already a git repo. Committing and pushing...
  git add .
  git commit -m "Fix search, validation and frontend issues"
  git push
  pause
  exit /b 0
)

echo.
echo First create your repo on GitHub with "Use this template" (NOT fork) and make it Public.
set /p REPO=Paste your new repo URL (https://github.com/you/name.git): 
if "%REPO%"=="" (echo No URL given. & pause & exit /b 1)

set TARGET=%~dp0..\submission-repo
if exist "%TARGET%" (echo Folder "%TARGET%" already exists. Delete or rename it first. & pause & exit /b 1)

git clone "%REPO%" "%TARGET%" || (echo Clone failed. Check the URL and your GitHub login. & pause & exit /b 1)
robocopy "%~dp0." "%TARGET%" /E /XD node_modules target dist .git /NFL /NDL /NJH /NJS >nul
cd /d "%TARGET%"
git add .
git commit -m "Fix search, validation and frontend issues"
git push
echo.
echo Done. Open your repo in the browser and check the files, NOTES.md and handwritten/ folder.
pause
