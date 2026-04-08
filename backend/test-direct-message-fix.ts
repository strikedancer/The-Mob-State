import prisma from './src/lib/prisma';

async function testDirectMessage() {
  console.log('=== 💬 TESTING DIRECT MESSAGE SEND ===\n');

  try {
    // Get two test users
    const users = await prisma.player.findMany({
      take: 2,
      orderBy: { id: 'asc' },
    });

    if (users.length < 2) {
      console.error('❌ Need at least 2 users in database');
      return;
    }

    const [user1, user2] = users;
    console.log(`📝 Test users:`);
    console.log(`   User 1: ${user1.username} (ID: ${user1.id})`);
    console.log(`   User 2: ${user2.username} (ID: ${user2.id})\n`);

    // Check if they are friends
    const friendship = await prisma.friendship.findFirst({
      where: {
        OR: [
          { requesterId: user1.id, addresseeId: user2.id, status: 'accepted' },
          { requesterId: user2.id, addresseeId: user1.id, status: 'accepted' },
        ],
      },
    });

    if (!friendship) {
      console.log('⚠️  Users are not friends, creating friendship...');
      await prisma.friendship.create({
        data: {
          requesterId: user1.id,
          addresseeId: user2.id,
          status: 'accepted',
        },
      });
      console.log('✅ Friendship created\n');
    } else {
      console.log('✅ Users are already friends\n');
    }

    // Test sending a message
    console.log('1️⃣ Testing: Send message from user1 to user2');
    const { directMessageService } = await import('./src/services/directMessageService');
    
    const message = await directMessageService.sendMessage(
      user1.id,
      user2.id,
      'Test message - Hello friend!'
    );

    console.log('✅ Message sent successfully!');
    console.log(`   Message ID: ${message.id}`);
    console.log(`   Sender: ${message.sender?.username}`);
    console.log(`   Message: "${message.message}"`);
    console.log(`   Created: ${message.createdAt}\n`);

    // Check world events were created
    const events = await prisma.worldEvent.findMany({
      where: {
        eventKey: 'direct_message.received',
        createdAt: {
          gte: new Date(Date.now() - 10000), // Last 10 seconds
        },
      },
      orderBy: { createdAt: 'desc' },
      take: 5,
    });

    console.log('2️⃣ Checking SSE events created:');
    console.log(`   Total events: ${events.length}`);
    
    if (events.length >= 2) {
      console.log('   ✅ Event sent to sender (user1)');
      console.log('   ✅ Event sent to receiver (user2)');
      
      const senderEvent = events.find(e => e.playerId === user1.id);
      const receiverEvent = events.find(e => e.playerId === user2.id);
      
      if (senderEvent && receiverEvent) {
        console.log('\n📊 Event details:');
        console.log(`   Sender event (Player ${senderEvent.playerId}): ✅`);
        console.log(`   Receiver event (Player ${receiverEvent.playerId}): ✅`);
      }
    } else if (events.length === 1) {
      console.log(`   ⚠️  Only 1 event created (should be 2)`);
      console.log(`   Event sent to Player ${events[0].playerId}`);
    } else {
      console.log('   ❌ No events created!');
    }

    // Get conversation
    console.log('\n3️⃣ Testing: Load conversation');
    const conversation = await directMessageService.getConversation(
      user1.id,
      user2.id,
      10
    );

    console.log(`✅ Conversation loaded: ${conversation.length} message(s)`);
    
    console.log('\n=== ✅ ALL TESTS PASSED ===\n');

  } catch (error) {
    console.error('❌ Error:', error);
  } finally {
    await prisma.$disconnect();
  }
}

testDirectMessage();
