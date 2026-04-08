import prisma from './src/lib/prisma';
import { NotificationService } from './src/services/notificationService';

/**
 * Test Direct Message Notification
 * This script tests if push notifications are sent when a direct message is created
 */

async function testDirectMessageNotification() {
  console.log('=== Testing Direct Message Push Notification ===\n');

  try {
    // Get two test users
    const users = await prisma.player.findMany({
      take: 2,
      orderBy: { id: 'asc' },
    });

    if (users.length < 2) {
      console.error('❌ Need at least 2 users in database');
      process.exit(1);
    }

    const sender = users[0];
    const receiver = users[1];

    console.log(`Sender: ${sender.username} (ID: ${sender.id})`);
    console.log(`Receiver: ${receiver.username} (ID: ${receiver.id})\n`);

    // Check if receiver has any registered devices
    const devices = await prisma.playerDevice.findMany({
      where: { playerId: receiver.id },
    });

    console.log(`📱 Registered devices for ${receiver.username}: ${devices.length}`);
    if (devices.length === 0) {
      console.log('⚠️ No devices registered for receiver');
      console.log('💡 User must login on Android/iOS to register device token\n');
    } else {
      devices.forEach((device: any, idx: number) => {
        console.log(`  Device ${idx + 1}:`);
        console.log(`    Type: ${device.deviceType}`);
        console.log(`    Token: ${device.deviceToken.substring(0, 20)}...`);
        console.log(`    Last active: ${device.lastActiveAt}`);
      });
      console.log('');
    }

    // Initialize notification service
    const notificationService = NotificationService.getInstance();
    await notificationService.initialize('./firebase-service-account.json');

    // Send test notification
    console.log('📤 Sending test notification...');
    try {
      await notificationService.sendDirectMessageNotification(
        receiver.id,
        sender.username,
        'Dit is een test bericht! 🎉',
        'nl'
      );
      console.log('✅ Notification sent successfully\n');
    } catch (error) {
      console.error('❌ Failed to send notification:', error);
      console.log('');
    }

    // Check world events
    const events = await prisma.worldEvent.findMany({
      where: {
        playerId: receiver.id,
        eventKey: 'direct_message.received',
      },
      orderBy: { createdAt: 'desc' },
      take: 5,
    });

    console.log(`📩 Recent SSE events for ${receiver.username}: ${events.length}`);
    events.forEach((event: any, idx: number) => {
      const params = event.params as any;
      console.log(`  Event ${idx + 1}:`);
      console.log(`    Sender: ${params.sender?.username}`);
      console.log(`    Message: ${params.message}`);
      console.log(`    Created: ${event.createdAt}`);
    });

    console.log('\n=== Test Complete ===');
    console.log('\nNext steps:');
    console.log('1. Make sure Flutter app is running on Android device');
    console.log('2. Login to the app to register device token');
    console.log('3. Send a real message from another user');
    console.log('4. Check if notification appears on Android device');

  } catch (error) {
    console.error('Error:', error);
    process.exit(1);
  } finally {
    await prisma.$disconnect();
  }
}

testDirectMessageNotification();
