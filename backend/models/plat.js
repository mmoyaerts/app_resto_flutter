const pool = require('../db');

class Plat {
  static async findByRestaurantId(restaurant_id) {
    const query = `
      SELECT p.*, t.nom AS type_nom
      FROM plats p
      JOIN type_plats t ON p.type_id = t.id
      WHERE p.restaurant_id = $1
      ORDER BY t.nom, p.nom;
    `;
    const { rows } = await pool.query(query, [restaurant_id]);
    return rows;
  }

    static async create({ nom, description, prix, type_id, restaurant_id, image }) {
    const query = `
      INSERT INTO plats (nom, description, prix, type_id, restaurant_id, image)
      VALUES ($1, $2, $3, $4, $5, $6)
      RETURNING *;
    `;
    const values = [nom, description, prix, type_id, restaurant_id, image];
    const { rows } = await pool.query(query, values);
    return rows[0];
  }

    static async update(id, { nom, description, prix, type_id, image }) {
    const query = `
      UPDATE plats
      SET nom = $1, description = $2, prix = $3, type_id = $4, image = $5
      WHERE id = $6
      RETURNING *;
    `;
    const values = [nom, description, prix, type_id, image, id];
    const { rows } = await pool.query(query, values);
    return rows[0];
  }

  // 🔹 Supprimer un plat
  static async delete(id) {
    const query = `DELETE FROM plats WHERE id = $1 RETURNING *;`;
    const { rows } = await pool.query(query, [id]);
    return rows[0];
  }

}

module.exports = Plat;
