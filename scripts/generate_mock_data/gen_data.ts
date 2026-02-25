import { createClient } from "@supabase/supabase-js";
import { getGeneratedUsers } from "./generate_users";

// Utilisation de la Service Role Key pour bypasser les RLS et gérer l'auth admin
const supabase = createClient(
  process.env.SUPABASE_URL!,
  process.env.SUPABASE_ANON_KEY!, // Assure-toi d'utiliser la SERVICE_ROLE_KEY
);

export function seed() {
  const users = getGeneratedUsers();
}
