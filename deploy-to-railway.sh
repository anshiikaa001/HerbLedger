#!/bin/bash

# HERBLEDGER - Railway Deployment Script
# This script deploys the complete HERBLEDGER system to Railway

echo "🚀 HERBLEDGER - Railway Deployment"
echo "=================================="

# Check if Railway CLI is installed
if ! command -v railway &> /dev/null; then
    echo "❌ Railway CLI not found. Installing..."
    npm install -g @railway/cli
fi

# Login to Railway (if not already logged in)
echo "🔐 Logging into Railway..."
railway login

# Create new Railway project
echo "📦 Creating Railway project..."
railway init

# Set project name
railway variables set PROJECT_NAME="herbledger-complete"

# Deploy Backend Service
echo "🔧 Deploying Backend Service..."
railway up --service backend --dockerfile Dockerfile.backend

# Set backend environment variables
railway variables set NODE_ENV=production --service backend
railway variables set PORT=3000 --service backend
railway variables set BLOCKCHAIN_MODE=simulated --service backend
railway variables set CORS_ORIGIN="*" --service backend

# Deploy Farmer Portal
echo "🧑‍🌾 Deploying Farmer Portal..."
railway up --service farmer-portal --dockerfile Dockerfile.farmer

# Set farmer portal environment variables
railway variables set NODE_ENV=production --service farmer-portal
railway variables set NEXT_PUBLIC_API_URL="https://herbledger-backend.railway.app" --service farmer-portal

# Deploy Consumer Portal
echo "👥 Deploying Consumer Portal..."
railway up --service consumer-portal --dockerfile Dockerfile.consumer

# Set consumer portal environment variables
railway variables set NODE_ENV=production --service consumer-portal
railway variables set NEXT_PUBLIC_API_URL="https://herbledger-backend.railway.app" --service consumer-portal

# Deploy other portals
PORTALS=("processor:3003" "lab:3004" "regulator:3005" "stakeholder:3006" "management:3007" "supply-chain:3008")

for portal in "${PORTALS[@]}"; do
    IFS=':' read -r name port <<< "$portal"
    echo "🏭 Deploying ${name^} Portal..."
    
    # Copy generic Dockerfile to portal directory
    cp Dockerfile.generic "frontend/${name}-portal/"
    
    # Deploy portal
    cd "frontend/${name}-portal"
    railway up --service "${name}-portal"
    
    # Set environment variables
    railway variables set NODE_ENV=production --service "${name}-portal"
    railway variables set PORT="$port" --service "${name}-portal"
    railway variables set NEXT_PUBLIC_API_URL="https://herbledger-backend.railway.app" --service "${name}-portal"
    
    cd ../..
done

echo ""
echo "✅ Deployment Complete!"
echo ""
echo "🌐 Your HERBLEDGER System URLs:"
echo "================================"
echo "🔗 Backend API:              https://herbledger-backend.railway.app"
echo "👥 Consumer Portal:          https://herbledger-consumer.railway.app"
echo "🧑‍🌾 Farmer Portal:           https://herbledger-farmer.railway.app"
echo "🏭 Processor Portal:         https://herbledger-processor.railway.app"
echo "🔬 Lab Portal:               https://herbledger-lab.railway.app"
echo "🏛️ Regulator Portal:         https://herbledger-regulator.railway.app"
echo "📊 Stakeholder Dashboard:    https://herbledger-stakeholder.railway.app"
echo "🏢 Management Portal:        https://herbledger-management.railway.app"
echo "🔗 Supply Chain Overview:    https://herbledger-supply-chain.railway.app"
echo ""
echo "🎉 Your HERBLEDGER system is now live and accessible from anywhere!"
echo ""
echo "📝 Next Steps:"
echo "1. Test all portals to ensure they're working"
echo "2. Configure custom domain (optional)"
echo "3. Set up monitoring and alerts"
echo ""
