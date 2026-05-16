#!/usr/bin/env powershell
#
# HERBLEDGER - Enroll Users and Generate Certificates
#

Write-Host "🔐 Enrolling users and generating certificates..." -ForegroundColor Cyan

# Function to create directory if it doesn't exist
function New-DirectoryIfNotExists {
    param([string]$Path)
    if (!(Test-Path $Path)) {
        New-Item -ItemType Directory -Path $Path -Force | Out-Null
    }
}

# Enroll admin and users for Farmers organization
Write-Host "Enrolling Farmers organization..." -ForegroundColor Yellow

# Create directories
New-DirectoryIfNotExists "organizations/peerOrganizations/farmers.herbledger.com/users/Admin@farmers.herbledger.com"
New-DirectoryIfNotExists "organizations/peerOrganizations/farmers.herbledger.com/users/User1@farmers.herbledger.com"
New-DirectoryIfNotExists "organizations/peerOrganizations/farmers.herbledger.com/peers/peer0.farmers.herbledger.com/msp/signcerts"
New-DirectoryIfNotExists "organizations/peerOrganizations/farmers.herbledger.com/peers/peer0.farmers.herbledger.com/msp/keystore"
New-DirectoryIfNotExists "organizations/peerOrganizations/farmers.herbledger.com/peers/peer0.farmers.herbledger.com/msp/cacerts"
New-DirectoryIfNotExists "organizations/peerOrganizations/farmers.herbledger.com/peers/peer0.farmers.herbledger.com/msp/admincerts"
New-DirectoryIfNotExists "organizations/peerOrganizations/farmers.herbledger.com/peers/peer0.farmers.herbledger.com/tls"

# Register and enroll users using fabric-ca-client inside the CA container
Write-Host "Registering peer0 for farmers..." -ForegroundColor Green
docker exec ca.farmers.herbledger.com fabric-ca-client register --caname ca-farmers --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles /etc/hyperledger/fabric-ca-server/ca-cert.pem

Write-Host "Registering user1 for farmers..." -ForegroundColor Green
docker exec ca.farmers.herbledger.com fabric-ca-client register --caname ca-farmers --id.name user1 --id.secret user1pw --id.type client --tls.certfiles /etc/hyperledger/fabric-ca-server/ca-cert.pem

Write-Host "Registering admin for farmers..." -ForegroundColor Green
docker exec ca.farmers.herbledger.com fabric-ca-client register --caname ca-farmers --id.name farmersadmin --id.secret farmersadminpw --id.type admin --tls.certfiles /etc/hyperledger/fabric-ca-server/ca-cert.pem

# Enroll peer0
Write-Host "Enrolling peer0 for farmers..." -ForegroundColor Green
docker exec ca.farmers.herbledger.com fabric-ca-client enroll -u https://peer0:peer0pw@ca.farmers.herbledger.com:7054 --caname ca-farmers -M /tmp/peer0-msp --tls.certfiles /etc/hyperledger/fabric-ca-server/ca-cert.pem

# Copy certificates from container to host
Write-Host "Copying peer0 certificates..." -ForegroundColor Green
docker cp ca.farmers.herbledger.com:/tmp/peer0-msp/signcerts/. organizations/peerOrganizations/farmers.herbledger.com/peers/peer0.farmers.herbledger.com/msp/signcerts/
docker cp ca.farmers.herbledger.com:/tmp/peer0-msp/keystore/. organizations/peerOrganizations/farmers.herbledger.com/peers/peer0.farmers.herbledger.com/msp/keystore/
docker cp ca.farmers.herbledger.com:/tmp/peer0-msp/cacerts/. organizations/peerOrganizations/farmers.herbledger.com/peers/peer0.farmers.herbledger.com/msp/cacerts/

# Enroll TLS for peer0
Write-Host "Enrolling TLS for peer0..." -ForegroundColor Green
docker exec ca.farmers.herbledger.com fabric-ca-client enroll -u https://peer0:peer0pw@ca.farmers.herbledger.com:7054 --caname ca-farmers -M /tmp/peer0-tls --enrollment.profile tls --csr.hosts peer0.farmers.herbledger.com --csr.hosts localhost --tls.certfiles /etc/hyperledger/fabric-ca-server/ca-cert.pem

# Copy TLS certificates
docker cp ca.farmers.herbledger.com:/tmp/peer0-tls/. organizations/peerOrganizations/farmers.herbledger.com/peers/peer0.farmers.herbledger.com/tls/

# Enroll admin
Write-Host "Enrolling admin for farmers..." -ForegroundColor Green
docker exec ca.farmers.herbledger.com fabric-ca-client enroll -u https://farmersadmin:farmersadminpw@ca.farmers.herbledger.com:7054 --caname ca-farmers -M /tmp/farmers-admin-msp --tls.certfiles /etc/hyperledger/fabric-ca-server/ca-cert.pem

# Copy admin certificates
docker cp ca.farmers.herbledger.com:/tmp/farmers-admin-msp/. organizations/peerOrganizations/farmers.herbledger.com/users/Admin@farmers.herbledger.com/msp/

# Do the same for Processors organization
Write-Host "Enrolling Processors organization..." -ForegroundColor Yellow

# Create directories for processors
New-DirectoryIfNotExists "organizations/peerOrganizations/processors.herbledger.com/users/Admin@processors.herbledger.com"
New-DirectoryIfNotExists "organizations/peerOrganizations/processors.herbledger.com/peers/peer0.processors.herbledger.com/msp/signcerts"
New-DirectoryIfNotExists "organizations/peerOrganizations/processors.herbledger.com/peers/peer0.processors.herbledger.com/msp/keystore"
New-DirectoryIfNotExists "organizations/peerOrganizations/processors.herbledger.com/peers/peer0.processors.herbledger.com/msp/cacerts"
New-DirectoryIfNotExists "organizations/peerOrganizations/processors.herbledger.com/peers/peer0.processors.herbledger.com/tls"

