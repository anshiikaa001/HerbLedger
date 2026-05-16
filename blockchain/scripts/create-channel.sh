#!/bin/bash
#
# HERBLEDGER - Channel Creation Script
# This script creates the blockchain channel for the full network
#

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

function print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

function print_info() {
    echo -e "${BLUE}ℹ️ $1${NC}"
}

function print_warning() {
    echo -e "${YELLOW}⚠️ $1${NC}"
}

function print_error() {
    echo -e "${RED}❌ $1${NC}"
}

function print_step() {
    echo -e "${BLUE}🔄 $1${NC}"
}

echo "🚀 HERBLEDGER - Channel Creation"
echo "==============================="

# Set environment variables
export FABRIC_CFG_PATH=${PWD}/../network
export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/../organizations/ordererOrganizations/herbledger.com/orderers/orderer.herbledger.com/msp/tlscacerts/tlsca.herbledger.com-cert.pem

# Channel details
CHANNEL_NAME="herb-channel"
DELAY="3"
MAX_RETRY="5"
VERBOSE="false"

print_step "Step 1: Generate channel configuration transaction..."

# Create channel-artifacts directory if it doesn't exist
mkdir -p ../channel-artifacts

# Generate channel configuration transaction
configtxgen -profile HerbChannel \
    -outputCreateChannelTx ../channel-artifacts/${CHANNEL_NAME}.tx \
    -channelID $CHANNEL_NAME

if [ $? -eq 0 ]; then
    print_success "Channel configuration transaction generated"
else
    print_error "Failed to generate channel configuration transaction"
    exit 1
fi

print_step "Step 2: Generate anchor peer transactions..."

# Generate anchor peer transactions for each organization
configtxgen -profile HerbChannel \
    -outputAnchorPeersUpdate ../channel-artifacts/FarmersMSPanchors.tx \
    -channelID $CHANNEL_NAME \
    -asOrg FarmersMSP

configtxgen -profile HerbChannel \
    -outputAnchorPeersUpdate ../channel-artifacts/ProcessorsMSPanchors.tx \
    -channelID $CHANNEL_NAME \
    -asOrg ProcessorsMSP

configtxgen -profile HerbChannel \
    -outputAnchorPeersUpdate ../channel-artifacts/LabsMSPanchors.tx \
    -channelID $CHANNEL_NAME \
    -asOrg LabsMSP

configtxgen -profile HerbChannel \
    -outputAnchorPeersUpdate ../channel-artifacts/RegulatorsMSPanchors.tx \
    -channelID $CHANNEL_NAME \
    -asOrg RegulatorsMSP

if [ $? -eq 0 ]; then
    print_success "Anchor peer transactions generated"
else
    print_error "Failed to generate anchor peer transactions"
    exit 1
fi

print_step "Step 3: Create channel..."

# Set environment for Farmers peer
export CORE_PEER_LOCALMSPID="FarmersMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/../organizations/peerOrganizations/farmers.herbledger.com/peers/peer0.farmers.herbledger.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/../organizations/peerOrganizations/farmers.herbledger.com/users/Admin@farmers.herbledger.com/msp
export CORE_PEER_ADDRESS=localhost:7051

# Create the channel
peer channel create \
    -o localhost:7050 \
    -c $CHANNEL_NAME \
    --ordererTLSHostnameOverride orderer.herbledger.com \
    -f ../channel-artifacts/${CHANNEL_NAME}.tx \
    --outputBlock ../channel-artifacts/${CHANNEL_NAME}.block \
    --tls \
    --cafile $ORDERER_CA

if [ $? -eq 0 ]; then
    print_success "Channel created successfully"
else
    print_error "Failed to create channel"
    exit 1
fi

print_step "Step 4: Join Farmers peer to channel..."

# Join Farmers peer to channel
peer channel join -b ../channel-artifacts/${CHANNEL_NAME}.block

if [ $? -eq 0 ]; then
    print_success "Farmers peer joined channel"
else
    print_error "Failed to join Farmers peer to channel"
    exit 1
fi

print_step "Step 5: Join Processors peer to channel..."

# Set environment for Processors peer
export CORE_PEER_LOCALMSPID="ProcessorsMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/../organizations/peerOrganizations/processors.herbledger.com/peers/peer0.processors.herbledger.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/../organizations/peerOrganizations/processors.herbledger.com/users/Admin@processors.herbledger.com/msp
export CORE_PEER_ADDRESS=localhost:9051

# Join Processors peer to channel
peer channel join -b ../channel-artifacts/${CHANNEL_NAME}.block

if [ $? -eq 0 ]; then
    print_success "Processors peer joined channel"
else
    print_error "Failed to join Processors peer to channel"
    exit 1
