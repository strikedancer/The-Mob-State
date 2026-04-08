/**
 * Test script for Phase 6.1: Crew System
 * Tests crew creation, joining, leaving, and error handling
 */

const BASE_URL = 'http://localhost:3000';

// Test users
const testUsers = [
  { username: 'crew_leader_test', password: 'test123', token: null },
  { username: 'crew_member_test', password: 'test123', token: null },
  { username: 'crew_member2_test', password: 'test123', token: null },
];

let createdCrewId = null;

async function request(method, path, body = null, token = null) {
  const options = {
    method,
    headers: {
      'Content-Type': 'application/json',
    },
  };

  if (token) {
    options.headers['Authorization'] = `Bearer ${token}`;
  }

  if (body) {
    options.body = JSON.stringify(body);
  }

  const response = await fetch(`${BASE_URL}${path}`, options);
  const data = await response.json();
  return { status: response.status, data };
}

async function registerUsers() {
  console.log('📝 Registreren test gebruikers...');
  
  for (const user of testUsers) {
    const { data } = await request('POST', '/auth/register', {
      username: user.username,
      password: user.password,
    });
    
    if (data.token) {
      user.token = data.token;
      console.log(`  ✅ ${user.username} geregistreerd`);
    } else {
      // User already exists, login
      const loginRes = await request('POST', '/auth/login', {
        username: user.username,
        password: user.password,
      });
      user.token = loginRes.data.token;
      console.log(`  ✅ ${user.username} ingelogd`);
    }
  }
}

async function testCreateCrew() {
  console.log('\n🏢 Test: Crew aanmaken...');
  
  const leader = testUsers[0];
  const { status, data } = await request('POST', '/crews/create', {
    name: 'The Test Bosses',
  }, leader.token);

  if (status === 201 && data.event === 'crew.created') {
    createdCrewId = data.params.crew.id;
    console.log(`  ✅ Crew aangemaakt: ${data.params.crew.name} (ID: ${createdCrewId})`);
    console.log(`     Leden: ${data.params.crew.memberCount}`);
    console.log(`     Bank: €${data.params.crew.bankBalance}`);
  } else {
    console.log(`  ❌ FAILED: Status ${status}`, data);
  }
}

async function testDuplicateCrewName() {
  console.log('\n🚫 Test: Dubbele crew naam...');
  
  const leader = testUsers[0];
  const { status, data } = await request('POST', '/crews/create', {
    name: 'The Test Bosses',
  }, leader.token);

  if (status === 400 && data.event === 'error.crew_name_taken') {
    console.log('  ✅ Dubbele naam correct geweigerd');
  } else {
    console.log(`  ❌ FAILED: Verwacht error.crew_name_taken, kreeg:`, data);
  }
}

async function testAlreadyInCrew() {
  console.log('\n🚫 Test: Speler al in crew...');
  
  const leader = testUsers[0];
  const { status, data } = await request('POST', '/crews/create', {
    name: 'Another Crew',
  }, leader.token);

  if (status === 400 && data.event === 'error.already_in_crew') {
    console.log('  ✅ Al-in-crew correct geweigerd');
  } else {
    console.log(`  ❌ FAILED: Verwacht error.already_in_crew, kreeg:`, data);
  }
}

async function testJoinCrew() {
  console.log('\n👥 Test: Lid toevoegen aan crew...');
  
  const member = testUsers[1];
  const { status, data } = await request('POST', `/crews/${createdCrewId}/join`, {}, member.token);

  if (status === 200 && data.event === 'crew.joined') {
    console.log(`  ✅ Lid toegevoegd aan crew`);
    console.log(`     Leden: ${data.params.crew.memberCount}`);
  } else {
    console.log(`  ❌ FAILED: Status ${status}`, data);
  }
}

async function testJoinSecondMember() {
  console.log('\n👥 Test: Tweede lid toevoegen...');
  
  const member = testUsers[2];
  const { status, data } = await request('POST', `/crews/${createdCrewId}/join`, {}, member.token);

  if (status === 200 && data.event === 'crew.joined') {
    console.log(`  ✅ Tweede lid toegevoegd`);
    console.log(`     Totaal leden: ${data.params.crew.memberCount}`);
  } else {
    console.log(`  ❌ FAILED: Status ${status}`, data);
  }
}

async function testJoinInvalidCrew() {
  console.log('\n🚫 Test: Onbekende crew joinen...');
  
  const { status, data } = await request('POST', '/crews/99999/join', {}, testUsers[0].token);

  if (status === 404 && data.event === 'error.crew_not_found') {
    console.log('  ✅ Onbekende crew correct geweigerd');
  } else {
    console.log(`  ❌ FAILED: Verwacht 404 crew_not_found, kreeg:`, data);
  }
}

