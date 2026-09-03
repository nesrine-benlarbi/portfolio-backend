-- phpMyAdmin SQL Dump
-- Base de données : `portfolio_db`
-- Moteur : InnoDB (support des clés étrangères)
--
-- Modèle relationnel : 5 tables, 3 associations
--   users      1─N  projects   (un administrateur publie plusieurs projets, RESTRICT)
--   categories 1─N  projects   (un projet appartient à une catégorie)
--   projects   N─N  technologies via la table de liaison project_technologies

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
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
-- Structure de la table `users` (table parent)
--

CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `email` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `role` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `users`
--

INSERT INTO `users` (`id`, `email`, `password`, `role`, `created_at`) VALUES
(1, 'admin@portfolio.fr', '$2b$10$ujpr9i7bAfA5dT9BKH7b..gklJK3Ap0NnYN233.YqoQiQ0r/7KtxK', 'admin', '2026-05-05 09:11:36');

-- --------------------------------------------------------
--
-- Structure de la table `categories` (table parent)
-- Chaque projet appartient à une catégorie et une seule.
--

CREATE TABLE `categories` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `categories` (`id`, `name`) VALUES
(1, 'Site vitrine'),
(2, 'Application web'),
(3, 'E-commerce');

-- --------------------------------------------------------
--
-- Structure de la table `technologies` (table parent)
-- Chaque technologie n'est stockée qu'une seule fois : c'est la
-- normalisation de l'ancienne colonne `tech_stack`.
--

CREATE TABLE `technologies` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `technologies` (`id`, `name`) VALUES
(1, 'React'),
(2, 'Node.js'),
(3, 'Express'),
(4, 'Tailwind CSS'),
(5, 'MySQL'),
(6, 'Vue.js'),
(7, 'MongoDB'),
(8, 'Stripe API'),
(9, 'Context API'),
(10, 'Chart.js'),
(11, 'Leaflet OpenStreetMap'),
(12, 'Framer Motion'),
(13, 'PHP'),
(15, 'Docker'),
(16, 'Apache'),
(17, 'Architecture MVC'),
(19, 'TypeScript'),
(20, 'Vite');

-- --------------------------------------------------------
--
-- Structure de la table `projects` (table enfant)
-- Deux clés étrangères : vers `users` (auteur) et vers `categories`.
--

CREATE TABLE `projects` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `category_id` int DEFAULT NULL,
  `title` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `github_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `demo_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `image_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_projects_user` (`user_id`),
  KEY `fk_projects_category` (`category_id`),
  CONSTRAINT `fk_projects_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_projects_category` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `projects`
-- (tous les projets appartiennent à l'administratrice, user_id = 1)
--

INSERT INTO `projects` (`id`, `user_id`, `category_id`, `title`, `description`, `github_url`, `demo_url`, `image_url`, `created_at`, `updated_at`, `deleted_at`) VALUES
(4, 1, 1, 'Atelier de Médecine Chinoise — en cours', 'Plateforme vitrine et de prise de rendez-vous pour un praticien en médecine traditionnelle chinoise. Le site intégrera un herbier digital interactif, une présentation des cinq éléments (Wu Xing) et un espace de conseils saisonniers, dans un design épuré et apaisant. Projet personnel en cours : la conception est engagée, et un blog développé séparément y sera intégré. Le dépôt sera publié à la première version fonctionnelle.', NULL, NULL, 'https://images.unsplash.com/photo-1512290923902-8a9f81dc236c?auto=format&fit=crop&w=800&q=80', '2026-05-16 01:58:20', '2026-09-03 23:10:49', NULL),
(5, 1, 2, 'EquiPâture & Soins — en cours', 'Application web de gestion éco-responsable pour les propriétaires de chevaux : rotation des pâtures selon le principe du pâturage tournant, suivi de l''alimentation, et calendrier des soins — vermifuges, parage, ostéopathe. Un tableau de bord donnera une vue d''ensemble de l''état de chaque équidé. Projet personnel en cours de conception ; le dépôt sera publié au démarrage du développement.', NULL, NULL, 'https://univers-cheval.fr/cdn/shop/articles/ChatGPT_Image_Apr_11_2025_10_12_18_AM_fa30e96d-a61b-4445-a515-7c82a1eff2c8_1200x1200.png?v=1744980262', '2026-05-16 01:58:20', '2026-09-03 23:10:49', NULL),
(8, 1, 2, 'Atelier DEIN — Médiathèque collaborative', 'Application de gestion d''une médiathèque, développée en équipe de quatre développeurs — Daria, Elyas, Ihsan et Nesrine, dont les initiales forment le nom du projet. Catalogue de livres, films et jeux, fiches détaillées, système d''emprunts et espace d''administration. Réalisée en PHP avec une architecture MVC codée sans framework, une base MySQL et un environnement conteneurisé avec Docker Compose. Ma contribution : l''intégration CSS, l''affichage des cartes de médias sur la page d''accueil et la page de détail d''un média — 28 commits.', 'https://github.com/nesrine-benlarbi/atelier_dein', NULL, 'https://images.unsplash.com/photo-1507842217343-583bb7270b66?auto=format&fit=crop&w=800&q=80', '2026-09-03 22:22:22', '2026-09-03 22:33:35', NULL),
(9, 1, 2, 'MarsAI — Festival de courts-métrages IA', 'Plateforme web d''un festival de courts-métrages réalisés avec l''intelligence artificielle, développée en équipe de quatre — Nesrine, Elyas, Ressane et Daria. Monorepo associant une application React en TypeScript et une API Express, avec intégration continue et déploiement automatisé sur un serveur privé. J''ai conçu l''application dans son ensemble : le cahier des charges avec Elyas, l''articulation des écrans et des parcours utilisateur, l''identité graphique, et la totalité des maquettes sur Figma. Le développement a ensuite été mené collectivement ; j''y ai codé en binôme la page d''accueil, les cartes de films, leur page de détail et les composants réutilisables — 30 commits.', 'https://github.com/nesrine-benlarbi/atelier-marsai', 'https://marsai.elyasbenyoub.dev', 'https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?auto=format&fit=crop&w=800&q=80', '2026-09-03 22:48:27', '2026-09-03 22:55:49', NULL);

-- --------------------------------------------------------
--
-- Structure de la table `project_technologies` (table de liaison)
--
-- Elle matérialise l'association plusieurs-à-plusieurs entre `projects`
-- et `technologies`. Sa clé primaire est composée des deux clés
-- étrangères : un même couple projet/technologie ne peut donc pas être
-- enregistré deux fois.
--

CREATE TABLE `project_technologies` (
  `project_id` int NOT NULL,
  `technology_id` int NOT NULL,
  PRIMARY KEY (`project_id`, `technology_id`),
  KEY `fk_pt_technology` (`technology_id`),
  CONSTRAINT `fk_pt_project` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_pt_technology` FOREIGN KEY (`technology_id`) REFERENCES `technologies` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `project_technologies`
-- (reprise des anciennes chaînes `tech_stack`)
--

INSERT INTO `project_technologies` (`project_id`, `technology_id`) VALUES
(4, 1), (4, 2), (4, 3), (4, 4), (4, 5), (5, 1), (5, 4), (5, 5), (5, 9), (5, 10), (8, 5), (8, 13), (8, 15), (8, 16), (8, 17), (9, 1), (9, 3), (9, 4), (9, 5), (9, 15), (9, 19), (9, 20);

COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
