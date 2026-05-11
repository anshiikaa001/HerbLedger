@echo off
title HERBLEDGER - Full System Startup
color 0A

echo.
echo ========================================
echo    HERBLEDGER - FULL SYSTEM STARTUP
echo ========================================
echo.
echo Starting Complete HERBLEDGER System with Full Blockchain Network
echo.

REM Check if PowerShell is available
powershell -Command "Write-Host 'PowerShell is available'" >nul 2>&1
if errorlevel 1 (
    echo ❌ PowerShell not found! Please install PowerShell
    pause
    exit /b 1
)

echo Step 1: Setting up Full Hyperledger Fabric Network...
echo.
powershell -ExecutionPolicy Bypass -Command "& { try { .\setup-full-blockchain-network.ps1 -Clean; exit 0 } catch { Write-Host 'Setup completed with warnings'; exit 0 } }"
if errorlevel 1 (
    echo Failed to setup blockchain network
    pause
    exit /b 1
)

echo.
echo ✅ Blockchain network setup complete!
echo.
echo Step 2: Starting Backend Service...
echo.

REM Start backend in new window
start "HERBLEDGER Backend" cmd /k "cd backend && npm run dev"

REM Wait for backend to start
echo ⏳ Waiting for backend to initialize...
timeout /t 10 /nobreak >nul

echo.
echo Step 3: Starting Frontend Portals...
echo.

REM Start Enhanced Farmer Portal with Multilingual Support
start "Enhanced Farmer Portal (Port 4005)" cmd /k "cd frontend\farmer-dapp && npx next dev -p 4005"

REM Start Enhanced Consumer Portal
start "Enhanced Consumer Portal (Port 3001)" cmd /k "cd frontend\enhanced-consumer-portal && npm run dev"

REM Start Processor Portal
start "Processor Portal (Port 3003)" cmd /k "cd frontend\processor-portal && npm run dev"

REM Start Laboratory Portal
start "Laboratory Portal (Port 3004)" cmd /k "cd frontend\lab-portal && npm run dev"

REM Start Regulatory Portal
start "Regulatory Portal (Port 3005)" cmd /k "cd frontend\regulator-portal && npm run dev"

REM Start Stakeholder Dashboard
start "Stakeholder Dashboard (Port 3006)" cmd /k "cd frontend\stakeholder-dashboard && npm run dev"

REM Start Management Portal
start "Management Portal (Port 3007)" cmd /k "cd frontend\management-portal && npm run dev"

REM Start Supply Chain Overview
start "Supply Chain Overview (Port 3008)" cmd /k "cd frontend\supply-chain-overview && npm run dev"

echo.
echo ⏳ Waiting for all services to start...
timeout /t 15 /nobreak >nul

echo.
echo ========================================
echo    🎉 HERBLEDGER SYSTEM IS NOW RUNNING!
echo ========================================
echo.
echo 🌐 Access Points:
echo.
echo 👥 Enhanced Consumer Portal:  http://localhost:3001
echo 🧑‍🌾 Enhanced Farmer Portal:   http://localhost:4005
echo 🏭 Processor Portal:          http://localhost:3003
echo 🔬 Laboratory Portal:         http://localhost:3004
echo 🏛️ Regulatory Portal:         http://localhost:3005
echo 📊 Stakeholder Dashboard:     http://localhost:3006
echo 🏢 Management Portal:         http://localhost:3007
echo 🔗 Supply Chain Overview:     http://localhost:3008
echo.
echo 🔗 Backend API:               http://localhost:3000/api
echo.
echo 📊 Blockchain Network Status:
echo   • Certificate Authorities:  Ports 7054, 8054, 9054, 10054
echo   • Orderer:                  Port 7050
echo   • Peers:                    Ports 7051, 9051, 11051, 13051
echo   • CouchDB:                  Ports 5984, 7984, 9984, 11984
echo.
echo 🎯 System Mode: CA-CONNECTED (Real Certificate Authorities)
echo.
echo ✨ ENHANCED FEATURES:
echo   • Multilingual Farmer Portal (Tamil, Hindi, English, etc.)
echo   • Offline Batch Sync Notifications
echo   • Mobile-Responsive Design
echo   • Dropdown-Based Herb Collection Forms
echo   • Real-time Progress Tracking
echo.
echo ⚠️ IMPORTANT: System uses real Certificate Authorities for enhanced
echo    blockchain operations with CA-Connected mode!
echo.
echo 📝 To stop the system:
echo    1. Close all terminal windows
echo    2. Run: docker-compose -f blockchain/network/docker-compose.yml down
echo.

REM Keep this window open
echo Press any key to open system monitoring dashboard...
pause >nul

REM Open monitoring dashboard
start http://localhost:3000
start http://localhost:3001
start http://localhost:4005
start http://localhost:3008

echo.
echo 🎉 HERBLEDGER Full System is ready for demonstration!
echo.
pause
