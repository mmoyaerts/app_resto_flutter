const express = require('express');
const router = express.Router();
const { register, login } = require('../controllers/authController');

/**
 * @swagger
 * tags:
 *   name: Utilisateurs
 *   description: Gestion des utilisateurs
 */

/**
 * @swagger
 * /utilisateurs/register:
 *   post:
 *     summary: Inscription d'un utilisateur
 *     tags: [Utilisateurs]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               nom:
 *                 type: string
 *               email:
 *                 type: string
 *               password:
 *                 type: string
 *               role_id:
 *                 type: integer
 *             required:
 *               - nom
 *               - email
 *               - password
 *               - role_id
 *     responses:
 *       201:
 *         description: Utilisateur créé
 *       400:
 *         description: Erreur lors de l'inscription
 */
router.post('/register', register);

/**
 * @swagger
 * /utilisateurs/login:
 *   post:
 *     summary: Connexion utilisateur
 *     tags: [Utilisateurs]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               email:
 *                 type: string
 *               password:
 *                 type: string
 *             required:
 *               - email
 *               - password
 *     responses:
 *       200:
 *         description: Connexion réussie avec token JWT
 *       400:
 *         description: Erreur lors de la connexion
 */
router.post('/login', login);

module.exports = router;

