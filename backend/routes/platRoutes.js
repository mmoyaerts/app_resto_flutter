const express = require('express');
const router = express.Router();
const platController = require('../controllers/platController');

// Récupérer tous les plats d’un restaurant
router.get('/restaurant/:restaurant_id', platController.getPlatsByRestaurant);


router.post('/', platController.createPlat);

// 🔹 Modifier un plat
router.put('/:id', platController.updatePlat);

// 🔹 Supprimer un plat
router.delete('/:id', platController.deletePlat);

module.exports = router;
