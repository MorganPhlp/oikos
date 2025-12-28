# Utilisation de Supabase

Ce document décrit les commandes pour :
- installer le client Supabase pour Flutter
- installer le client Supabase pour Node
- démarrer Supabase localement (CLI)
- peupler la base de données `questions` via le script JS

## Installation — Flutter

Commande :

```bash
flutter pub add supabase_flutter
```

## Installation — Node (JS/TS)

Commandes :

```bash
npm install @supabase/supabase-js
```

Initialisation (exemple JS) :


## Démarrer Supabase (local / CLI)


```bash
# installer la CLI si nécessaire
npm install supabase

# démarrer les services locaux (Postgres + API)
supabase start
```

## Peupler la base de données `questions`

Le script `./scripts/sync_questions.js` va insérer/mettre à jour les entrées dans la table `questions`.

Pour le run :
```bash
node ./scripts/sync_questions.js
```

## Lancer ensuite le bilan carbone

On peut ensuite lancer le `bilan carbone` car les questions existent dans la base de donnée en local