@echo off
echo Starting YATRA AI backend...
start "YATRA Backend" cmd /k "cd /d C:\Users\karnv\develop\yatra_ai\backend && node index.js"

timeout /t 3 /nobreak >nul

echo Starting YATRA Flutter website...
start "YATRA Flutter" cmd /k "cd /d C:\Users\karnv\develop\yatra_ai && flutter run -d chrome"

echo.
echo YATRA AI is starting...
pause
