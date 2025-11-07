const express = require('express');
const router = express.Router();
const reservationController = require('../controllers/reservationController');

router.post('/', reservationController.createReservation);

router.get('/restaurant/:id', reservationController.getReservationsByRestaurant);

router.get('/utilisateur/:id', reservationController.getReservationsByUtilisateur);

router.patch('/:id/valider', reservationController.validerReservation);
router.patch('/:id/refuser', reservationController.refuserReservation);

router.delete('/:id', reservationController.supprimerReservation);

module.exports = router;

