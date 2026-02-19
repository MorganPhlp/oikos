import { createClient } from "@supabase/supabase-js";
import fs from "fs";
import path from "path";
import mime from "mime-types";
import "dotenv/config";

// Configuration
const supabase = createClient(
  process.env.SUPABASE_URL,
  process.env.SUPABASE_ANON_KEY,
);
const BUCKET_NAME = "streak";
const LOCAL_ROOT = "./assets/streak"; // Le dossier sur ton ordi

async function uploadFolder(directory) {
  const items = fs.readdirSync(directory);

  for (const item of items) {
    const fullPath = path.join(directory, item);
    const isDirectory = fs.statSync(fullPath).isDirectory();

    // On calcule le chemin relatif pour Supabase (ex: viveris/default/0.png)
    const relativePath = path
      .relative(LOCAL_ROOT, fullPath)
      .replace(/\\/g, "/");

    if (isDirectory) {
      await uploadFolder(fullPath);
    } else {
      const fileBuffer = fs.readFileSync(fullPath);
      const contentType = mime.lookup(fullPath) || "application/octet-stream";

      const { error } = await supabase.storage
        .from(BUCKET_NAME)
        .upload(relativePath, fileBuffer, {
          upsert: true,
          contentType: contentType,
        });

      if (error) {
        console.error(`❌ Erreur [${relativePath}]:`, error.message);
      } else {
        console.log(`✅ Uploadé: ${relativePath} (${contentType})`);
      }
    }
  }
}

console.log("🚀 Début de l'upload des assets de streak...");
uploadFolder(LOCAL_ROOT).then(() => console.log("✨ Terminé !"));
