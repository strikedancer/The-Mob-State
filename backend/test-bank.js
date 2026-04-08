/**
 * Test Bank System (Phase 8.1)
 * 
 * Tests:
 * 1. Login as test player
 * 2. Deposit money into bank
 * 3. Check balance
 * 4. Withdraw money from bank
 * 5. Test insufficient cash for deposit
 * 6. Test insufficient balance for withdrawal
 * 7. Test invalid amounts (negative, zero, non-integer)
 * 8. Test account creation (auto-created on first access)
 * 9. Test interest rate and calculation
 */

const BASE_URL = 'http://localhost:3000';

let token = '';
let playerId = 0;
let initialCash = 0;

// Helper function to make API requests
async function apiRequest(method, endpoint, body = null) {
  const options = {
    method,
    headers: {
      'Content-Type': 'application/json',
      ...(token && { Authorization: `Bearer ${token}` }),
    },
  };

  if (body) {
    options.body = JSON.stringify(body);
  }

  const response = await fetch(`${BASE_URL}${endpoint}`, options);
  const data = await response.json();
  return { status: response.status, data };
}

// Test 1: Login
async function testLogin() {
  console.log('\n=== TEST 1: Login ===');
  const { status, data } = await apiRequest('POST', '/auth/login', {
    username: 'testplayer',
    password: 'test123',
  });

  const responseToken = data.token || data.params?.token;
  const responsePlayer = data.player || data.params?.player;

  if (status === 200 && responseToken) {
    token = responseToken;
    playerId = responsePlayer.id;
    initialCash = responsePlayer.money;
    console.log('✅ Login successful');
    console.log(`   Player ID: ${playerId}`);
    console.log(`   Initial cash: €${initialCash.toLocaleString()}`);
    return true;
  } else {
    console.log('❌ Login failed');
    console.log('   Response:', data);
    return false;
  }
}

// Test 2: Check initial bank balance (should auto-create account)
async function testInitialBalance() {
  console.log('\n=== TEST 2: Check Initial Bank Balance ===');
  const { status, data } = await apiRequest('GET', '/bank/balance');

  if (status === 200 && data.params?.balance !== undefined) {
    console.log('✅ Bank account accessed (auto-created if needed)');
    console.log(`   Balance: €${data.params.balance.toLocaleString()}`);
    return true;
  } else {
    console.log('❌ Failed to get balance');
    console.log('   Response:', data);
    return false;
  }
}

// Test 3: Deposit money into bank
async function testDeposit() {
  console.log('\n=== TEST 3: Deposit Money ===');
  const depositAmount = 10000;
  
  const { status, data } = await apiRequest('POST', '/bank/deposit', {
    amount: depositAmount,
  });

  if (status === 200 && data.event === 'bank.deposit_success') {
    console.log('✅ Deposit successful');
    console.log(`   Deposited: €${data.params.amount.toLocaleString()}`);
    console.log(`   Bank balance: €${data.params.bankBalance.toLocaleString()}`);
    console.log(`   Cash remaining: €${data.params.cashRemaining.toLocaleString()}`);
    
    // Verify cash was deducted
    if (data.params.cashRemaining === initialCash - depositAmount) {
      console.log('   ✓ Cash correctly deducted');
      return true;
    } else {
      console.log('   ✗ Cash deduction mismatch');
      return false;
    }
  } else {
    console.log('❌ Deposit failed');
    console.log('   Response:', data);
    return false;
  }
}

// Test 4: Withdraw money from bank
async function testWithdraw() {
  console.log('\n=== TEST 4: Withdraw Money ===');
  const withdrawAmount = 5000;
  
  const { status, data } = await apiRequest('POST', '/bank/withdraw', {
    amount: withdrawAmount,
  });

  if (status === 200 && data.event === 'bank.withdraw_success') {
    console.log('✅ Withdrawal successful');
    console.log(`   Withdrew: €${data.params.amount.toLocaleString()}`);
    console.log(`   Bank balance: €${data.params.bankBalance.toLocaleString()}`);
    console.log(`   Cash received: €${data.params.cashReceived.toLocaleString()}`);
    return true;
  } else {
    console.log('❌ Withdrawal failed');
    console.log('   Response:', data);
    return false;
  }
}

