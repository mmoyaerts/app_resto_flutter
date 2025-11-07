const Plat = require('../models/plat');

exports.getPlatsByRestaurant = async (req, res) => {
  try {
    const { restaurant_id } = req.params;

    if (!restaurant_id) {
      return res.status(400).json({ message: "L'ID du restaurant est requis." });
    }

    const plats = await Plat.findByRestaurantId(restaurant_id);

    if (plats.length === 0) {
      return res.status(404).json({ message: "Aucun plat trouvé pour ce restaurant." });
    }

    res.status(200).json(plats);
  } catch (error) {
    console.error('❌ Erreur récupération plats :', error);
    res.status(500).json({ message: 'Erreur serveur lors de la récupération des plats.' });
  }
};

exports.createPlat = async (req, res) => {
  try {
    const { nom, description, prix, type_id, restaurant_id, image } = req.body;

    if (!nom || !prix || !type_id || !restaurant_id) {
      return res.status(400).json({
        message: "Les champs nom, prix, type_id et restaurant_id sont obligatoires."
      });
    }

    const plat = await Plat.create({
      nom,
      description,
      prix,
      type_id,
      restaurant_id,
      image
    });

    res.status(201).json({
      message: 'Plat créé avec succès',
      plat
    });
  } catch (error) {
    console.error('❌ Erreur création plat :', error);
    res.status(500).json({ message: 'Erreur serveur lors de la création du plat.' });
  }
};

exports.updatePlat = async (req, res) => {
  try {
    const { id } = req.params;
    const { nom, description, prix, type_id, image } = req.body;

    if (!nom || !prix || !type_id) {
      return res.status(400).json({ message: "Les champs nom, prix et type_id sont obligatoires." });
    }

    const plat = await Plat.update(id, { nom, description, prix, type_id, image });

    if (!plat) {
      return res.status(404).json({ message: "Plat non trouvé." });
    }

    res.status(200).json({ message: "Plat modifié avec succès", plat });
  } catch (error) {
    console.error('❌ Erreur modification plat :', error);
    res.status(500).json({ message: "Erreur serveur lors de la modification du plat." });
  }
};

exports.deletePlat = async (req, res) => {
  try {
    const { id } = req.params;
    const plat = await Plat.delete(id);

    if (!plat) {
      return res.status(404).json({ message: "Plat non trouvé." });
    }

    res.status(200).json({ message: "Plat supprimé avec succès." });
  } catch (error) {
    console.error('❌ Erreur suppression plat :', error);
    res.status(500).json({ message: "Erreur serveur lors de la suppression du plat." });
  }
};