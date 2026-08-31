# L'Atelier — Portfolio Full-Stack (API Back-End)

API REST du portfolio dynamique et administrable **L'Atelier**, réalisé par Nesrine Benlarbi dans le cadre du titre professionnel Développeur Web et Web Mobile (DWWM).

Cette API permet de gérer les projets affichés sur le portfolio (CRUD complet), l'authentification de l'administratrice et l'envoi des messages du formulaire de contact.

---

## Stack technique

| Côté | Technologie |
|---|---|
| Runtime / Framework | Node.js · Express 5 (ES Modules) |
| Base de données | MySQL (via `mysql2/promise`) |
| Authentification | JWT (`jsonwebtoken`) + `bcrypt` |
| Validation | `express-validator` |
| Emails | Nodemailer |

---

## Architecture

Le projet suit une architecture en couches :

```
src/
├── config/        Pool de connexion MySQL
├── controllers/   Reçoit req/res, délègue au service, renvoie la réponse
├── services/       Logique métier (aucun accès à req/res)
├── models/         Requêtes SQL
├── middlewares/     authenticate, authorize, validate, errorHandler
├── validators/       Règles express-validator par ressource
├── routes/           Déclaration des endpoints
├── errors/            Classe AppError (erreurs avec code HTTP)
└── server.js
```

Le flux d'une requête suit toujours : `route → controller → service → model`.

---

## Installation

```bash
npm install
```

Créer un fichier `.env` à la racine à partir de `.env.example` et renseigner :

```env
PORT=3001
CLIENT_URL=http://localhost:5173

DB_HOST=localhost
DB_USER=root
DB_PASSWORD=
DB_NAME=portfolio_db

JWT_SECRET=un_secret_long_et_aleatoire

MAIL_HOST=
MAIL_PORT=
MAIL_USER=
MAIL_PASS=
MAIL_TO=
```

Créer la base de données :

```sql
CREATE DATABASE IF NOT EXISTS portfolio_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE portfolio_db;

CREATE TABLE users (
  id         INT AUTO_INCREMENT PRIMARY KEY,
  email      VARCHAR(255) NOT NULL UNIQUE,
  password   VARCHAR(255) NOT NULL,
  role       VARCHAR(50)  NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE projects (
  id          INT AUTO_INCREMENT PRIMARY KEY,
  title       VARCHAR(150)  NOT NULL,
  description TEXT,
  tech_stack  VARCHAR(255),
  github_url  VARCHAR(500),
  demo_url    VARCHAR(500),
  image_url   VARCHAR(500),
  created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at  TIMESTAMP NULL DEFAULT NULL
);
```

Il n'y a pas de route `/register` publique : le compte administrateur est créé une seule fois, directement en base, avec un mot de passe pré-haché avec bcrypt (coût 10) :

```sql
INSERT INTO users (email, password, role)
VALUES ('admin@portfolio.fr', 'HASH_BCRYPT_ICI', 'admin');
```

Lancer le serveur :

```bash
npm run dev    # avec nodemon
npm start      # sans nodemon
```

---

## Routes de l'API

| Méthode | Route | Auth | Rôle requis | Description |
|---|---|---|---|---|
| POST | `/api/auth/login` | ❌ | — | Connexion administrateur |
| GET | `/api/projects` | ❌ | — | Liste des projets actifs (non archivés) |
| GET | `/api/projects/:id` | ❌ | — | Détail d'un projet |
| POST | `/api/projects` | ✅ | admin | Créer un projet |
| PUT | `/api/projects/:id` | ✅ | admin | Modifier un projet |
| DELETE | `/api/projects/:id` | ✅ | admin | Archiver un projet (soft delete) |
| POST | `/api/contact` | ❌ | — | Envoyer un message via le formulaire de contact |

### À propos de la suppression d'un projet

La suppression est un **soft delete** : la route `DELETE /api/projects/:id` ne détruit pas la ligne en base, elle renseigne la colonne `deleted_at` avec la date courante. Les projets archivés ne sont plus renvoyés par `GET /api/projects` ni `GET /api/projects/:id`. La route répond `200` avec un message de confirmation (plutôt qu'un `204` silencieux), pour permettre au front d'afficher un retour explicite à l'administratrice.

---

## Sécurité

- Mots de passe hashés avec `bcrypt`.
- Authentification par JWT (`jsonwebtoken`), durée de validité 24h.
- Routes d'écriture protégées par les middlewares `authenticate` (vérifie le token) et `authorize('admin')` (vérifie le rôle).
- Validation systématique des entrées avec `express-validator` sur toutes les routes recevant des données (`POST`/`PUT`).
- Requêtes SQL exclusivement paramétrées (protection contre les injections SQL).
- Secrets et accès BDD/SMTP dans des variables d'environnement (`.env`, non versionné).