fi

print_step "Step 6: Join Labs peer to channel..."

# Set environment for Labs peer
export CORE_PEER_LOCALMSPID="LabsMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/../organizations/peerOrganizations/labs.herbledger.com/peers/peer0.labs.herbledger.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/../organizations/peerOrganizations/labs.herbledger.com/users/Admin@labs.herbledger.com/msp
export CORE_PEER_ADDRESS=localhost:11051

# Join Labs peer to channel
peer channel join -b ../channel-artifacts/${CHANNEL_NAME}.block

if [ $? -eq 0 ]; then
    print_success "Labs peer joined channel"
else
    print_error "Failed to join Labs peer to channel"
    exit 1
fi

print_step "Step 7: Join Regulators peer to channel..."

# Set environment for Regulators peer
export CORE_PEER_LOCALMSPID="RegulatorsMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/../organizations/peerOrganizations/regulators.herbledger.com/peers/peer0.regulators.herbledger.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/../organizations/peerOrganizations/regulators.herbledger.com/users/Admin@regulators.herbledger.com/msp
export CORE_PEER_ADDRESS=localhost:13051

# Join Regulators peer to channel
peer channel join -b ../channel-artifacts/${CHANNEL_NAME}.block

if [ $? -eq 0 ]; then
    print_success "Regulators peer joined channel"
else
    print_error "Failed to join Regulators peer to channel"
    exit 1
fi

print_step "Step 8: Update anchor peers..."

# Update anchor peer for Farmers
export CORE_PEER_LOCALMSPID="FarmersMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/../organizations/peerOrganizations/farmers.herbledger.com/peers/peer0.farmers.herbledger.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/../organizations/peerOrganizations/farmers.herbledger.com/users/Admin@farmers.herbledger.com/msp
export CORE_PEER_ADDRESS=localhost:7051

peer channel update \
    -o localhost:7050 \
    --ordererTLSHostnameOverride orderer.herbledger.com \
    -c $CHANNEL_NAME \
    -f ../channel-artifacts/FarmersMSPanchors.tx \
    --tls \
    --cafile $ORDERER_CA

# Update anchor peer for Processors
export CORE_PEER_LOCALMSPID="ProcessorsMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/../organizations/peerOrganizations/processors.herbledger.com/peers/peer0.processors.herbledger.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/../organizations/peerOrganizations/processors.herbledger.com/users/Admin@processors.herbledger.com/msp
export CORE_PEER_ADDRESS=localhost:9051

peer channel update \
    -o localhost:7050 \
    --ordererTLSHostnameOverride orderer.herbledger.com \
    -c $CHANNEL_NAME \
    -f ../channel-artifacts/ProcessorsMSPanchors.tx \
    --tls \
    --cafile $ORDERER_CA

# Update anchor peer for Labs
export CORE_PEER_LOCALMSPID="LabsMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/../organizations/peerOrganizations/labs.herbledger.com/peers/peer0.labs.herbledger.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/../organizations/peerOrganizations/labs.herbledger.com/users/Admin@labs.herbledger.com/msp
export CORE_PEER_ADDRESS=localhost:11051

peer channel update \
    -o localhost:7050 \
    --ordererTLSHostnameOverride orderer.herbledger.com \
    -c $CHANNEL_NAME \
    -f ../channel-artifacts/LabsMSPanchors.tx \
    --tls \
    --cafile $ORDERER_CA

# Update anchor peer for Regulators
export CORE_PEER_LOCALMSPID="RegulatorsMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/../organizations/peerOrganizations/regulators.herbledger.com/peers/peer0.regulators.herbledger.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/../organizations/peerOrganizations/regulators.herbledger.com/users/Admin@regulators.herbledger.com/msp
export CORE_PEER_ADDRESS=localhost:13051

peer channel update \
    -o localhost:7050 \
    --ordererTLSHostnameOverride orderer.herbledger.com \
    -c $CHANNEL_NAME \
    -f ../channel-artifacts/RegulatorsMSPanchors.tx \
    --tls \
    --cafile $ORDERER_CA

if [ $? -eq 0 ]; then
    print_success "Anchor peers updated successfully"
else
    print_warning "Some anchor peer updates may have failed, but channel should still work"
fi

print_step "Step 9: List channels..."

# List channels to verify
peer channel list

echo ""
print_success "🎉 Channel Creation Complete!"
echo ""
print_info "Channel Details:"
echo "  • Channel Name: $CHANNEL_NAME"
echo "  • Organizations: Farmers, Processors, Labs, Regulators"
echo "  • Peers Joined: 4"
echo "  • Anchor Peers: Updated"
echo ""
print_info "The channel is now ready for chaincode deployment!"
