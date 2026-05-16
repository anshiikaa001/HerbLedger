# Fix MSP Configuration for HERBLEDGER blockchain network

Write-Host "Fixing MSP configuration..." -ForegroundColor Cyan

# Create MSP config files for farmers peer
$farmersConfig = @"
NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054.pem
    OrganizationalUnitIdentifier: orderer
"@

$farmersConfig | Out-File -FilePath "organizations/peerOrganizations/farmers.herbledger.com/peers/peer0.farmers.herbledger.com/msp/config.yaml" -Encoding UTF8

# Create MSP config files for processors peer
$processorsConfig = @"
NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-8054.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-8054.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-8054.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-8054.pem
    OrganizationalUnitIdentifier: orderer
"@

$processorsConfig | Out-File -FilePath "organizations/peerOrganizations/processors.herbledger.com/peers/peer0.processors.herbledger.com/msp/config.yaml" -Encoding UTF8

# Create MSP config for orderer
$ordererConfig = @"
NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054.pem
    OrganizationalUnitIdentifier: orderer
"@

$ordererConfig | Out-File -FilePath "organizations/ordererOrganizations/herbledger.com/orderers/orderer.herbledger.com/msp/config.yaml" -Encoding UTF8

Write-Host "MSP configuration files created!" -ForegroundColor Green

# Restart the network
Write-Host "Restarting blockchain network..." -ForegroundColor Cyan
cd network
docker-compose restart

Write-Host "Network restarted!" -ForegroundColor Green
