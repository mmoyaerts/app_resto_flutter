
CREATE TABLE IF NOT EXISTS roles (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(50) UNIQUE NOT NULL
);


CREATE TABLE IF NOT EXISTS utilisateurs (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role_id INT REFERENCES roles(id)
);


CREATE TABLE IF NOT EXISTS restaurant (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    adresse TEXT,
    telephone VARCHAR(20)
);


CREATE TABLE IF NOT EXISTS type_plats (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(50) NOT NULL
);


CREATE TABLE IF NOT EXISTS plats (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    description TEXT,
    prix NUMERIC(8,2) NOT NULL,
    type_id INT REFERENCES type_plats(id),
    restaurant_id INT REFERENCES restaurant(id),
    image VARCHAR(255)
);


CREATE TABLE IF NOT EXISTS ouverture (
    id SERIAL PRIMARY KEY,
    restaurant_id INT REFERENCES restaurant(id),
    jour VARCHAR(20) NOT NULL,
    heure_ouverture TIME NOT NULL,
    heure_fermeture TIME NOT NULL
);

CREATE TABLE IF NOT EXISTS statut_reservations (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(50) UNIQUE NOT NULL
);

INSERT INTO statut_reservations (nom) VALUES
('en attente'),
('validée'),
('refusée');

CREATE TABLE IF NOT EXISTS reservations (
    id SERIAL PRIMARY KEY,
    utilisateur_id INT REFERENCES utilisateurs(id),
    restaurant_id INT REFERENCES restaurant(id),
    date_reservation DATE NOT NULL,
    heure TIME NOT NULL,
    nombre_couverts INT NOT NULL,
    commentaire VARCHAR(150),
    statut_id INT REFERENCES statut_reservations(id) DEFAULT 1
);

INSERT INTO roles (nom)
VALUES 
    ('Client'),
    ('Serveur'),
    ('Admin')
ON CONFLICT (nom) DO NOTHING;

INSERT INTO restaurant (nom, adresse, telephone)
VALUES ('Le petit cochon', '6 rue du petit cochon, Lyon', '0123456789')
ON CONFLICT DO NOTHING;

INSERT INTO ouverture (restaurant_id, jour, heure_ouverture, heure_fermeture)
VALUES
(1, 'monday', '09:00', '17:00'),
(1, 'tuesday', '09:00', '17:00'),
(1, 'wednesday', '09:00', '17:00'),
(1, 'thursday', '09:00', '17:00'),
(1, 'friday', '09:00', '22:00'),
(1, 'saturday', '11:00', '22:00'),
(1, 'sunday', '11:00', '15:00');



ALTER TABLE plats
ADD COLUMN IF NOT EXISTS image VARCHAR(255);

INSERT INTO type_plats (nom)
VALUES 
    ('Entrée'),
    ('Plat'),
    ('Dessert'),
    ('Boisson chaude'),
    ('Boisson froide'),
    ('Alcool');

-- Insertion de tous les plats en un seul bloc
INSERT INTO plats (nom, description, prix, type_id, restaurant_id, image)
SELECT nom, description, prix, type_id, restaurant_id, image
FROM (
    VALUES
        ('Salade César', 'Salade romaine, poulet grillé, croûtons, parmesan et sauce César.', 8.50, (SELECT id FROM type_plats WHERE nom = 'Entrée'), 1, 'assets/images/salade-cesar.webp'),
        ('Soupe à l’oignon', 'Soupe traditionnelle gratinée au fromage.', 6.90, (SELECT id FROM type_plats WHERE nom = 'Entrée'), 1, 'assets/images/soupejpg.jpg'),

        ('Steak frites', 'Pièce de bœuf grillée servie avec des frites maison.', 14.90, (SELECT id FROM type_plats WHERE nom = 'Plat'), 1, 'assets/images/steakfrite.jpg'),
        ('Pâtes carbonara', 'Spaghetti à la sauce crémeuse, lardons et parmesan.', 12.50, (SELECT id FROM type_plats WHERE nom = 'Plat'), 1, 'assets/images/patecarbo.webp'),

        ('Tiramisu', 'Dessert italien à base de mascarpone, café et cacao.', 5.90, (SELECT id FROM type_plats WHERE nom = 'Dessert'), 1, 'assets/images/tiramisu.jpg'),
        ('Crème brûlée', 'Crème à la vanille caramélisée.', 5.50, (SELECT id FROM type_plats WHERE nom = 'Dessert'), 1, 'assets/images/cremebrulee.webp'),

        ('Coca-Cola 33cl', 'Boisson gazeuse rafraîchissante.', 3.00, (SELECT id FROM type_plats WHERE nom = 'Boisson froide'), 1, 'assets/images/COCA-33cl.webp'),
        ('Jus d’orange', 'Pur jus d’orange frais pressé.', 3.20, (SELECT id FROM type_plats WHERE nom = 'Boisson froide'), 1, 'assets/images/jusdorange.png')
) AS plats_temp(nom, description, prix, type_id, restaurant_id, image)

