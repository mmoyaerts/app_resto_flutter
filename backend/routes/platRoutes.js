const express = require('express');
const router = express.Router();
const platController = require('../controllers/platController');

router.get('/restaurant/:restaurant_id', platController.getPlatsByRestaurant);


router.post('/', platController.createPlat);

router.put('/:id', platController.updatePlat);

router.delete('/:id', platController.deletePlat);

module.exports = router;