// Test 5: Get full account info
async function testAccountInfo() {
  console.log('\n=== TEST 5: Get Account Info ===');
  const { status, data } = await apiRequest('GET', '/bank/account');

  if (status === 200 && data.event === 'bank.account_info') {
    console.log('✅ Account info retrieved');
    console.log(`   Balance: €${data.params.balance.toLocaleString()}`);
    console.log(`   Interest rate: ${(data.params.interestRate * 100).toFixed(1)}%`);
    console.log(`   Daily interest: €${data.params.dailyInterest.toLocaleString()}`);
    console.log(`   Created: ${new Date(data.params.createdAt).toLocaleString()}`);
    return true;
  } else {
    console.log('❌ Failed to get account info');
    console.log('   Response:', data);
    return false;
  }
}

// Test 6: Test insufficient cash for deposit
async function testInsufficientCash() {
  console.log('\n=== TEST 6: Deposit More Than Cash Available ===');
  
  // Get current player cash
  const playerRes = await apiRequest('GET', '/player/me');
  const currentCash = playerRes.data.player.money;
  
  // Try to deposit more than we have
  const excessiveAmount = currentCash + 1000000;
  
  const { status, data } = await apiRequest('POST', '/bank/deposit', {
    amount: excessiveAmount,
  });

  if (status === 400 && data.event === 'error.insufficient_cash') {
    console.log('✅ Correctly rejected deposit (insufficient cash)');
    return true;
  } else {
    console.log('❌ Should have rejected insufficient cash');
    console.log('   Status:', status);
    console.log('   Response:', data);
    return false;
  }
}

// Test 7: Test insufficient balance for withdrawal
async function testInsufficientBalance() {
  console.log('\n=== TEST 7: Withdraw More Than Bank Balance ===');
  
  // First get current balance
  const balanceRes = await apiRequest('GET', '/bank/balance');
  const currentBalance = balanceRes.data.params.balance;
  
  // Try to withdraw more than we have
  const excessiveAmount = currentBalance + 1000000;
  
  const { status, data } = await apiRequest('POST', '/bank/withdraw', {
    amount: excessiveAmount,
  });

  if (status === 400 && data.event === 'error.insufficient_balance') {
    console.log('✅ Correctly rejected withdrawal (insufficient balance)');
    return true;
  } else {
    console.log('❌ Should have rejected insufficient balance');
    console.log('   Status:', status);
    console.log('   Response:', data);
    return false;
  }
}

// Test 8: Test invalid amounts
async function testInvalidAmounts() {
  console.log('\n=== TEST 8: Invalid Amounts ===');
  
  const testCases = [
    { amount: -100, desc: 'negative' },
    { amount: 0, desc: 'zero' },
    { amount: 50.5, desc: 'decimal' },
    { amount: 'abc', desc: 'string' },
  ];

  let allPassed = true;

  for (const testCase of testCases) {
    const { status, data } = await apiRequest('POST', '/bank/deposit', {
      amount: testCase.amount,
    });

    if (status === 400 && data.event === 'error.invalid_amount') {
      console.log(`   ✓ Rejected ${testCase.desc} amount (${testCase.amount})`);
    } else {
      console.log(`   ✗ Should have rejected ${testCase.desc} amount (${testCase.amount})`);
      allPassed = false;
    }
  }

  if (allPassed) {
    console.log('✅ All invalid amounts correctly rejected');
    return true;
  } else {
    console.log('❌ Some invalid amounts not handled correctly');
    return false;
  }
}

