const express = require('express');
const router = express.Router();
const reservationController = require('../controllers/reservationController');

// POST /api/reservations - créer une réservation
router.post('/', reservationController.createReservation);

// Récupérer toutes les réservations d’un restaurant
router.get('/restaurant/:id', reservationController.getReservationsByRestaurant);

// Récupérer toutes les réservations d’un utilisateur
router.get('/utilisateur/:id', reservationController.getReservationsByUtilisateur);
module.exports = router;
