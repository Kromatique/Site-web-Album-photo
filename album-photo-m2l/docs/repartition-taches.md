📁 Structure du projet
album-photo-m2l/
│
├── 📄 README.md
├── 📄 .gitignore
│
├── 📂 docs/
│   ├── MCD.pdf (ou .png)
│   ├── MLD.pdf (ou .png)
│   ├── documentation-technique.md
│   └── repartition-taches.md
│
├── 📂 database/
│   ├── create_tables.sql
│   ├── seed_data.sql (données de test)
│   └── schema_updates.sql (migrations futures)
│
├── 📂 public/
│   ├── 📂 css/
│   │   ├── style.css
│   │   └── responsive.css
│   │
│   ├── 📂 js/
│   │   ├── main.js
│   │   └── comments.js
│   │
│   ├── 📂 images/
│   │   └── uploads/ (photos uploadées)
│   │
│   └── 📂 assets/
│       └── icons/ (icônes du site)
│
├── 📂 src/
│   ├── 📂 config/
│   │   └── database.php
│   │
│   ├── 📂 models/
│   │   ├── User.php
│   │   ├── Page.php
│   │   ├── Photo.php
│   │   └── Comment.php
│   │
│   ├── 📂 controllers/
│   │   ├── AuthController.php
│   │   ├── PhotoController.php
│   │   └── CommentController.php
│   │
│   └── 📂 views/
│       ├── layout/
│       │   ├── header.php
│       │   └── footer.php
│       ├── auth/
│       │   ├── login.php
│       │   └── register.php
│       ├── pages/
│       │   ├── index.php
│       │   └── page_view.php
│       ├── photos/
│       │   ├── photo_view.php
│       │   └── photo_upload.php
│       └── comments/
│           └── comment_section.php
│
└── 📄 index.php (point d'entrée)

🤝 Répartition des tâches recommandée

Phase 1 : Commun (2-3h)
[ ] Création du repository GitHub
[ ] Mise en place de l'arborescence
[ ] Conception du MCD ensemble
[ ] Rédaction du MLD
[ ] Création du script SQL (create_tables.sql)
[ ] Configuration de la base de données (database.php)

Personne A : Gestion des Photos 📸
Responsabilités :
[ ] PhotoController.php - Logique de gestion des photos
[ ] Photo.php - Modèle Photo
[ ] Page.php - Modèle Page
[ ] views/photos/ - Vues d'affichage et upload
[ ] views/pages/ - Affichage des pages et navigation
[ ] public/css/style.css - Style principal
[ ] Upload et stockage des photos
[ ] Affichage des légendes
[ ] Système de pagination/navigation entre pages
[ ] Suppression de photos (avec archivage 15 jours)

Branches Git :
feature/photo-display
feature/photo-upload
feature/photo-management

Personne B : Gestion des Commentaires 💬
Responsabilités :
[ ] CommentController.php - Logique des commentaires
[ ] Comment.php - Modèle Comment
[ ] views/comments/ - Section commentaires
[ ] public/js/comments.js - Interactions commentaires
[ ] Ajout de commentaires
[ ] Affichage des commentaires par photo
[ ] Suppression de commentaires (avec archivage 15 jours)
[ ] Système de modération admin

Branches Git :
feature/comments-display
feature/comments-crud
feature/comments-moderation

Phase 2 : Commun ou partagé

Authentification (à décider qui s'en charge) :
[ ] AuthController.php
[ ] User.php
[ ] views/auth/
[ ] Système de connexion/inscription
[ ] Gestion des sessions
[ ] Différenciation user/admin

Finalisation commune :
[ ] index.php - Routeur principal
[ ] layout/header.php et footer.php
[ ] public/css/responsive.css
[ ] Tests d'intégration
[ ] Documentation technique
[ ] Sécurité (injection SQL, XSS, CSRF)

📋 Stratégie Git recommandée

# Structure des branches
main
├── develop
│   ├── feature/photo-display (Personne A)
│   ├── feature/photo-upload (Personne A)
│   ├── feature/comments-display (Personne B)
│   └── feature/comments-crud (Personne B)

Workflow :

Ne jamais commit directement sur main
Travailler sur develop comme base
Créer des branches feature/ pour chaque fonctionnalité
Faire des Pull Requests vers develop
Merger develop vers main uniquement pour les versions stables
⚠️ Points d'attention pour éviter les conflits
Communiquez régulièrement sur ce que vous faites
Faites des commits fréquents avec des messages clairs
Pullez souvent la branche develop avant de pusher
Évitez de modifier les fichiers de l'autre personne
Définissez des interfaces claires entre vos modules (ex: format des données retournées)
🎯 Fichiers "neutres" à définir ensemble
Ces fichiers sont utilisés par les deux personnes, définissez leur structure ensemble :
Structure de la base de données
Format des sessions utilisateur
Conventions de nommage
Structure HTML du layout commun
Voulez-vous que je vous aide à créer un template de README.md ou des fichiers de configuration pour démarrer le projet ?

