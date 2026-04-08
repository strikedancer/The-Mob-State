const BASE_URL = 'http://localhost:3000';

// Test users
const testUsers = [
  { username: 'heist_leader', password: 'test123', token: null, id: null },
  { username: 'heist_member1', password: 'test123', token: null, id: null },
  { username: 'heist_member2', password: 'test123', token: null, id: null },
];

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

async function loginUsers() {
  for (const user of testUsers) {
    const loginRes = await request('POST', '/auth/login', {
      username: user.username,
      password: user.password,
    });
    if (loginRes.data.token) {
      user.token = loginRes.data.token;
      user.id = loginRes.data.player.id;
      console.log(`✅ Logged in ${user.username} (ID: ${user.id})`);
    }
  }
}

async function startSimpleHeist() {
  console.log('\n💰 Starting simple heist...');

  const { status, data } = await request(
    'POST',
    '/heists/corner_store_heist/start',
    {},
    testUsers[0].token,
  );

  console.log(`Status: ${status}`);
  console.log(`Event: ${data.event}`);
  console.log('Data:', JSON.stringify(data, null, 2));
}

async function run() {
  await loginUsers();
  await startSimpleHeist();
}

run();
