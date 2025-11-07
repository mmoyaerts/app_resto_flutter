const express = require('express');
const router = express.Router();
const { getPlatsByRestaurant, createPlat, updatePlat, deletePlat } = require('../controllers/platController');

/**
 * @swagger
 * tags:
 *   name: Plats
 *   description: Gestion des plats
 */

/**
 * @swagger
 * /plats/restaurant/{restaurant_id}:
 *   get:
 *     summary: Récupérer tous les plats d'un restaurant
 *     tags: [Plats]
 *     parameters:
 *       - in: path
 *         name: restaurant_id
 *         schema:
 *           type: integer
 *         required: true
 *         description: ID du restaurant
 *     responses:
 *       200:
 *         description: Liste des plats
 */
router.get('/restaurant/:restaurant_id', getPlatsByRestaurant);

/**
 * @swagger
 * /plats:
 *   post:
 *     summary: Créer un plat
 *     tags: [Plats]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               nom:
 *                 type: string
 *               description:
 *                 type: string
 *               prix:
 *                 type: number
 *               type_id:
 *                 type: integer
 *               restaurant_id:
 *                 type: integer
 *               image:
 *                 type: string
 *             required:
 *               - nom
 *               - prix
 *               - type_id
 *               - restaurant_id
 *     responses:
 *       201:
 *         description: Plat créé
 */
router.post('/', createPlat);

/**
 * @swagger
 * /plats/{id}:
 *   put:
 *     summary: Modifier un plat
 *     tags: [Plats]
 *     parameters:
 *       - in: path
 *         name: id
 *         schema:
 *           type: integer
 *         required: true
 *         description: ID du plat
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               nom:
 *                 type: string
 *               description:
 *                 type: string
 *               prix:
 *                 type: number
 *               image:
 *                 type: string
 *     responses:
 *       200:
 *         description: Plat modifié
 */
router.put('/:id', updatePlat);

/**
 * @swagger
 * /plats/{id}:
 *   delete:
 *     summary: Supprimer un plat
 *     tags: [Plats]
 *     parameters:
 *       - in: path
 *         name: id
 *         schema:
 *           type: integer
 *         required: true
 *         description: ID du plat
 *     responses:
 *       200:
 *         description: Plat supprimé
 */
router.delete('/:id', deletePlat);

module.exports = router;
