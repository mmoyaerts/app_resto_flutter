# 🍽️ Mini-projet de réservation pour un restaurant

## 📖 Description

Cette application permet aux utilisateurs de consulter le menu d'un restaurant et de réserver une table via une application Flutter. Les serveurs et administrateurs peuvent gérer les réservations et le menu. L'application est composée d'un frontend Flutter et d'une API Node.js/Express avec une base PostgreSQL.

## 🔧 Technologies utilisées

| Catégorie                   | Technologie / Outil                |
| --------------------------- | ---------------------------------- |
| **Frontend Mobile**         | Flutter (Dart)                     |
| **Backend**                 | Node.js + Express                  |
| **Base de données**         | PostgreSQL                         |
| **Conteneurisation**        | Docker                             |
| **Gestion des dépendances** | npm / pub                          |
| **Versionning**             | Git / GitHub                       |
| **IDE recommandés**         | Visual Studio Code, Android Studio |

## ✨ Fonctionnalités réalisées

### 👥 Utilisateurs

* Inscription avec rôle (`client`, `serveur`, `admin`)
* Connexion / Déconnexion
* Suppression de compte

### 🍴 Restaurants

* Création et gestion d’un restaurant par l’administrateur
* Définition des horaires d’ouverture

### 📅 Réservations

* Création de réservation uniquement pendant les horaires d’ouverture
* Validation / refus uniquement par un serveur
* Suppression par l’utilisateur si la réservation est en attente

### 🥗 Plats & Menu

* Création, modification et suppression de plats par le restaurateur
* Association des plats à un type (`entrée`, `plat`, `dessert`, `boisson`)
* Affichage de tous les plats d’un restaurant
* Stockage du chemin d’image pour chaque plat

### 🗄️ Base de données

Tables principales : `utilisateurs`, `restaurant`, `ouverture`, `reservations`, `statut_reservation`, `type_plats`, `plats`

## 📚 API Endpoints

| Méthode | Endpoint                             | Description                                  | Données JSON attendues (exemple)                                                                                                                             | Réponse attendue (exemple)                                             |
| ------- | ------------------------------------ | -------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------ | ---------------------------------------------------------------------- |
| POST    | /api/utilisateurs/register           | Inscription utilisateur                      | `{ "nom": "Alice", "email": "alice@mail.com", "password": "123", "role_id": 1 }`                                                                             | `{ "id": 1, "nom": "Alice", "email": "alice@mail.com", "role_id": 1 }` |
| POST    | /api/utilisateurs/login              | Connexion utilisateur                        | `{ "email": "alice@mail.com", "password": "123" }`                                                                                                           | `{ "token": "jwt_token_here" }`                                        |
| POST    | /api/reservations                    | Créer une réservation                        | `{ "utilisateur_id":1, "restaurant_id":1, "date_reservation":"2025-11-07", "heure":"13:00", "nombre_couverts":4, "commentaire":"Table près de la fenêtre" }` | `{ "id":34, "utilisateur_id":1, "restaurant_id":1, ... }`              |
| PATCH   | /api/reservations/:id/valider        | Valider une réservation (serveur uniquement) | `{}`                                                                                                                                                         | `{ "id":34, "statut_id":2 }`                                           |
| PATCH   | /api/reservations/:id/refuser        | Refuser une réservation                      | `{}`                                                                                                                                                         | `{ "id":34, "statut_id":3 }`                                           |
| DELETE  | /api/reservations/:id                | Supprimer sa réservation si en attente       | `{}`                                                                                                                                                         | `{ "message": "Réservation supprimée" }`                               |
| GET     | /api/reservations/restaurant/:id     | Liste des réservations d’un restaurant       | N/A                                                                                                                                                          | `[ {...}, {...} ]`                                                     |
| GET     | /api/reservations/utilisateur/:id    | Liste des réservations d’un utilisateur      | N/A                                                                                                                                                          | `[ {...}, {...} ]`                                                     |
| GET     | /api/plats/restaurant/:restaurant_id | Liste des plats d’un restaurant              | N/A                                                                                                                                                          | `[ {...}, {...} ]`                                                     |
| POST    | /api/plats                           | Créer un plat                                | `{ "nom":"Salade César", "description":"", "prix":10.5, "type_id":1, "restaurant_id":1, "image":"assets/images/salade-cesar.webp" }`                         | `{ "id":1, "nom":"Salade César", ... }`                                |
| PUT     | /api/plats/:id                       | Modifier un plat                             | `{ "nom":"Nouvelle salade", "prix":12 }`                                                                                                                     | `{ "id":1, "nom":"Nouvelle salade", ... }`                             |
| DELETE  | /api/plats/:id                       | Supprimer un plat                            | N/A                                                                                                                                                          | `{ "message": "Plat supprimé" }`                                       |

## 🚀 Instructions de lancement

### 🧩 1️⃣ Lancer l’API Node.js

#### Étapes :

1. Ouvrir un terminal dans le dossier `backend/`.
2. Installer les dépendances :

```bash
npm install
```

3. Lancer PostgreSQL avec Docker :

```bash
docker-compose up -d
```

4. Créer la base de données si nécessaire :

```bash
docker exec -it postgres_db psql -U user -d postgres -c "CREATE DATABASE restaurant;"
```

5. Lancer le serveur Node.js :

```bash
npm start
```

L’API est accessible sur : [http://localhost:3000/api](http://localhost:3000/api)

---

### 📱 2️⃣ Lancer l’application Flutter

#### Étapes :

1. Ouvrir un terminal dans le dossier `app_resto_flutter/`.
2. Installer les dépendances :

```bash
flutter pub get
```

3. Configurer l’URL de l’API dans `lib/services/api.dart` :

```dart
const String apiUrl = "http://localhost:3000/api";
```

4. Lancer l’application :

```bash
flutter run
```

## 👨‍👩‍👧‍👦 Groupe

* **Nom du groupe :** Les Petits Cochons
* **Membres :** 
    - Mathieu MOYAERTS : Back/API en NodeJS/Express
    - Liam ROUSTAN : Maquette Figma + aide de Thomas en Front
    - Thomas LETOUBLON : Front en Flutter

**PS :** Les photos et vidéos de l'application sont dans le dossier `annexes` du GitHub.
