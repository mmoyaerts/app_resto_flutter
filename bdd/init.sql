-- --------------------
-- Création de la base de données (à faire uniquement si nécessaire)
-- --------------------
-- CREATE DATABASE restaurant;
-- \c restaurant

-- --------------------
-- Table rôles
-- --------------------
CREATE TABLE IF NOT EXISTS roles (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(50) UNIQUE NOT NULL
);

-- --------------------
-- Table utilisateurs
-- --------------------
CREATE TABLE IF NOT EXISTS utilisateurs (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role_id INT REFERENCES roles(id)
);

-- --------------------
-- Table restaurant
-- --------------------
CREATE TABLE IF NOT EXISTS restaurant (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    adresse TEXT,
    telephone VARCHAR(20)
);

-- --------------------
-- Table type de plats
-- --------------------
CREATE TABLE IF NOT EXISTS type_plats (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(50) NOT NULL
);

-- --------------------
-- Table plats
-- --------------------
CREATE TABLE IF NOT EXISTS plats (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    description TEXT,
    prix NUMERIC(8,2) NOT NULL,
    type_id INT REFERENCES type_plats(id),
    restaurant_id INT REFERENCES restaurant(id)
);

-- --------------------
-- Table ouverture
-- --------------------
CREATE TABLE IF NOT EXISTS ouverture (
    id SERIAL PRIMARY KEY,
    restaurant_id INT REFERENCES restaurant(id),
    jour VARCHAR(20) NOT NULL,
    heure_ouverture TIME NOT NULL,
    heure_fermeture TIME NOT NULL
);

-- --------------------
-- Table réservations
-- --------------------
CREATE TABLE IF NOT EXISTS reservations (
    id SERIAL PRIMARY KEY,
    utilisateur_id INT REFERENCES utilisateurs(id),
    restaurant_id INT REFERENCES restaurant(id),
    date_reservation DATE NOT NULL,
    heure TIME NOT NULL,
    nombre_couverts INT NOT NULL,
    commentaire VARCHAR(150),
    statut VARCHAR(20) DEFAULT 'en attente'
);

-- --------------------
-- Données initiales
-- --------------------

-- Insertion des rôles
INSERT INTO roles (nom)
VALUES 
    ('Client'),
    ('Serveur'),
    ('Admin')
ON CONFLICT (nom) DO NOTHING;

-- Insertion d’un restaurant fictif
INSERT INTO restaurant (nom, adresse, telephone)
VALUES ('Le petit cochon', '6 rue du petit cochon, Lyon', '0123456789')
ON CONFLICT DO NOTHING;

-- Insertion des horaires d’ouverture pour ce restaurant (id = 1)
INSERT INTO ouverture (restaurant_id, jour, heure_ouverture, heure_fermeture)
VALUES
(1, 'monday', '09:00', '17:00'),
(1, 'tuesday', '09:00', '17:00'),
(1, 'wednesday', '09:00', '17:00'),
(1, 'thursday', '09:00', '17:00'),
(1, 'friday', '09:00', '22:00'),
(1, 'saturday', '11:00', '22:00'),
(1, 'sunday', '11:00', '15:00');
