-- phpMyAdmin SQL Dump
-- Base de données : `portfolio_db`
-- Moteur : InnoDB (support des clés étrangères)

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

-- On supprime d'abord la table enfant (projects), puis la table parent (users)
DROP TABLE IF EXISTS `projects`;
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `users`
--

INSERT INTO `users` (`id`, `email`, `password`, `role`, `created_at`) VALUES
(1, 'admin@portfolio.fr', '$2b$10$ujpr9i7bAfA5dT9BKH7b..gklJK3Ap0NnYN233.YqoQiQ0r/7KtxK', 'admin', '2026-05-05 09:11:36');

-- --------------------------------------------------------
--
-- Structure de la table `projects` (table enfant)
-- Chaque projet est rattaché à un utilisateur via `user_id` (clé étrangère)
--

CREATE TABLE `projects` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `title` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `tech_stack` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `github_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `demo_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `image_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_projects_user` (`user_id`),
  CONSTRAINT `fk_projects_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `projects`
-- (tous les projets appartiennent à l'administratrice, user_id = 1)
--

INSERT INTO `projects` (`id`, `user_id`, `title`, `description`, `tech_stack`, `github_url`, `demo_url`, `image_url`, `created_at`, `updated_at`, `deleted_at`) VALUES
(4, 1, 'Atelier de Médecine Chinoise', 'Création d\'une plateforme vitrine et de prise de rendez-vous pour un praticien en Médecine Traditionnelle Chinoise. Le site intègre un herbier digital interactif, une présentation des cinq éléments (Wu Xing) et un espace de conseils saisonniers pour harmoniser le Qi. Design épuré, apaisant et axé sur le bien-être.', 'React, Node.js, Express, Tailwind CSS, MySQL', 'https://github.com/votre-compte/cabinet-mtc', 'https://cabinet-medecine-chinoise.demo', 'https://images.unsplash.com/photo-1512290923902-8a9f81dc236c?auto=format&fit=crop&w=800&q=80', '2026-05-15 23:58:20', '2026-05-15 23:58:20', NULL),
(2, 1, 'E-commerce App', 'Site de vente de sneakers', 'Vue.js, Express, MongoDB', 'https://github.com/user/sneakers', NULL, 'https://picsum.photos/201', '2026-05-07 09:03:51', '2026-05-07 09:03:51', NULL),
(3, 1, 'Application E-commerce Sneakers', 'Une plateforme complète avec panier, paiement Stripe et gestion des stocks.', 'React, Node.js, MySQL, Stripe API', 'https://github.com/votre-compte/sneakers-app', 'https://sneakers-demo.com', 'https://picsum.photos/seed/sneakers/800/600', '2026-05-07 12:08:14', '2026-05-07 12:08:14', NULL),
(5, 1, 'EquiPâture & Soins', 'Une application web de gestion éco-responsable des pâtures et du suivi de santé pour les propriétaires de chevaux. Permet de planifier la rotation des herbagers (pâturage tournant), de suivre le calendrier des soins (vermifuges, parage, ostéopathe) et d\'analyser l\'état corporel des équidés grâce à un tableau de bord intuitif.', 'React, Context API, Tailwind CSS, MySQL, Chart.js', 'https://github.com/votre-compte/equipature', 'https://equipature-soins.demo', 'https://univers-cheval.fr/cdn/shop/articles/ChatGPT_Image_Apr_11_2025_10_12_18_AM_fa30e96d-a61b-4445-a515-7c82a1eff2c8_1200x1200.png?v=1744980262', '2026-05-15 23:58:20', '2026-06-09 13:05:24', NULL),
(6, 1, 'L\'Écho des Forêts', 'Application de cartographie collaborative répertoriant la flore sauvage locale et les sentiers de randonnée préservés. Développée dans une démarche d\'éco-conception logicielle pour limiter l\'impact carbone, avec un mode hors-ligne pour les zones blanches arborées.', 'React, Leaflet OpenStreetMap, Node.js, Tailwind', 'https://github.com/votre-compte/echo-forets', 'https://echo-des-forets.demo', 'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?auto=format&fit=crop&w=800&q=80', '2026-05-15 23:58:20', '2026-05-15 23:58:20', NULL),
(7, 1, 'Lin & Matière', 'Site vitrine immersif pour un atelier de tissage artisanal et de teinture végétale. Valorisation des circuits courts, fiches d\'explications sur les plantes tinctoriales (garance, gaude, pastel) et catalogue interactif des collections de lin lavé.', 'React, Framer Motion, Tailwind CSS', 'https://github.com/votre-compte/lin-matiere', 'https://lin-et-matiere.demo', 'https://images.unsplash.com/photo-1528459801416-a9e53bbf4e17?auto=format&fit=crop&w=800&q=80', '2026-05-15 23:58:20', '2026-05-15 23:58:20', NULL);

COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
