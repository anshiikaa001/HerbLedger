# HERBLEDGER - Setup Certificates for Blockchain Network

Write-Host "Setting up certificates for HERBLEDGER blockchain network..." -ForegroundColor Cyan

# Create necessary directories
Write-Host "Creating directory structure..." -ForegroundColor Yellow
New-Item -ItemType Directory -Path "organizations/peerOrganizations/farmers.herbledger.com/peers/peer0.farmers.herbledger.com/msp/signcerts" -Force | Out-Null
New-Item -ItemType Directory -Path "organizations/peerOrganizations/farmers.herbledger.com/peers/peer0.farmers.herbledger.com/msp/keystore" -Force | Out-Null
New-Item -ItemType Directory -Path "organizations/peerOrganizations/farmers.herbledger.com/peers/peer0.farmers.herbledger.com/msp/cacerts" -Force | Out-Null
New-Item -ItemType Directory -Path "organizations/peerOrganizations/farmers.herbledger.com/peers/peer0.farmers.herbledger.com/tls" -Force | Out-Null

New-Item -ItemType Directory -Path "organizations/peerOrganizations/processors.herbledger.com/peers/peer0.processors.herbledger.com/msp/signcerts" -Force | Out-Null
New-Item -ItemType Directory -Path "organizations/peerOrganizations/processors.herbledger.com/peers/peer0.processors.herbledger.com/msp/keystore" -Force | Out-Null
New-Item -ItemType Directory -Path "organizations/peerOrganizations/processors.herbledger.com/peers/peer0.processors.herbledger.com/msp/cacerts" -Force | Out-Null
New-Item -ItemType Directory -Path "organizations/peerOrganizations/processors.herbledger.com/peers/peer0.processors.herbledger.com/tls" -Force | Out-Null

New-Item -ItemType Directory -Path "organizations/ordererOrganizations/herbledger.com/orderers/orderer.herbledger.com/msp/signcerts" -Force | Out-Null
New-Item -ItemType Directory -Path "organizations/ordererOrganizations/herbledger.com/orderers/orderer.herbledger.com/msp/keystore" -Force | Out-Null
New-Item -ItemType Directory -Path "organizations/ordererOrganizations/herbledger.com/orderers/orderer.herbledger.com/msp/cacerts" -Force | Out-Null
New-Item -ItemType Directory -Path "organizations/ordererOrganizations/herbledger.com/orderers/orderer.herbledger.com/tls" -Force | Out-Null

# Setup Farmers organization
Write-Host "Setting up Farmers organization..." -ForegroundColor Green

# Enroll peer0 for farmers
Write-Host "Enrolling peer0 for farmers..." -ForegroundColor White
docker exec ca.farmers.herbledger.com fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 -M /tmp/peer0-msp --tls.certfiles /etc/hyperledger/fabric-ca-server/ca-cert.pem

# Copy peer certificates
Write-Host "Copying peer0 certificates..." -ForegroundColor White
docker cp ca.farmers.herbledger.com:/tmp/peer0-msp/signcerts/. organizations/peerOrganizations/farmers.herbledger.com/peers/peer0.farmers.herbledger.com/msp/signcerts/
docker cp ca.farmers.herbledger.com:/tmp/peer0-msp/keystore/. organizations/peerOrganizations/farmers.herbledger.com/peers/peer0.farmers.herbledger.com/msp/keystore/
docker cp ca.farmers.herbledger.com:/tmp/peer0-msp/cacerts/. organizations/peerOrganizations/farmers.herbledger.com/peers/peer0.farmers.herbledger.com/msp/cacerts/

# Enroll TLS for peer0
Write-Host "Enrolling TLS for peer0..." -ForegroundColor White
docker exec ca.farmers.herbledger.com fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 -M /tmp/peer0-tls --enrollment.profile tls --csr.hosts peer0.farmers.herbledger.com --csr.hosts localhost --tls.certfiles /etc/hyperledger/fabric-ca-server/ca-cert.pem

# Copy TLS certificates
docker cp ca.farmers.herbledger.com:/tmp/peer0-tls/. organizations/peerOrganizations/farmers.herbledger.com/peers/peer0.farmers.herbledger.com/tls/

# Setup Processors organization
Write-Host "Setting up Processors organization..." -ForegroundColor Green

