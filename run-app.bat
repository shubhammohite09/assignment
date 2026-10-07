@echo off
cd /d "%~dp0"
echo Starting backend (port 8080) and frontend (port 5173) in two windows...
start "Backend" cmd /k "cd backend && mvnw.cmd spring-boot:run"
start "Frontend" cmd /k "cd frontend && npm install && npm run dev"
echo Waiting for servers, then opening the browser...
timeout /t 40 /nobreak >nul
start http://localhost:5173
