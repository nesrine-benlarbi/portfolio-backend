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
(14, 'Docker'),
(15, 'Apache'),
(16, 'Architecture MVC'),
(17, 'TypeScript'),
(18, 'Vite');

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
(2, 1, 3, 'E-commerce App', 'Site de vente de sneakers', 'https://github.com/user/sneakers', NULL, 'https://picsum.photos/201', '2026-05-07 09:03:51', '2026-05-07 09:03:51', NULL),
(3, 1, 3, 'Application E-commerce Sneakers', 'Une plateforme complète avec panier, paiement Stripe et gestion des stocks.', 'https://github.com/votre-compte/sneakers-app', 'https://sneakers-demo.com', 'https://picsum.photos/seed/sneakers/800/600', '2026-05-07 12:08:14', '2026-05-07 12:08:14', NULL),
(4, 1, 1, 'Atelier de Médecine Chinoise', 'Création d\'une plateforme vitrine et de prise de rendez-vous pour un praticien en Médecine Traditionnelle Chinoise. Le site intègre un herbier digital interactif, une présentation des cinq éléments (Wu Xing) et un espace de conseils saisonniers pour harmoniser le Qi. Design épuré, apaisant et axé sur le bien-être.', 'https://github.com/votre-compte/cabinet-mtc', 'https://cabinet-medecine-chinoise.demo', 'https://images.unsplash.com/photo-1512290923902-8a9f81dc236c?auto=format&fit=crop&w=800&q=80', '2026-05-15 23:58:20', '2026-05-15 23:58:20', NULL),
(5, 1, 2, 'EquiPâture & Soins', 'Une application web de gestion éco-responsable des pâtures et du suivi de santé pour les propriétaires de chevaux. Permet de planifier la rotation des herbagers (pâturage tournant), de suivre le calendrier des soins (vermifuges, parage, ostéopathe) et d\'analyser l\'état corporel des équidés grâce à un tableau de bord intuitif.', 'https://github.com/votre-compte/equipature', 'https://equipature-soins.demo', 'https://univers-cheval.fr/cdn/shop/articles/ChatGPT_Image_Apr_11_2025_10_12_18_AM_fa30e96d-a61b-4445-a515-7c82a1eff2c8_1200x1200.png?v=1744980262', '2026-05-15 23:58:20', '2026-06-09 13:05:24', NULL),
(6, 1, 2, 'L\'Écho des Forêts', 'Application de cartographie collaborative répertoriant la flore sauvage locale et les sentiers de randonnée préservés. Développée dans une démarche d\'éco-conception logicielle pour limiter l\'impact carbone, avec un mode hors-ligne pour les zones blanches arborées.', 'https://github.com/votre-compte/echo-forets', 'https://echo-des-forets.demo', 'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?auto=format&fit=crop&w=800&q=80', '2026-05-15 23:58:20', '2026-05-15 23:58:20', NULL),
(7, 1, 1, 'Lin & Matière', 'Site vitrine immersif pour un atelier de tissage artisanal et de teinture végétale. Valorisation des circuits courts, fiches d\'explications sur les plantes tinctoriales (garance, gaude, pastel) et catalogue interactif des collections de lin lavé.', 'https://github.com/votre-compte/lin-matiere', 'https://lin-et-matiere.demo', 'https://images.unsplash.com/photo-1528459801416-a9e53bbf4e17?auto=format&fit=crop&w=800&q=80', '2026-05-15 23:58:20', '2026-05-15 23:58:20', NULL),
(8, 1, 2, 'Atelier DEIN — Médiathèque collaborative', 'Application de gestion d''une médiathèque, développée en équipe de quatre développeurs — Daria, Elyas, Ihsan et Nesrine, dont les initiales forment le nom du projet. Catalogue de livres, films et jeux, fiches détaillées, système d''emprunts et espace d''administration. Réalisée en PHP avec une architecture MVC codée sans framework, une base MySQL et un environnement conteneurisé avec Docker Compose. Ma contribution : l''intégration CSS, l''affichage des cartes de médias sur la page d''accueil et la page de détail d''un média — 28 commits.', 'https://github.com/nesrine-benlarbi/atelier_dein', NULL, 'https://images.unsplash.com/photo-1507842217343-583bb7270b66?auto=format&fit=crop&w=800&q=80', '2026-09-03 20:30:00', '2026-09-03 20:30:00', NULL),
(9, 1, 2, 'MarsAI — Festival de courts-métrages IA', 'Plateforme web d''un festival de courts-métrages réalisés avec l''intelligence artificielle, développée en équipe de quatre — Nesrine, Elyas, Ressane et Daria. Monorepo associant une application React en TypeScript et une API Express, avec intégration continue et déploiement automatisé sur un serveur privé. Ma contribution : la rédaction du cahier des charges avec Elyas, la charte graphique et la conception complète des maquettes sur Figma, puis le développement en binôme de la page d''accueil, des cartes, de leur page de détail et des composants réutilisables — 30 commits.', 'https://github.com/nesrine-benlarbi/atelier-marsai', 'https://marsai.elyasbenyoub.dev', 'https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?auto=format&fit=crop&w=800&q=80', '2026-09-03 21:00:00', '2026-09-03 21:00:00', NULL);

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
-- 2 : E-commerce App — Vue.js, Express, MongoDB
(2, 6), (2, 3), (2, 7),
-- 3 : Application E-commerce Sneakers — React, Node.js, MySQL, Stripe API
(3, 1), (3, 2), (3, 5), (3, 8),
-- 4 : Atelier de Médecine Chinoise — React, Node.js, Express, Tailwind CSS, MySQL
(4, 1), (4, 2), (4, 3), (4, 4), (4, 5),
-- 5 : EquiPâture & Soins — React, Context API, Tailwind CSS, MySQL, Chart.js
(5, 1), (5, 9), (5, 4), (5, 5), (5, 10),
-- 6 : L'Écho des Forêts — React, Leaflet OpenStreetMap, Node.js, Tailwind CSS
(6, 1), (6, 11), (6, 2), (6, 4),
-- 7 : Lin & Matière — React, Framer Motion, Tailwind CSS
(7, 1), (7, 12), (7, 4),
-- 8 : Atelier Dein — PHP, MySQL, Docker, Apache, Architecture MVC
(8, 13), (8, 5), (8, 14), (8, 15), (8, 16),
-- 9 : MarsAI — React, TypeScript, Vite, Tailwind CSS, Express, MySQL, Docker
(9, 1), (9, 17), (9, 18), (9, 4), (9, 3), (9, 5), (9, 14);

COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
