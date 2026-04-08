import prisma from './src/lib/prisma';
import { directMessageService } from './src/services/directMessageService';

async function testConversations() {
  try {
    console.log('Testing getConversations for player 15 (strikedancer)...\n');
    
    const result = await directMessageService.getConversations(15);
    
    console.log('Result type:', typeof result);
    console.log('Result is Array:', Array.isArray(result));
    console.log('Result length:', result?.length);
    console.log('\nFull result:');
    console.log(JSON.stringify(result, null, 2));
    
  } catch (error) {
    console.error('Error:', error);
  } finally {
    await prisma.$disconnect();
  }
}

testConversations();
