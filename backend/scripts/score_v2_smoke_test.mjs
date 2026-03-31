import { randomUUID } from 'node:crypto';
import supabase from '../lib/supabase.js';

const baseUrl = process.env.BACKEND_URL || 'http://localhost:8081';

async function main() {
  const profileResult = await supabase.from('profiles').select('id').limit(1);
  if (profileResult.error) {
    throw new Error(`Failed to read profiles: ${profileResult.error.message}`);
  }

  if (!profileResult.data || profileResult.data.length === 0) {
    throw new Error('No profile found in profiles table for smoke test.');
  }

  const userId = profileResult.data[0].id;
  const attemptId = randomUUID();

  const attemptPayload = {
    attemptId,
    roadmapId: 'frontend',
    moduleId: 'html-css-basics',
    nodeId: 'html-intro',
    nodeDepth: 'submodule',
    quizScore: 92,
    metadata: { source: 'smoke-test' },
    submittedAt: new Date().toISOString(),
  };

  const attemptResponse = await fetch(`${baseUrl}/api/v2/user/${userId}/score/attempt`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(attemptPayload),
  });

  const attemptBody = await attemptResponse.json();

  const summaryResponse = await fetch(`${baseUrl}/api/v2/user/${userId}/score-summary`);
  const summaryBody = await summaryResponse.json();

  console.log(JSON.stringify({
    userId,
    attemptStatus: attemptResponse.status,
    attemptSuccess: attemptBody?.success ?? false,
    attemptError: attemptBody?.error ?? null,
    summaryStatus: summaryResponse.status,
    summarySuccess: summaryBody?.success ?? false,
    summaryError: summaryBody?.error ?? null,
  }, null, 2));
}

main().catch((error) => {
  console.error(error.message);
  process.exit(1);
});
