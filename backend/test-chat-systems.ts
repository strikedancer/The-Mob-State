/**
 * Test script for crew chat and direct messaging
 */

import prisma from './src/lib/prisma';
import { crewChatService } from './src/services/crewChatService';
import { directMessageService } from './src/services/directMessageService';
import { friendService } from './src/services/friendService';

async function main() {
  console.log('=== 💬 TESTING CHAT SYSTEMS ===\n');

  try {
    // Get test players
    const players = await prisma.player.findMany({
      take: 3,
      select: { id: true, username: true },
    });

    if (players.length < 2) {
      console.log('❌ Need at least 2 players to test. Create players first.');
      return;
    }

    const [player1, player2, player3] = players;
    console.log(`📝 Test players:`);
    console.log(`   Player 1: ${player1.username} (ID: ${player1.id})`);
    console.log(`   Player 2: ${player2.username} (ID: ${player2.id})`);
    if (player3) console.log(`   Player 3: ${player3.username} (ID: ${player3.id})`);
    console.log('');

    // TEST 1: Friend System
    console.log('1️⃣ Testing Friend System:');
    console.log('-'.repeat(50));

    try {
      // Send friend request
      const friendship = await friendService.sendFriendRequest(
        player1.id,
        player2.id
      );
      console.log(`✅ Friend request sent from ${player1.username} to ${player2.username}`);

      // Accept friend request
      await friendService.acceptFriendRequest(friendship.id, player2.id);
      console.log(`✅ Friend request accepted by ${player2.username}`);

      // Get friends list
      const friends = await friendService.getFriends(player1.id);
      console.log(`✅ ${player1.username} has ${friends.length} friend(s)`);
    } catch (error: any) {
      if (error.message === 'Friend request already pending' || error.message === 'Already friends') {
        console.log(`ℹ️  ${player1.username} and ${player2.username} are already friends`);
      } else {
        throw error;
      }
    }

    // TEST 2: Direct Messaging
    console.log('\n2️⃣ Testing Direct Messaging:');
    console.log('-'.repeat(50));

    try {
      // Send message
      const message1 = await directMessageService.sendMessage(
        player1.id,
        player2.id,
        'Hey! How are you doing?'
      );
      console.log(`✅ Message sent from ${player1.username} to ${player2.username}`);
      console.log(`   "${message1.message}"`);

      // Reply
      const message2 = await directMessageService.sendMessage(
        player2.id,
        player1.id,
        'I am good! Thanks for asking.'
      );
      console.log(`✅ Reply sent from ${player2.username} to ${player1.username}`);
      console.log(`   "${message2.message}"`);

      // Get conversation
      const conversation = await directMessageService.getConversation(
        player1.id,
        player2.id,
        10
      );
      console.log(`✅ Conversation loaded: ${conversation.length} messages`);

      // Get unread count
      const unreadCount = await directMessageService.getUnreadCount(player1.id);
      console.log(`✅ Unread messages for ${player1.username}: ${unreadCount}`);

      // Get all conversations
      const conversations = await directMessageService.getConversations(player1.id);
      console.log(`✅ ${player1.username} has ${conversations.length} conversation(s)`);
    } catch (error: any) {
      console.log(`❌ Direct messaging error: ${error.message}`);
    }

    // TEST 3: Crew Chat
    console.log('\n3️⃣ Testing Crew Chat:');
    console.log('-'.repeat(50));

    // Check if players are in crews
    const crew1 = await prisma.crewMember.findFirst({
      where: { playerId: player1.id },
      include: { crew: true },
    });

    const crew2 = await prisma.crewMember.findFirst({
      where: { playerId: player2.id },
      include: { crew: true },
    });

    if (!crew1 && !crew2) {
      console.log('ℹ️  No crews found. Skipping crew chat test.');
      console.log('   Create a crew first: POST /crews/create');
    } else {
      const crew = crew1 || crew2;
      const createdMember = crew1 ? player1 : player2;

      console.log(`ℹ️  Testing with crew: ${crew!.crew.name}`);

      try {
        // Send crew message
        const crewMessage = await crewChatService.sendMessage(
          crew!.crewId,
          createdMember.id,
          'Hello crew! This is a test message.'
        );
        console.log(`✅ Crew message sent by ${createdMember.username}`);
        console.log(`   "${crewMessage.message}"`);

        // Get crew messages
        const messages = await crewChatService.getMessages(
          crew!.crewId,
          createdMember.id,
          10
        );
        console.log(`✅ Crew messages loaded: ${messages.length} messages`);

        // Get unread count
        const unreadCount = await crewChatService.getUnreadCount(
          crew!.crewId,
          createdMember.id
        );
        console.log(`✅ Unread crew messages: ${unreadCount}`);
      } catch (error: any) {
        console.log(`❌ Crew chat error: ${error.message}`);
      }
    }

    // TEST 4: Database Schema Check
    console.log('\n4️⃣ Database Schema Check:');
    console.log('-'.repeat(50));

    const directMessageCount = await prisma.directMessage.count();
    const crewMessageCount = await prisma.crewMessage.count();
    const friendshipCount = await prisma.friendship.count();

    console.log(`📊 Database stats:`);
    console.log(`   Direct messages: ${directMessageCount}`);
    console.log(`   Crew messages: ${crewMessageCount}`);
    console.log(`   Friendships: ${friendshipCount}`);

    console.log('\n=== ✅ ALL TESTS COMPLETE ===\n');

    console.log('📋 Available Endpoints:');
    console.log('');
    console.log('🔹 Direct Messages:');
    console.log('   POST   /messages/:receiverId          - Send message');
    console.log('   GET    /messages/conversation/:playerId - Get conversation');
    console.log('   GET    /messages/conversations         - Get all conversations');
    console.log('   GET    /messages/unread                - Get unread count');
    console.log('   POST   /messages/mark-read/:playerId   - Mark as read');
    console.log('   DELETE /messages/:messageId            - Delete message');
    console.log('');
    console.log('🔹 Crew Chat:');
    console.log('   POST   /crews/:id/messages             - Send crew message');
    console.log('   GET    /crews/:id/messages             - Get crew messages');
    console.log('   DELETE /crews/:id/messages/:messageId  - Delete crew message');
    console.log('');
    console.log('🔹 Friends:');
    console.log('   POST   /friends/request                - Send friend request');
    console.log('   POST   /friends/:id/accept             - Accept request');
    console.log('   POST   /friends/:id/reject             - Reject request');
    console.log('   GET    /friends/list                   - Get friends');
    console.log('   GET    /friends/requests               - Get pending requests');
    console.log('   DELETE /friends/:id                    - Remove friend');
    console.log('');

  } catch (error) {
    console.error('❌ Test failed:', error);
  } finally {
    await prisma.$disconnect();
  }
}

main().catch(console.error);
