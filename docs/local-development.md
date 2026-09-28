# Développement local

Environnement validé : Flutter 3.38.5 / Dart 3.10.4, Node 22, Supabase CLI 2.72.7, Docker Desktop (conteneurs Linux). Windows nécessite le mode développeur pour les plugins Flutter utilisant des liens symboliques. Pour Android, installer le SDK 36 et accepter ses licences.

```powershell
npm ci --ignore-scripts
flutter pub get
pwsh -File scripts/local.ps1 -Action setup
flutter run -d chrome --web-port 3000 --dart-define-from-file=config/local.json
```

Docker doit être démarré. Au premier lancement, Supabase télécharge ses images. Le projet local `oikos-integration` utilise ses propres volumes ; les anciens projets locaux sont conservés. Studio : http://127.0.0.1:41005 ; emails de test : http://127.0.0.1:41006 ; API : http://127.0.0.1:41002.

`setup` lance les services essentiels, génère deux configurations Flutter **publiques** ignorées par Git et charge les assets locaux. Les clés serveur ne sont conservées qu’en mémoire pendant le script. `config/local.android.json` utilise `10.0.2.2`, l’adresse de la machine hôte depuis l’émulateur Android.

```powershell
flutter run -d <android-device-id> --dart-define-from-file=config/local.android.json
```

## Données de démonstration

Mot de passe commun : `OikosLocal123!` — uniquement pour la base locale.

| Compte | Parcours |
| --- | --- |
| `admin@oikos.test` | Administration Oikos Démo |
| `alice@oikos.test` | Membre, bilans et communauté DEMO01 |
| `bob@oikos.test` | Membre de DEMO02 |
| `nouveau@oikos.test` | Nouveau membre, parcours bilan |
| `eve@autre.test` | Seconde entreprise, test d’isolation |

Les fixtures incluent 32 questions dérivées du modèle Publicodes embarqué, catégories, actions, bilans détaillés, saison, notification et action collective. Les profils sont créés par le vrai trigger Auth. Aucun compte/session de production n’est importé.

```powershell
# Réinitialise uniquement les données de démonstration oikos-integration.
pwsh -File scripts/local.ps1 -Action reset
pwsh -File scripts/local.ps1 -Action test
supabase db lint --local --level warning
```

Les tests HTTP mutent brièvement les fixtures puis nettoient leurs objets. Un reset restaure également les effets dérivés (streak, notifications) et garantit un état identique pour une nouvelle démonstration.

Après modification des règles/questions : `node scripts/sync_questions.js --sql`. Commiter `seed_questions.sql` et vérifier que la régénération est identique. `scripts/sync_questions.js` hors mode SQL nécessite une clé serveur ; une base distante est refusée sans `--allow-remote`.

## Validation

```powershell
dart run build_runner build --delete-conflicting-outputs
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
node scripts/check-architecture.mjs
node scripts/build-publicodes.mjs
node scripts/publicodes.test.mjs
npm audit
flutter build web --release --no-wasm-dry-run --dart-define-from-file=config/local.json
flutter build apk --release --dart-define-from-file=config/local.android.json
node scripts/serve-web.mjs
```

Le dernier script sert `build/web` sur localhost:3000 avec repli des routes vers `index.html`. Un hébergeur Web devra assurer le même repli pour `/admin/*`, `/reset-password`, etc.

Sur une machine de 16 Go avec Docker et un IDE ouverts, lancer les builds Web et Android successivement. Gradle est limité à 2 Go de heap et deux workers ; un build release Android a pris environ 23 minutes sur la machine de validation. Un log momentanément silencieux ne suffit pas à conclure que le build est bloqué.

## Environnements hébergés

Créer une configuration à partir de `config/example.json`, avec URL HTTPS, clé **anon/publishable** et URL de retour propres à staging/production. Ajouter les URLs exactes à la liste autorisée de Supabase Auth, configurer SMTP et vérifier confirmation/récupération de compte. Les exemples locaux ne sont pas des paramètres de production.

Android release refuse HTTP et ne réutilise plus la clé de signature debug. Copier `android/key.properties.example` vers `android/key.properties` et fournir un keystore avant distribution ; sans ce fichier, la validation produit un APK non signé. Tester les liens profonds sur appareil. iOS nécessite macOS/Xcode et une signature propre.

Ne pas pousser directement cette chaîne de migrations vers une base existante : son historique a divergé entre les branches. Suivre la procédure de réconciliation dans le rapport d’intégration. Les seeds sont exclusivement locaux.
