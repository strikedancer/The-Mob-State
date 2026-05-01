import { emailService } from './services/emailService';
import { normalizePlayerLanguage } from './config/supportedLanguages';

async function sendTestEmail() {
  try {
    const langArg = process.argv[2];
    const language = normalizePlayerLanguage(langArg || 'en');
    console.log(`Sending test email to strikedancer@gmail.com (${language})...`);

    // Generate a test token
    const testToken = emailService.generateToken();

    // Send verification email
    await emailService.sendVerificationEmail(
      'strikedancer@gmail.com',
      'TestUser',
      testToken,
      language,
    );
    
    console.log('✅ Test email sent successfully!');
    console.log('Token:', testToken);
  } catch (error) {
    console.error('❌ Failed to send test email:', error);
  }
  
  process.exit(0);
}

sendTestEmail();
