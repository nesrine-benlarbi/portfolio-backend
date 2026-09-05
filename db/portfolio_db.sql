-- Base de données : `portfolio_db`
-- Moteur : InnoDB (support des clés étrangères)
--
-- Modèle relationnel : 5 tables, 3 associations
--   users      1─N  projects   (un administrateur publie plusieurs projets, RESTRICT)
--   categories 1─N  projects   (un projet appartient à une catégorie, SET NULL)
--   projects   N─N  technologies via la table de liaison project_technologies

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";
/*!40101 SET NAMES utf8mb4 */;

-- Suppression dans l'ordre inverse des dépendances :
-- la table de liaison d'abord, puis les tables enfants, puis les parents.
DROP TABLE IF EXISTS `project_technologies`;
DROP TABLE IF EXISTS `projects`;
DROP TABLE IF EXISTS `technologies`;
DROP TABLE IF EXISTS `categories`;
DROP TABLE IF EXISTS `users`;

-- --------------------------------------------------------
--
-- Structure de la table `users` — table parent : le compte administrateur
--

CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `email` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `role` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Contenu de la table `users` (1 ligne)
--

INSERT INTO `users` (`id`, `email`, `password`, `role`, `created_at`) VALUES
(1, 'admin@portfolio.fr', '$2b$10$ujpr9i7bAfA5dT9BKH7b..gklJK3Ap0NnYN233.YqoQiQ0r/7KtxK', 'admin', '2026-05-05 11:11:36.000');

-- --------------------------------------------------------
--
-- Structure de la table `categories` — table parent : les catégories de projets
--

CREATE TABLE `categories` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Contenu de la table `categories` (3 lignes)
--

INSERT INTO `categories` (`id`, `name`) VALUES
(2, 'Application web'),
(3, 'E-commerce'),
(1, 'Site vitrine');

-- --------------------------------------------------------
--
-- Structure de la table `technologies` — table parent : les technologies référencées
--

CREATE TABLE `technologies` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Contenu de la table `technologies` (18 lignes)
--

INSERT INTO `technologies` (`id`, `name`) VALUES
(16, 'Apache'),
(17, 'Architecture MVC'),
(10, 'Chart.js'),
(9, 'Context API'),
(15, 'Docker'),
(3, 'Express'),
(12, 'Framer Motion'),
(11, 'Leaflet OpenStreetMap'),
(7, 'MongoDB'),
(5, 'MySQL'),
(2, 'Node.js'),
(13, 'PHP'),
(1, 'React'),
(8, 'Stripe API'),
(4, 'Tailwind CSS'),
(19, 'TypeScript'),
(20, 'Vite'),
(6, 'Vue.js');

-- --------------------------------------------------------
--
-- Structure de la table `projects` — table enfant : deux clés étrangères (user_id, category_id)
--

CREATE TABLE `projects` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `category_id` int DEFAULT NULL,
  `title` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `github_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `demo_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `image_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_projects_user` (`user_id`),
  KEY `fk_projects_category` (`category_id`),
  CONSTRAINT `fk_projects_category` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_projects_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Contenu de la table `projects` (8 lignes)
--

