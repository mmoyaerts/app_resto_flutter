const pool = require('../db');

class Reservation {
    // Vérifie si le restaurant est ouvert pour ce jour et cette heure
    static async checkAvailability(restaurant_id, date_reservation, heure) {
        try {
            console.log('🕒 Vérification disponibilité pour :', {
                restaurant_id,
                date_reservation,
                heure
            });

            const query = `
                SELECT *
                FROM ouverture
                WHERE restaurant_id = $1
                  AND TRIM(LOWER(jour)) = TRIM(LOWER(TO_CHAR($2::date, 'FMDay')))
                  AND heure_ouverture <= $3
                  AND heure_fermeture >= $3
            `;

            const { rows } = await pool.query(query, [
                restaurant_id,
                date_reservation,
                heure
            ]);

            console.log('📅 Créneaux trouvés :', rows.length);
            if (rows.length > 0) {
                console.log('✅ Le restaurant est ouvert.');
                return true;
            } else {
                console.warn('⚠️ Aucun créneau trouvé pour ce jour ou cette heure.');
                return false;
            }
        } catch (error) {
            console.error('❌ Erreur lors de la vérification de disponibilité :', error);
            throw error;
        }
    }

    // Création de réservation
// Création de réservation
static async create({ utilisateur_id, restaurant_id, date_reservation, heure, nombre_couverts, commentaire }) {
    const isAvailable = await this.checkAvailability(restaurant_id, date_reservation, heure);
    if (!isAvailable) {
        throw new Error('Le restaurant est fermé à cette date ou heure. Choisissez un autre créneau.');
    }

    const query = `
        INSERT INTO reservations (utilisateur_id, restaurant_id, date_reservation, heure, nombre_couverts, commentaire, statut_id)
        VALUES ($1, $2, $3, $4, $5, $6, 1) -- 1 = 'en attente'
        RETURNING *;
    `;
    const values = [utilisateur_id, restaurant_id, date_reservation, heure, nombre_couverts, commentaire];
    const { rows } = await pool.query(query, values);
    return rows[0];
}


    // Récupère toutes les réservations
    static async findAll() {
        const { rows } = await pool.query(`
            SELECT r.*, u.nom AS utilisateur_nom, res.nom AS restaurant_nom
            FROM reservations r
            JOIN utilisateurs u ON r.utilisateur_id = u.id
            JOIN restaurant res ON r.restaurant_id = res.id
            ORDER BY date_reservation DESC, heure DESC
        `);
        return rows;
    }
    static async findByRestaurant(restaurant_id) {
    const { rows } = await pool.query(`
        SELECT r.*, u.nom AS utilisateur_nom, res.nom AS restaurant_nom
        FROM reservations r
        JOIN utilisateurs u ON r.utilisateur_id = u.id
        JOIN restaurant res ON r.restaurant_id = res.id
        WHERE r.restaurant_id = $1
        ORDER BY date_reservation DESC, heure DESC
    `, [restaurant_id]);
    return rows;
}

// Récupère toutes les réservations d'un utilisateur
static async findByUtilisateur(utilisateur_id) {
    const { rows } = await pool.query(`
        SELECT r.*, u.nom AS utilisateur_nom, res.nom AS restaurant_nom
        FROM reservations r
        JOIN utilisateurs u ON r.utilisateur_id = u.id
        JOIN restaurant res ON r.restaurant_id = res.id
        WHERE r.utilisateur_id = $1
        ORDER BY date_reservation DESC, heure DESC
    `, [utilisateur_id]);
    return rows;
}

static async valider(id) {
    const query = `
        UPDATE reservations
        SET statut_id = 2 -- 2 = 'validée'
        WHERE id = $1
        RETURNING *;
    `;
    const { rows } = await pool.query(query, [id]);
    return rows[0];
}

static async refuser(id) {
    const query = `
        UPDATE reservations
        SET statut_id = 3 -- 3 = 'refusée'
        WHERE id = $1
        RETURNING *;
    `;
    const { rows } = await pool.query(query, [id]);
    return rows[0];
}

// Supprimer une réservation par l'utilisateur
static async supprimer(id) {
    // Vérifie que la réservation appartient à l'utilisateur et est en attente
    const checkQuery = `
        SELECT * FROM reservations
        WHERE id = $1 AND statut_id = 1; -- 1 = 'en attente'
    `;
    const { rows } = await pool.query(checkQuery, [id]);

    if (rows.length === 0) {
        throw new Error('Impossible de supprimer cette réservation (non trouvée ou déjà traitée).');
    }

    const deleteQuery = `
        DELETE FROM reservations
        WHERE id = $1
        RETURNING *;
    `;
    const result = await pool.query(deleteQuery, [id]);
    return result.rows[0];
}

}

module.exports = Reservation;