async function testGetMyCrew() {
  console.log('\n📋 Test: Mijn crew ophalen...');
  
  const leader = testUsers[0];
  const { status, data } = await request('GET', '/crews/mine', null, leader.token);

  if (status === 200 && data.event === 'crew.mine') {
    console.log(`  ✅ Crew opgehaald: ${data.params.crew.name}`);
    console.log(`     Leden: ${data.params.crew.memberCount}`);
    console.log(`     Rollen: ${data.params.crew.members.map(m => m.role).join(', ')}`);
  } else {
    console.log(`  ❌ FAILED: Status ${status}`, data);
  }
}

async function testGetCrewById() {
  console.log('\n🔍 Test: Crew ophalen op ID...');
  
  const { status, data } = await request('GET', `/crews/${createdCrewId}`);

  if (status === 200 && data.event === 'crew.info') {
    console.log(`  ✅ Crew info: ${data.params.crew.name}`);
    console.log(`     Bank: €${data.params.crew.bankBalance}`);
    console.log(`     Leden: ${data.params.crew.memberCount}`);
  } else {
    console.log(`  ❌ FAILED: Status ${status}`, data);
  }
}

async function testGetAllCrews() {
  console.log('\n📊 Test: Alle crews ophalen...');
  
  const { status, data } = await request('GET', '/crews');

  if (status === 200 && data.event === 'crews.list') {
    console.log(`  ✅ ${data.params.crews.length} crew(s) gevonden`);
    data.params.crews.forEach(crew => {
      console.log(`     - ${crew.name} (${crew.memberCount} leden)`);
    });
  } else {
    console.log(`  ❌ FAILED: Status ${status}`, data);
  }
}

async function testMemberLeaveCrew() {
  console.log('\n👋 Test: Lid verlaat crew...');
  
  const member = testUsers[1];
  const { status, data } = await request('POST', '/crews/leave', {}, member.token);

  if (status === 200 && data.event === 'crew.left') {
    console.log('  ✅ Lid heeft crew verlaten');
  } else {
    console.log(`  ❌ FAILED: Status ${status}`, data);
  }
}

async function testLeaderCannotLeave() {
  console.log('\n🚫 Test: Leader kan niet vertrekken met members...');
  
  const leader = testUsers[0];
  const { status, data } = await request('POST', '/crews/leave', {}, leader.token);

  if (status === 400 && data.event === 'error.leader_cannot_leave') {
    console.log('  ✅ Leader correct geblokkeerd (heeft nog members)');
  } else {
    console.log(`  ❌ FAILED: Verwacht error.leader_cannot_leave, kreeg:`, data);
  }
}

async function testLeaveNotInCrew() {
  console.log('\n🚫 Test: Leave zonder crew membership...');
  
  const member = testUsers[1]; // Already left
  const { status, data } = await request('POST', '/crews/leave', {}, member.token);

  if (status === 400 && data.event === 'error.not_in_crew') {
    console.log('  ✅ Not-in-crew correct gedetecteerd');
  } else {
    console.log(`  ❌ FAILED: Verwacht error.not_in_crew, kreeg:`, data);
  }
}

async function testLastMemberLeave() {
  console.log('\n👋 Test: Laatste member verlaat crew...');
  
  // First, remove second member
  const member2 = testUsers[2];
  await request('POST', '/crews/leave', {}, member2.token);
  console.log('  → Member 2 heeft crew verlaten');
  
  // Now leader can leave (and crew gets deleted)
  const leader = testUsers[0];
  const { status, data } = await request('POST', '/crews/leave', {}, leader.token);

  if (status === 200 && data.event === 'crew.left') {
    console.log('  ✅ Leader heeft crew verlaten');
    
    // Verify crew is deleted
    const checkCrew = await request('GET', `/crews/${createdCrewId}`);
    if (checkCrew.status === 404) {
      console.log('  ✅ Crew automatisch verwijderd');
    } else {
      console.log('  ❌ Crew nog steeds aanwezig!');
    }
  } else {
    console.log(`  ❌ FAILED: Status ${status}`, data);
  }
}

async function runTests() {
  console.log('🎮 CREW SYSTEM TEST SUITE\n');
  console.log('='.repeat(50));

  try {
    await registerUsers();
    await testCreateCrew();
    await testDuplicateCrewName();
    await testAlreadyInCrew();
    await testJoinCrew();
    await testJoinSecondMember();
    await testJoinInvalidCrew();
    await testGetMyCrew();
    await testGetCrewById();
    await testGetAllCrews();
    await testMemberLeaveCrew();
    await testLeaderCannotLeave();
    await testLeaveNotInCrew();
    await testLastMemberLeave();

    console.log('\n' + '='.repeat(50));
    console.log('✅ ALLE CREW TESTS VOLTOOID');
    
  } catch (error) {
    console.error('\n❌ TEST FOUT:', error.message);
    process.exit(1);
  }
}

// Run tests
runTests();