// Test 9: Test multiple deposits and withdrawals
async function testMultipleTransactions() {
  console.log('\n=== TEST 9: Multiple Transactions ===');
  
  // Get initial balance
  const initialBalance = await apiRequest('GET', '/bank/balance');
  const startBalance = initialBalance.data.params.balance;
  
  // Deposit 1000
  await apiRequest('POST', '/bank/deposit', { amount: 1000 });
  
  // Deposit another 2000
  await apiRequest('POST', '/bank/deposit', { amount: 2000 });
  
  // Withdraw 500
  await apiRequest('POST', '/bank/withdraw', { amount: 500 });
  
  // Check final balance
  const finalBalance = await apiRequest('GET', '/bank/balance');
  const endBalance = finalBalance.data.params.balance;
  
  const expectedBalance = startBalance + 1000 + 2000 - 500;
  
  if (endBalance === expectedBalance) {
    console.log('✅ Multiple transactions calculated correctly');
    console.log(`   Start: €${startBalance.toLocaleString()}`);
    console.log(`   End: €${endBalance.toLocaleString()}`);
    console.log(`   Expected: €${expectedBalance.toLocaleString()}`);
    return true;
  } else {
    console.log('❌ Transaction calculation mismatch');
    console.log(`   Expected: €${expectedBalance.toLocaleString()}`);
    console.log(`   Got: €${endBalance.toLocaleString()}`);
    return false;
  }
}

// Test 10: Verify interest calculation
async function testInterestCalculation() {
  console.log('\n=== TEST 10: Interest Calculation ===');
  
  const { status, data } = await apiRequest('GET', '/bank/account');
  
  if (status === 200) {
    const balance = data.params.balance;
    const rate = data.params.interestRate;
    const dailyInterest = data.params.dailyInterest;
    
    const expectedInterest = Math.floor(balance * rate);
    
    if (dailyInterest === expectedInterest) {
      console.log('✅ Interest calculation correct');
      console.log(`   Balance: €${balance.toLocaleString()}`);
      console.log(`   Rate: ${(rate * 100).toFixed(1)}%`);
      console.log(`   Daily interest: €${dailyInterest.toLocaleString()}`);
      return true;
    } else {
      console.log('❌ Interest calculation mismatch');
      console.log(`   Expected: €${expectedInterest.toLocaleString()}`);
      console.log(`   Got: €${dailyInterest.toLocaleString()}`);
      return false;
    }
  } else {
    console.log('❌ Failed to get account info');
    return false;
  }
}

// Run all tests
async function runAllTests() {
  console.log('╔════════════════════════════════════════════╗');
  console.log('║      BANK SYSTEM TEST SUITE (Phase 8.1)   ║');
  console.log('╚════════════════════════════════════════════╝');

  const results = [];

  results.push(await testLogin());
  if (!results[0]) {
    console.log('\n❌ Cannot proceed without login');
    return;
  }

  results.push(await testInitialBalance());
  results.push(await testDeposit());
  results.push(await testWithdraw());
  results.push(await testAccountInfo());
  results.push(await testInsufficientCash());
  results.push(await testInsufficientBalance());
  results.push(await testInvalidAmounts());
  results.push(await testMultipleTransactions());
  results.push(await testInterestCalculation());

  // Summary
  const passed = results.filter(r => r).length;
  const total = results.length;
  
  console.log('\n╔════════════════════════════════════════════╗');
  console.log('║              TEST SUMMARY                  ║');
  console.log('╚════════════════════════════════════════════╝');
  console.log(`   Total tests: ${total}`);
  console.log(`   Passed: ${passed}`);
  console.log(`   Failed: ${total - passed}`);
  console.log(`   Success rate: ${((passed / total) * 100).toFixed(1)}%`);
  
  if (passed === total) {
    console.log('\n🎉 All tests passed! Bank system working correctly.');
  } else {
    console.log('\n⚠️  Some tests failed. Review output above.');
  }
}

// Run tests
runAllTests().catch(console.error);
