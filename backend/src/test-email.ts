import { emailService } from './services/emailService';

async function sendTestEmail() {
  try {
    console.log('Sending test email to strikedancer@gmail.com...');
    
    // Generate a test token
    const testToken = emailService.generateToken();
    
    // Send verification email
    await emailService.sendVerificationEmail(
      'strikedancer@gmail.com',
      'TestUser',
      testToken
    );
    
    console.log('✅ Test email sent successfully!');
    console.log('Token:', testToken);
  } catch (error) {
    console.error('❌ Failed to send test email:', error);
  }
  
  process.exit(0);
}

sendTestEmail();
