const express = require('express');
const router = express.Router();
const reservationController = require('../controllers/reservationController');

// POST /api/reservations - créer une réservation
router.post('/', reservationController.createReservation);

// GET /api/reservations/:utilisateur_id - récupérer les réservations d’un utilisateur

// DELETE /api/reservations/:id - annuler une réservation

module.exports = router;
