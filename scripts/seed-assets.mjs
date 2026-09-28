import { createClient } from '@supabase/supabase-js';
import { readdir, readFile } from 'node:fs/promises';
import path from 'node:path';
import mime from 'mime-types';

const url = process.env.SUPABASE_URL;
if (!url || !['localhost', '127.0.0.1'].includes(new URL(url).hostname)) throw new Error('Supabase local uniquement.');
const client = createClient(url, process.env.SUPABASE_SERVICE_ROLE_KEY, { auth: { persistSession: false, autoRefreshToken: false } });
async function uploadTree(bucket, root, prefix = '') {
  for (const entry of await readdir(path.join(root, prefix), { withFileTypes: true })) {
    const relative = path.posix.join(prefix, entry.name);
    if (entry.isDirectory()) await uploadTree(bucket, root, relative);
    else {
      const { error } = await client.storage.from(bucket).upload(relative,
        await readFile(path.join(root, relative)), { upsert: true, contentType: mime.lookup(entry.name) || 'application/octet-stream' });
      if (error) throw new Error(`${bucket}/${relative}: ${error.message}`);
    }
  }
}
for (const bucket of ['avatars', 'logos', 'streak']) {
  await uploadTree(bucket, `assets/${bucket}`);
  console.log(`Assets locaux disponibles : ${bucket}`);
}