INSERT INTO `projects` (`id`, `user_id`, `category_id`, `title`, `description`, `github_url`, `demo_url`, `image_url`, `created_at`, `updated_at`, `deleted_at`) VALUES
(2, 1, 3, 'E-commerce App', 'Site de vente de sneakers', 'https://github.com/user/sneakers', NULL, 'https://picsum.photos/201', '2026-05-07 11:03:51.000', '2026-09-03 23:10:49.000', '2026-09-03 23:10:49.000'),
(3, 1, 3, 'Application E-commerce Sneakers', 'Une plateforme complète avec panier, paiement Stripe et gestion des stocks.', 'https://github.com/votre-compte/sneakers-app', 'https://sneakers-demo.com', 'https://picsum.photos/seed/sneakers/800/600', '2026-05-07 14:08:14.000', '2026-09-03 23:10:49.000', '2026-09-03 23:10:49.000'),
(4, 1, 1, 'Atelier de Médecine Chinoise — en cours', 'Plateforme vitrine et de prise de rendez-vous pour un praticien en médecine traditionnelle chinoise. Le site intégrera un herbier digital interactif, une présentation des cinq éléments (Wu Xing) et un espace de conseils saisonniers, dans un design épuré et apaisant. Projet personnel en cours : la conception est engagée, et un blog développé séparément y sera intégré. Le dépôt sera publié à la première version fonctionnelle.', NULL, NULL, 'https://images.unsplash.com/photo-1512290923902-8a9f81dc236c?auto=format&fit=crop&w=800&q=80', '2026-05-16 01:58:20.000', '2026-09-03 23:10:49.000', NULL),
(5, 1, 2, 'EquiPâture & Soins — en cours', 'Application web de gestion éco-responsable pour les propriétaires de chevaux : rotation des pâtures selon le principe du pâturage tournant, suivi de l\'alimentation, et calendrier des soins — vermifuges, parage, ostéopathe. Un tableau de bord donnera une vue d\'ensemble de l\'état de chaque équidé. Projet personnel en cours de conception ; le dépôt sera publié au démarrage du développement.', NULL, NULL, 'https://univers-cheval.fr/cdn/shop/articles/ChatGPT_Image_Apr_11_2025_10_12_18_AM_fa30e96d-a61b-4445-a515-7c82a1eff2c8_1200x1200.png?v=1744980262', '2026-05-16 01:58:20.000', '2026-09-03 23:10:49.000', NULL),
(6, 1, 2, 'L\'Écho des Forêts', 'Application de cartographie collaborative répertoriant la flore sauvage locale et les sentiers de randonnée préservés. Développée dans une démarche d\'éco-conception logicielle pour limiter l\'impact carbone, avec un mode hors-ligne pour les zones blanches arborées.', 'https://github.com/votre-compte/echo-forets', 'https://echo-des-forets.demo', 'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?auto=format&fit=crop&w=800&q=80', '2026-05-16 01:58:20.000', '2026-09-03 23:10:49.000', '2026-09-03 23:10:49.000'),
(7, 1, 1, 'Lin & Matière', 'Site vitrine immersif pour un atelier de tissage artisanal et de teinture végétale. Valorisation des circuits courts, fiches d\'explications sur les plantes tinctoriales (garance, gaude, pastel) et catalogue interactif des collections de lin lavé.', 'https://github.com/votre-compte/lin-matiere', 'https://lin-et-matiere.demo', 'https://images.unsplash.com/photo-1528459801416-a9e53bbf4e17?auto=format&fit=crop&w=800&q=80', '2026-05-16 01:58:20.000', '2026-09-03 23:10:49.000', '2026-09-03 23:10:49.000'),
(8, 1, 2, 'Atelier DEIN — Médiathèque collaborative', 'Application de gestion d\'une médiathèque, développée en équipe de quatre développeurs — Daria, Elyas, Ihsan et Nesrine, dont les initiales forment le nom du projet. Catalogue de livres, films et jeux, fiches détaillées, système d\'emprunts et espace d\'administration. Réalisée en PHP avec une architecture MVC codée sans framework, une base MySQL et un environnement conteneurisé avec Docker Compose. Ma contribution : l\'intégration CSS, l\'affichage des cartes de médias sur la page d\'accueil et la page de détail d\'un média — 28 commits.', 'https://github.com/nesrine-benlarbi/atelier_dein', NULL, 'https://images.unsplash.com/photo-1507842217343-583bb7270b66?auto=format&fit=crop&w=800&q=80', '2026-09-03 22:22:22.000', '2026-09-03 22:33:35.000', NULL),
(9, 1, 2, 'MarsAI — Festival de courts-métrages IA', 'Plateforme web d\'un festival de courts-métrages réalisés avec l\'intelligence artificielle, développée en équipe de quatre — Nesrine, Elyas, Ressane et Daria. Monorepo associant une application React en TypeScript et une API Express, avec intégration continue et déploiement automatisé sur un serveur privé. J\'ai conçu l\'application dans son ensemble : le cahier des charges avec Elyas, l\'articulation des écrans et des parcours utilisateur, l\'identité graphique, et la totalité des maquettes sur Figma. Le développement a ensuite été mené collectivement ; j\'y ai codé en binôme la page d\'accueil, les cartes de films, leur page de détail et les composants réutilisables — 30 commits.', 'https://github.com/nesrine-benlarbi/atelier-marsai', 'https://marsai.elyasbenyoub.dev', 'https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?auto=format&fit=crop&w=800&q=80', '2026-09-03 22:48:27.000', '2026-09-03 22:55:49.000', NULL);

-- --------------------------------------------------------
--
-- Structure de la table `project_technologies` — table de liaison : association N─N, clé primaire composite
--

CREATE TABLE `project_technologies` (
  `project_id` int NOT NULL,
  `technology_id` int NOT NULL,
  PRIMARY KEY (`project_id`,`technology_id`),
  KEY `fk_pt_technology` (`technology_id`),
  CONSTRAINT `fk_pt_project` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_pt_technology` FOREIGN KEY (`technology_id`) REFERENCES `technologies` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Contenu de la table `project_technologies` (36 lignes)
--

INSERT INTO `project_technologies` (`project_id`, `technology_id`) VALUES
(3, 1),
(4, 1),
(5, 1),
(6, 1),
(7, 1),
(9, 1),
(3, 2),
(4, 2),
(6, 2),
(2, 3),
(4, 3),
(9, 3),
(4, 4),
(5, 4),
(6, 4),
(7, 4),
(9, 4),
(3, 5),
(4, 5),
(5, 5),
(8, 5),
(9, 5),
(2, 6),
(2, 7),
(3, 8),
(5, 9),
(5, 10),
(6, 11),
(7, 12),
(8, 13),
(8, 15),
(9, 15),
(8, 16),
(8, 17),
(9, 19),
(9, 20);

