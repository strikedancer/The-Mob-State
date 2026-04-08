import prisma from './src/lib/prisma';
import { NotificationService } from './src/services/notificationService';

/**
 * Test push notification to Android device
 */

async function testAndroidNotification() {
  console.log('=== Testing Android Push Notification ===\n');

  try {
    // Get strikedancer (has Android device)
    const player = await prisma.player.findUnique({
      where: { id: 15 }, // strikedancer
    });

    if (!player) {
      console.error('❌ Player not found');
      process.exit(1);
    }

    console.log(`Testing notification for: ${player.username} (ID: ${player.id})\n`);

    // Check devices
    const devices = await prisma.playerDevice.findMany({
      where: { playerId: player.id },
    });

    console.log(`📱 Registered devices: ${devices.length}`);
    devices.forEach((device: any, idx: number) => {
      console.log(`  ${idx + 1}. Type: ${device.deviceType}`);
      console.log(`     Token: ${device.deviceToken.substring(0, 40)}...`);
    });
    console.log('');

    // Check if firebase-service-account.json exists
    const fs = require('fs');
    const path = require('path');
    const serviceAccountPath = path.join(__dirname, 'firebase-service-account.json');
    
    if (!fs.existsSync(serviceAccountPath)) {
      console.log('❌ firebase-service-account.json NOT FOUND');
      console.log('📍 Expected location:', serviceAccountPath);
      console.log('');
      console.log('⚠️ Push notifications CANNOT be sent without this file');
      console.log('');
      console.log('📖 To fix:');
      console.log('1. Go to Firebase Console: https://console.firebase.google.com');
      console.log('2. Select your project');
      console.log('3. Go to Project Settings → Service Accounts');
      console.log('4. Click "Generate New Private Key"');
      console.log('5. Save the file as: firebase-service-account.json');
      console.log('6. Place it in: backend/firebase-service-account.json');
      console.log('7. Restart backend: docker compose restart backend');
      console.log('');
      process.exit(1);
    }

    console.log('✅ firebase-service-account.json found\n');

    // Initialize notification service
    const notificationService = NotificationService.getInstance();
    await notificationService.initialize(serviceAccountPath);

    // Send test notification
    console.log('📤 Sending test notification to Android device...');
    try {
      await notificationService.sendDirectMessageNotification(
        player.id,
        'Test Sender',
        'Dit is een test notificatie naar je Android device! 📱🎉',
        'nl'
      );
      console.log('✅ Notification sent successfully\n');
      console.log('📱 Check your Android device for the notification!');
    } catch (error: any) {
      console.error('❌ Failed to send notification:', error.message);
      console.log('');
    }

  } catch (error) {
    console.error('Error:', error);
    process.exit(1);
  } finally {
    await prisma.$disconnect();
  }
}

testAndroidNotification();
