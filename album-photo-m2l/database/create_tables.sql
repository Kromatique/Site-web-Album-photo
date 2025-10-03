-- ============================================
-- Script de création de la base de données
-- Projet : Album Photo M2L
-- ============================================

-- Suppression de la base si elle existe (ATTENTION en production !)
DROP DATABASE IF EXISTS album_photo_m2l;

-- Création de la base de données
CREATE DATABASE album_photo_m2l CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Utilisation de la base de données
USE album_photo_m2l;

-- ============================================
-- Table : users
-- Gestion des utilisateurs et administrateurs
-- ============================================
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role ENUM('user', 'admin') DEFAULT 'user',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_username (username),
    INDEX idx_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Table : pages
-- Organisation des photos par pages thématiques
-- ============================================
CREATE TABLE pages (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_title (title)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Table : photos
-- Stockage des informations des photos
-- ============================================
CREATE TABLE photos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    page_id INT NOT NULL,
    user_id INT NOT NULL,
    filename VARCHAR(255) NOT NULL,
    legend VARCHAR(255) NOT NULL,
    status ENUM('active', 'pending_deletion', 'deleted') DEFAULT 'active',
    deleted_at TIMESTAMP NULL DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (page_id) REFERENCES pages(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_page_id (page_id),
    INDEX idx_user_id (user_id),
    INDEX idx_status (status),
    INDEX idx_deleted_at (deleted_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Table : comments
-- Gestion des commentaires sur les photos
-- ============================================
CREATE TABLE comments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    photo_id INT NOT NULL,
    user_id INT NOT NULL,
    content TEXT NOT NULL,
    status ENUM('active', 'pending_deletion', 'deleted') DEFAULT 'active',
    deleted_at TIMESTAMP NULL DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (photo_id) REFERENCES photos(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_photo_id (photo_id),
    INDEX idx_user_id (user_id),
    INDEX idx_status (status),
    INDEX idx_deleted_at (deleted_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Insertion des données de test
-- ============================================

-- Utilisateurs de test (mot de passe : "password123" hashé avec password_hash())
INSERT INTO users (username, email, password, role) VALUES
('admin', 'admin@m2l.fr', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin'),
('alice', 'alice@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'user'),
('bob', 'bob@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'user');

-- Pages thématiques
INSERT INTO pages (title, description) VALUES
('Compétition Régionale 2024', 'Photos de la compétition régionale de basket du 15 mars 2024'),
('Tournoi National', 'Tournoi national de handball - Phase finale'),
('Entraînement Jeunes', 'Séances d''entraînement des catégories jeunes');

-- Photos de test
INSERT INTO photos (page_id, user_id, filename, legend) VALUES
(1, 2, 'photo1.jpg', 'Match d''ouverture - équipe A vs équipe B'),
(1, 2, 'photo2.jpg', 'Remise des médailles aux vainqueurs'),
(2, 3, 'photo3.jpg', 'Échauffement avant la finale'),
(3, 2, 'photo4.jpg', 'Exercices de passes avec les U12');

-- Commentaires de test
INSERT INTO comments (photo_id, user_id, content) VALUES
(1, 3, 'Quel match incroyable ! Bravo à tous les joueurs.'),
(1, 1, 'Belle performance de l''équipe A !'),
(2, 2, 'Moment émouvant, félicitations aux gagnants.'),
(3, 3, 'L''intensité de la finale était impressionnante.');

-- ============================================
-- Événement planifié pour la suppression automatique
-- Supprime définitivement les éléments archivés depuis plus de 15 jours
-- ============================================

-- Activation du planificateur d'événements
SET GLOBAL event_scheduler = ON;

-- Suppression de l'événement s'il existe déjà
DROP EVENT IF EXISTS auto_delete_archived_items;

-- Création de l'événement de nettoyage automatique
DELIMITER $$

CREATE EVENT auto_delete_archived_items
ON SCHEDULE EVERY 1 DAY
STARTS CURRENT_TIMESTAMP
DO
BEGIN
    -- Suppression définitive des photos archivées depuis plus de 15 jours
    -- Pour les tests, vous pouvez changer "15 DAY" en "2 MINUTE"
    DELETE FROM photos 
    WHERE status = 'pending_deletion' 
    AND deleted_at IS NOT NULL 
    AND deleted_at < NOW() - INTERVAL 15 DAY;
    
    -- Suppression définitive des commentaires archivés depuis plus de 15 jours
    DELETE FROM comments 
    WHERE status = 'pending_deletion' 
    AND deleted_at IS NOT NULL 
    AND deleted_at < NOW() - INTERVAL 15 DAY;
END$$

DELIMITER ;

-- ============================================
-- Vues utiles (optionnel)
-- ============================================

-- Vue pour afficher les photos actives avec leurs informations
CREATE VIEW v_active_photos AS
SELECT 
    p.id,
    p.filename,
    p.legend,
    p.created_at,
    pg.title AS page_title,
    u.username AS author
FROM photos p
INNER JOIN pages pg ON p.page_id = pg.id
INNER JOIN users u ON p.user_id = u.id
WHERE p.status = 'active';

-- Vue pour afficher les commentaires actifs
CREATE VIEW v_active_comments AS
SELECT 
    c.id,
    c.content,
    c.created_at,
    u.username AS author,
    p.filename AS photo_filename
FROM comments c
INNER JOIN users u ON c.user_id = u.id
INNER JOIN photos p ON c.photo_id = p.id
WHERE c.status = 'active';

-- ============================================
-- Affichage du résultat
-- ============================================
SELECT 'Base de données créée avec succès !' AS Message;
SELECT COUNT(*) AS 'Nombre d''utilisateurs' FROM users;
SELECT COUNT(*) AS 'Nombre de pages' FROM pages;
SELECT COUNT(*) AS 'Nombre de photos' FROM photos;
SELECT COUNT(*) AS 'Nombre de commentaires' FROM comments;