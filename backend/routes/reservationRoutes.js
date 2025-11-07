const express = require('express');
const router = express.Router();
const {
  createReservation,
  getReservationsByRestaurant,
  getReservationsByUser,
  validerReservation,
  refuserReservation,
  deleteReservation
} = require('../controllers/reservationController');

/**
 * @swagger
 * tags:
 *   name: Reservations
 *   description: Gestion des réservations
 */

/**
 * @swagger
 * /reservations:
 *   post:
 *     summary: Créer une réservation
 *     tags: [Reservations]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               utilisateur_id:
 *                 type: integer
 *               restaurant_id:
 *                 type: integer
 *               date_reservation:
 *                 type: string
 *                 format: date
 *               heure:
 *                 type: string
 *               nombre_couverts:
 *                 type: integer
 *               commentaire:
 *                 type: string
 *             required:
 *               - utilisateur_id
 *               - restaurant_id
 *               - date_reservation
 *               - heure
 *               - nombre_couverts
 *     responses:
 *       201:
 *         description: Réservation créée
 *       400:
 *         description: Erreur création réservation
 */
router.post('/', createReservation);

/**
 * @swagger
 * /reservations/restaurant/{id}:
 *   get:
 *     summary: Liste des réservations d'un restaurant
 *     tags: [Reservations]
 *     parameters:
 *       - in: path
 *         name: id
 *         schema:
 *           type: integer
 *         required: true
 *         description: ID du restaurant
 *     responses:
 *       200:
 *         description: Liste des réservations
 */
router.get('/restaurant/:id', getReservationsByRestaurant);

/**
 * @swagger
 * /reservations/utilisateur/{id}:
 *   get:
 *     summary: Liste des réservations d'un utilisateur
 *     tags: [Reservations]
 *     parameters:
 *       - in: path
 *         name: id
 *         schema:
 *           type: integer
 *         required: true
 *         description: ID de l'utilisateur
 *     responses:
 *       200:
 *         description: Liste des réservations
 */
router.get('/utilisateur/:id', getReservationsByUser);

/**
 * @swagger
 * /reservations/{id}/valider:
 *   patch:
 *     summary: Valider une réservation (serveur uniquement)
 *     tags: [Reservations]
 *     parameters:
 *       - in: path
 *         name: id
 *         schema:
 *           type: integer
 *         required: true
 *         description: ID de la réservation
 *     responses:
 *       200:
 *         description: Réservation validée
 */
router.patch('/:id/valider', validerReservation);

/**
 * @swagger
 * /reservations/{id}/refuser:
 *   patch:
 *     summary: Refuser une réservation (serveur uniquement)
 *     tags: [Reservations]
 *     parameters:
 *       - in: path
 *         name: id
 *         schema:
 *           type: integer
 *         required: true
 *         description: ID de la réservation
 *     responses:
 *       200:
 *         description: Réservation refusée
 */
router.patch('/:id/refuser', refuserReservation);

/**
 * @swagger
 * /reservations/{id}:
 *   delete:
 *     summary: Supprimer une réservation (si en attente)
 *     tags: [Reservations]
 *     parameters:
 *       - in: path
 *         name: id
 *         schema:
 *           type: integer
 *         required: true
 *         description: ID de la réservation
 *     responses:
 *       200:
 *         description: Réservation supprimée
 */
router.delete('/:id', deleteReservation);

module.exports = router;