# Enroll admin for processors CA first
docker exec ca.processors.herbledger.com fabric-ca-client enroll -u https://admin:adminpw@localhost:8054 --tls.certfiles /etc/hyperledger/fabric-ca-server/ca-cert.pem

# Register peer0 for processors
docker exec ca.processors.herbledger.com fabric-ca-client register --id.name peer0 --id.secret peer0pw --id.type peer -u https://localhost:8054 --tls.certfiles /etc/hyperledger/fabric-ca-server/ca-cert.pem

# Enroll peer0 for processors
Write-Host "Enrolling peer0 for processors..." -ForegroundColor White
docker exec ca.processors.herbledger.com fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 -M /tmp/peer0-msp --tls.certfiles /etc/hyperledger/fabric-ca-server/ca-cert.pem

# Copy peer certificates
Write-Host "Copying peer0 certificates for processors..." -ForegroundColor White
docker cp ca.processors.herbledger.com:/tmp/peer0-msp/signcerts/. organizations/peerOrganizations/processors.herbledger.com/peers/peer0.processors.herbledger.com/msp/signcerts/
docker cp ca.processors.herbledger.com:/tmp/peer0-msp/keystore/. organizations/peerOrganizations/processors.herbledger.com/peers/peer0.processors.herbledger.com/msp/keystore/
docker cp ca.processors.herbledger.com:/tmp/peer0-msp/cacerts/. organizations/peerOrganizations/processors.herbledger.com/peers/peer0.processors.herbledger.com/msp/cacerts/

# Enroll TLS for processors peer0
Write-Host "Enrolling TLS for processors peer0..." -ForegroundColor White
docker exec ca.processors.herbledger.com fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 -M /tmp/peer0-tls --enrollment.profile tls --csr.hosts peer0.processors.herbledger.com --csr.hosts localhost --tls.certfiles /etc/hyperledger/fabric-ca-server/ca-cert.pem

# Copy TLS certificates
docker cp ca.processors.herbledger.com:/tmp/peer0-tls/. organizations/peerOrganizations/processors.herbledger.com/peers/peer0.processors.herbledger.com/tls/

# Setup Orderer
Write-Host "Setting up Orderer..." -ForegroundColor Green

# Register orderer with farmers CA
docker exec ca.farmers.herbledger.com fabric-ca-client register --id.name orderer --id.secret ordererpw --id.type orderer -u https://localhost:7054 --tls.certfiles /etc/hyperledger/fabric-ca-server/ca-cert.pem

# Enroll orderer
Write-Host "Enrolling orderer..." -ForegroundColor White
docker exec ca.farmers.herbledger.com fabric-ca-client enroll -u https://orderer:ordererpw@localhost:7054 -M /tmp/orderer-msp --tls.certfiles /etc/hyperledger/fabric-ca-server/ca-cert.pem

# Copy orderer certificates
Write-Host "Copying orderer certificates..." -ForegroundColor White
docker cp ca.farmers.herbledger.com:/tmp/orderer-msp/signcerts/. organizations/ordererOrganizations/herbledger.com/orderers/orderer.herbledger.com/msp/signcerts/
docker cp ca.farmers.herbledger.com:/tmp/orderer-msp/keystore/. organizations/ordererOrganizations/herbledger.com/orderers/orderer.herbledger.com/msp/keystore/
docker cp ca.farmers.herbledger.com:/tmp/orderer-msp/cacerts/. organizations/ordererOrganizations/herbledger.com/orderers/orderer.herbledger.com/msp/cacerts/

# Enroll TLS for orderer
Write-Host "Enrolling TLS for orderer..." -ForegroundColor White
docker exec ca.farmers.herbledger.com fabric-ca-client enroll -u https://orderer:ordererpw@localhost:7054 -M /tmp/orderer-tls --enrollment.profile tls --csr.hosts orderer.herbledger.com --csr.hosts localhost --tls.certfiles /etc/hyperledger/fabric-ca-server/ca-cert.pem

# Copy orderer TLS certificates
docker cp ca.farmers.herbledger.com:/tmp/orderer-tls/. organizations/ordererOrganizations/herbledger.com/orderers/orderer.herbledger.com/tls/

Write-Host "Certificate setup completed!" -ForegroundColor Green
Write-Host "Now restarting the blockchain network..." -ForegroundColor Cyan

# Restart the network
cd network
docker-compose down
docker-compose up -d

Write-Host "Blockchain network restarted with certificates!" -ForegroundColor Green
