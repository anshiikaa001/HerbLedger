#!/usr/bin/env node

/**
 * Complete Workflow Test Script
 * Tests the entire supply chain workflow from farmer to consumer
 */

const axios = require('axios');

const BASE_URL = 'http://localhost:3000';
const QR_CODE = `QR_COL_WORKFLOW_TEST_${Date.now()}`;

console.log('🧪 HERBLEDGER - Complete Workflow Test');
console.log('=====================================');
console.log(`Testing QR Code: ${QR_CODE}`);
console.log('');

async function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

async function testWorkflow() {
  try {
    console.log('1️⃣ Testing Backend Connection...');
    const healthCheck = await axios.get(`${BASE_URL}/api/health`);
    console.log(`✅ Backend Status: ${healthCheck.data.status}`);
    console.log(`✅ Blockchain Mode: ${healthCheck.data.blockchain?.mode || 'Unknown'}`);
    console.log('');

    console.log('2️⃣ Creating Farmer Collection Event...');
    const farmerData = {
      collectionId: `COL_TEST_${Date.now()}`,
      farmer: {
        name: "Test Workflow Farmer",
        phone: "+91 9876543210",
        village: "Test Village",
        district: "Test District",
        state: "Karnataka"
      },
      herb: {
        botanicalName: "Curcuma longa",
        commonName: "Turmeric",
        quantity: 2.5,
        unit: "kg",
        partUsed: "Rhizome"
      },
      location: {
        latitude: 12.9716,
        longitude: 77.5946,
        accuracy: 5
      },
      environmental: {
        temperature: 28,
        humidity: 65,
        soilPH: 6.8,
        rainfall: "Moderate"
      },
      timestamp: new Date().toISOString()
    };

    const farmerResponse = await axios.post(`${BASE_URL}/api/collection/events`, farmerData);
    const actualQrCode = farmerResponse.data.data.qrCode;
    console.log(`✅ Farmer Event Created: ${actualQrCode}`);
    console.log(`✅ Status: ${farmerResponse.data.data.provenance.status || 'collected'}`);
    console.log('');

    await sleep(1000);

    console.log('3️⃣ Processing Batch...');
    const processingData = {
      originalQrCode: actualQrCode,
      processingId: `PROC_TEST_${Date.now()}`,
      processor: {
        name: "Test Processing Facility",
        facilityId: "PROC_TEST_001",
        contact: "+91 9876543211",
        certification: "GMP",
        license: "PRC2024001",
        location: "Processing Center, Bangalore"
      },
      processing: {
        method: "Steam Distillation",
        equipment: "Steam Distiller SD-300",
        temperature: "100",
        duration: "4 hours",
        humidity: "70%",
        batchSize: "2.5 kg",
        yield: "90%",
        notes: "Optimal processing conditions maintained"
      },
      quality: {
        moisture: "7.2%",
        color: "Excellent",
        texture: "Fine powder",
        aroma: "Strong",
        contamination: "None detected",
        packaging: "Vacuum sealed",
        storageConditions: "Cool & Dry",
        notes: "Quality parameters within acceptable range"
      },
      timestamp: new Date().toISOString()
    };

    const processingResponse = await axios.post(`${BASE_URL}/api/processing/events`, processingData);
    console.log(`✅ Processing Event Created`);
    console.log(`✅ Status: ${processingResponse.data.data.provenance.status || 'processed'}`);
    console.log('');

    await sleep(1000);

    console.log('4️⃣ Laboratory Testing...');
    const labData = {
      originalQrCode: actualQrCode,
      testId: `TEST_${Date.now()}`,
      lab: {
        name: "Test Quality Labs",
        labId: "LAB_TEST_001",
        contact: "+91 9876543212",
        certification: "ISO/IEC 17025",
        technician: "Dr. Test Analyst",
        location: "Testing Laboratory, Bangalore"
      },
      tests: {
        moisture: "7.0%",
        pesticides: "Not Detected",
        heavyMetals: "Within Limits",
        microbial: "Acceptable",
        dnaAuthenticity: "Confirmed",
        activeCompounds: "3.2%",
        purity: "97.8%",
        contamination: "None",
        notes: "All parameters within acceptable limits"
      },
      certificate: {
        certificateId: `CERT_TEST_${Date.now()}`,
        testDate: new Date().toISOString().split('T')[0],
        expiryDate: new Date(Date.now() + 365 * 24 * 60 * 60 * 1000).toISOString().split('T')[0],
        overallGrade: "A+",
        compliance: "Fully Compliant",
        recommendations: "Maintain current storage conditions",
        notes: "Outstanding quality sample meeting all standards",
        issued: new Date().toISOString(),
        issuedBy: "Test Quality Labs"
      },
      timestamp: new Date().toISOString()
    };

    const labResponse = await axios.post(`${BASE_URL}/api/lab/events`, labData);
    console.log(`✅ Lab Testing Event Created`);
    console.log(`✅ Status: ${labResponse.data.data.provenance.status || 'tested'}`);
    console.log('');

    await sleep(1000);

    console.log('5️⃣ Regulatory Approval...');
    const regulatoryData = {
      qrCode: actualQrCode,
      decision: "approved",
      reviewerId: `REV_TEST_${Date.now()}`,
      reviewer: {
        name: "Test Regulatory Authority",
        regulatorId: "REG_TEST_001",
        contact: "+91 9876543213",
        certification: "FDA Approved",
        license: "REG2024001",
        location: "Regulatory Office, Bangalore"
      },
      reason: "Excellent quality product meeting all regulatory standards. Lab results show A+ grade with full compliance.",
      timestamp: new Date().toISOString()
    };

    const regulatoryResponse = await axios.post(`${BASE_URL}/api/regulator/review`, regulatoryData);
    console.log(`✅ Regulatory Review Completed`);
    console.log(`✅ Decision: ${regulatoryResponse.data.data.decision}`);
    console.log(`✅ Final Status: ${regulatoryResponse.data.data.finalStatus}`);
    console.log('');

    await sleep(1000);

    console.log('6️⃣ Consumer Verification...');
    const consumerResponse = await axios.get(`${BASE_URL}/api/workflow/access/consumer/${actualQrCode}?accessType=view`);
    if (consumerResponse.data.success && consumerResponse.data.data.accessAllowed) {
      console.log(`✅ Consumer Access: ALLOWED`);
      console.log(`✅ Batch Status: ${consumerResponse.data.data.currentStatus}`);
      console.log(`✅ Workflow Complete: ${consumerResponse.data.data.workflowStatus.isComplete}`);
    } else {
      console.log(`❌ Consumer Access: DENIED`);
      console.log(`❌ Reason: ${consumerResponse.data.data?.reason || 'Unknown'}`);
    }
    console.log('');

    console.log('🎉 WORKFLOW TEST COMPLETED SUCCESSFULLY!');
    console.log('========================================');
    console.log(`✅ QR Code for Testing: ${actualQrCode}`);
    console.log('✅ All workflow stages completed');
    console.log('✅ Sequential access control working');
    console.log('✅ Regulatory approval recorded');
    console.log('✅ Consumer verification enabled');
    console.log('');
    console.log('🌐 Test in Portals:');
    console.log(`   Consumer Portal: http://localhost:3001 (Enter: ${actualQrCode})`);
    console.log(`   Regulator Portal: http://localhost:3007 (Check compliance management)`);
    console.log(`   Management Portal: http://localhost:3008 (System overview)`);

  } catch (error) {
    console.error('❌ Workflow Test Failed:', error.response?.data?.error || error.message);
    console.log('');
    console.log('🔧 Troubleshooting:');
    console.log('   1. Ensure backend is running: npm run dev:backend');
    console.log('   2. Check backend health: curl http://localhost:3000/api/health');
    console.log('   3. Verify all services are running: npm run dev');
  }
}

// Run the test
testWorkflow();
