import dotenv from 'dotenv';
import Groq from 'groq-sdk';

// Load backend/.env explicitly so this script can run from workspace root
dotenv.config({ path: './backend/.env' });

(async () => {
  try {
    const groq = new Groq();
    const res = await groq.models.list();
    console.log('MODELS:', JSON.stringify(res, null, 2));
  } catch (err) {
    console.error('GROQ LIST ERROR:', err);
  }
})();