# Register users for processors
docker exec ca.processors.herbledger.com fabric-ca-client register --caname ca-processors --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles /etc/hyperledger/fabric-ca-server/ca-cert.pem
docker exec ca.processors.herbledger.com fabric-ca-client register --caname ca-processors --id.name processorsadmin --id.secret processorsadminpw --id.type admin --tls.certfiles /etc/hyperledger/fabric-ca-server/ca-cert.pem

# Enroll peer0 for processors
docker exec ca.processors.herbledger.com fabric-ca-client enroll -u https://peer0:peer0pw@ca.processors.herbledger.com:8054 --caname ca-processors -M /tmp/peer0-msp --tls.certfiles /etc/hyperledger/fabric-ca-server/ca-cert.pem

# Copy certificates
docker cp ca.processors.herbledger.com:/tmp/peer0-msp/signcerts/. organizations/peerOrganizations/processors.herbledger.com/peers/peer0.processors.herbledger.com/msp/signcerts/
docker cp ca.processors.herbledger.com:/tmp/peer0-msp/keystore/. organizations/peerOrganizations/processors.herbledger.com/peers/peer0.processors.herbledger.com/msp/keystore/
docker cp ca.processors.herbledger.com:/tmp/peer0-msp/cacerts/. organizations/peerOrganizations/processors.herbledger.com/peers/peer0.processors.herbledger.com/msp/cacerts/

# Enroll TLS for processors peer0
docker exec ca.processors.herbledger.com fabric-ca-client enroll -u https://peer0:peer0pw@ca.processors.herbledger.com:8054 --caname ca-processors -M /tmp/peer0-tls --enrollment.profile tls --csr.hosts peer0.processors.herbledger.com --csr.hosts localhost --tls.certfiles /etc/hyperledger/fabric-ca-server/ca-cert.pem

# Copy TLS certificates
docker cp ca.processors.herbledger.com:/tmp/peer0-tls/. organizations/peerOrganizations/processors.herbledger.com/peers/peer0.processors.herbledger.com/tls/

# Enroll admin for processors
docker exec ca.processors.herbledger.com fabric-ca-client enroll -u https://processorsadmin:processorsadminpw@ca.processors.herbledger.com:8054 --caname ca-processors -M /tmp/processors-admin-msp --tls.certfiles /etc/hyperledger/fabric-ca-server/ca-cert.pem

# Copy admin certificates
docker cp ca.processors.herbledger.com:/tmp/processors-admin-msp/. organizations/peerOrganizations/processors.herbledger.com/users/Admin@processors.herbledger.com/msp/

# Generate orderer certificates using farmers CA
Write-Host "Generating orderer certificates..." -ForegroundColor Yellow

# Create orderer directories
New-DirectoryIfNotExists "organizations/ordererOrganizations/herbledger.com/orderers/orderer.herbledger.com/msp/signcerts"
New-DirectoryIfNotExists "organizations/ordererOrganizations/herbledger.com/orderers/orderer.herbledger.com/msp/keystore"
New-DirectoryIfNotExists "organizations/ordererOrganizations/herbledger.com/orderers/orderer.herbledger.com/msp/cacerts"
New-DirectoryIfNotExists "organizations/ordererOrganizations/herbledger.com/orderers/orderer.herbledger.com/tls"

# Register orderer
docker exec ca.farmers.herbledger.com fabric-ca-client register --caname ca-farmers --id.name orderer --id.secret ordererpw --id.type orderer --tls.certfiles /etc/hyperledger/fabric-ca-server/ca-cert.pem

# Enroll orderer
docker exec ca.farmers.herbledger.com fabric-ca-client enroll -u https://orderer:ordererpw@ca.farmers.herbledger.com:7054 --caname ca-farmers -M /tmp/orderer-msp --tls.certfiles /etc/hyperledger/fabric-ca-server/ca-cert.pem

# Copy orderer certificates
docker cp ca.farmers.herbledger.com:/tmp/orderer-msp/signcerts/. organizations/ordererOrganizations/herbledger.com/orderers/orderer.herbledger.com/msp/signcerts/
docker cp ca.farmers.herbledger.com:/tmp/orderer-msp/keystore/. organizations/ordererOrganizations/herbledger.com/orderers/orderer.herbledger.com/msp/keystore/
docker cp ca.farmers.herbledger.com:/tmp/orderer-msp/cacerts/. organizations/ordererOrganizations/herbledger.com/orderers/orderer.herbledger.com/msp/cacerts/

# Enroll TLS for orderer
docker exec ca.farmers.herbledger.com fabric-ca-client enroll -u https://orderer:ordererpw@ca.farmers.herbledger.com:7054 --caname ca-farmers -M /tmp/orderer-tls --enrollment.profile tls --csr.hosts orderer.herbledger.com --csr.hosts localhost --tls.certfiles /etc/hyperledger/fabric-ca-server/ca-cert.pem

# Copy orderer TLS certificates
docker cp ca.farmers.herbledger.com:/tmp/orderer-tls/. organizations/ordererOrganizations/herbledger.com/orderers/orderer.herbledger.com/tls/

Write-Host "Certificate enrollment completed!" -ForegroundColor Green
Write-Host "You can now restart the blockchain network" -ForegroundColor Cyan
