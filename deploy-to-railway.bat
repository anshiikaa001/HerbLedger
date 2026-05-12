@echo off
title HERBLEDGER - Railway Deployment
color 0A

echo.
echo 🚀 HERBLEDGER - Railway Deployment
echo ==================================
echo.

REM Check if Railway CLI is installed
where railway >nul 2>&1
if errorlevel 1 (
    echo ❌ Railway CLI not found. Installing...
    npm install -g @railway/cli
    if errorlevel 1 (
        echo ❌ Failed to install Railway CLI
        pause
        exit /b 1
    )
)

echo ✅ Railway CLI found
echo.

REM Login to Railway
echo 🔐 Logging into Railway...
railway login
if errorlevel 1 (
    echo ❌ Failed to login to Railway
    pause
    exit /b 1
)

echo ✅ Logged into Railway
echo.

REM Initialize Railway project
echo 📦 Creating Railway project...
railway init herbledger-complete
if errorlevel 1 (
    echo ❌ Failed to create Railway project
    pause
    exit /b 1
)

echo ✅ Railway project created
echo.

REM Deploy Backend Service
echo 🔧 Deploying Backend Service...
railway up --detach
if errorlevel 1 (
    echo ❌ Failed to deploy backend
    pause
    exit /b 1
)

echo ✅ Backend deployed successfully
echo.

echo 🌐 Getting deployment URLs...
railway status

echo.
echo ========================================
echo    🎉 DEPLOYMENT COMPLETE!
echo ========================================
echo.
echo Your HERBLEDGER system is now live!
echo.
echo 📝 Next Steps:
echo 1. Check Railway dashboard for your URLs
echo 2. Test all services
echo 3. Configure custom domain (optional)
echo.
echo 🔗 Railway Dashboard: https://railway.app/dashboard
echo.

pause
