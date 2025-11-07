const Reservation = require('../models/reservation');

exports.createReservation = async (req, res) => {
  try {
    console.log('🧾 Données reçues :', req.body);

const { utilisateur_id, restaurant_id, date_reservation, heure, nombre_couverts, commentaire } = req.body;

    if (!utilisateur_id || !restaurant_id || !date_reservation || !heure || !nombre_couverts) {
      console.warn('⚠️ Données incomplètes reçues, requête ignorée.');
      return res.status(400).json({ message: 'Tous les champs sont requis.' });
    }

const reservation = await Reservation.create({
    utilisateur_id,
    restaurant_id,
    date_reservation,
    heure,
    nombre_couverts,
    commentaire
});

    res.status(201).json(reservation);
  } catch (error) {
    console.error('❌ Erreur création réservation :', error);
    res.status(400).json({ message: error.message });
  }
};

// Récupérer toutes les réservations d'un restaurant
exports.getReservationsByRestaurant = async (req, res) => {
    try {
        const { id } = req.params;
        const reservations = await Reservation.findByRestaurant(id);
        res.status(200).json(reservations);
    } catch (error) {
        console.error('❌ Erreur récupération réservations restaurant :', error);
        res.status(500).json({ message: error.message });
    }
};

// Récupérer toutes les réservations d'un utilisateur
exports.getReservationsByUtilisateur = async (req, res) => {
    try {
        const { id } = req.params;
        const reservations = await Reservation.findByUtilisateur(id);
        res.status(200).json(reservations);
    } catch (error) {
        console.error('❌ Erreur récupération réservations utilisateur :', error);
        res.status(500).json({ message: error.message });
    }
};
