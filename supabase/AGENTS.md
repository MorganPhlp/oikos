# Contrats de la base

- Développement/test : projet local `oikos-integration`, API 41002, PostgreSQL 41000. Les volumes des anciens projets ne doivent pas être réinitialisés.
- À partir de cette intégration, créer une nouvelle migration avec `supabase migration new <nom>`. Ne plus éditer les migrations historiques déjà appliquées. Les corrections historiques de septembre 2026 sont expliquées dans le rapport et exigent une réconciliation spécifique avant toute application distante.
- RLS activée sur chaque table exposée ; politiques par utilisateur/entreprise, privilèges par colonne pour les champs sensibles. Les vues utilisent `security_invoker=true`.
- Les fonctions privilégiées sont dans `private`, avec `search_path` explicite, noms qualifiés, autorisation `auth.uid()` et privilèges EXECUTE minimaux. Pas de fonction publique permettant un incrément d’XP arbitraire.
- Les dates, XP, seuils et transitions de défis sont validés en base. Transactions/verrous protègent les doubles clics et requêtes concurrentes.
- Vérifier les index des clés étrangères et filtres de politiques ; éviter les agrégats client et les requêtes N+1.
- Seeds synthétiques uniquement : deux entreprises et comptes `*.test`. Jamais copier `auth.sessions`, des tokens de rafraîchissement ou un dump d’utilisateurs réels dans Git.
- Les assets publics sont chargés via un script serveur local. Aucune écriture Storage anonyme/authenticated générale.
- Tester les cas positifs ET les refus : anonyme, membre, administrateur, autre entreprise, compte révoqué, récompense rejouée. `scripts/verify-local.mjs` est le point d’entrée des tests contractuels HTTP.
