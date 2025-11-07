const pool = require('../db');

class Utilisateur {
  static async create(nom, email, password, role_id) {
    const result = await pool.query(
      'INSERT INTO utilisateurs (nom, email, password, role_id) VALUES ($1, $2, $3, $4) RETURNING *',
      [nom, email, password, role_id]
    );
    return result.rows[0];
  }

  static async findByEmail(email) {
    const result = await pool.query('SELECT * FROM utilisateurs WHERE email = $1', [email]);
    return result.rows[0];
  }
}

module.exports = Utilisateur;
