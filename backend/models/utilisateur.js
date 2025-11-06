const pool = require("../db");

class Utilisateur {
    static async findByEmail(email) {
        const result = await pool.query("SELECT * FROM utilisateurs WHERE email = $1", [email]);
        return result.rows[0];
    }

    static async create({ nom, email, password }) {
        const result = await pool.query(
            "INSERT INTO utilisateurs (nom, email, password) VALUES ($1, $2, $3) RETURNING id, nom, email",
            [nom, email, password]
        );
        return result.rows[0];
    }
}

module.exports = Utilisateur;
