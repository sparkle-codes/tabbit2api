@echo off
cd /d "%~dp0tabbit2api"
title Tabbit2API Server
echo ========================================
echo   Tabbit2API Server
echo   URL:  http://localhost:8800
echo   Admin: http://localhost:8800/admin
echo   Press Ctrl+C to stop
echo ========================================
echo.
python tabbit2api.py
pause
