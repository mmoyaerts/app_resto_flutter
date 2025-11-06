CREATE DATABASE restaurant;

-- Connexion à la base
\c restaurant;
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
    statut VARCHAR(20) DEFAULT 'en attente'
);
