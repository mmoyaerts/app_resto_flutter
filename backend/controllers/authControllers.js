const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const Utilisateur = require("../models/utilisateur");

const JWT_SECRET = process.env.JWT_SECRET || "secret_jwt"; // Utilise une variable d'env

exports.register = async (req, res) => {
    const { nom, email, password } = req.body;

    if (!nom || !email || !password) {
        return res.status(400).json({ message: "Tous les champs sont requis" });
    }

    try {
        const existingUser = await Utilisateur.findByEmail(email);
        if (existingUser) {
            return res.status(400).json({ message: "Email déjà utilisé" });
        }

        const hashedPassword = await bcrypt.hash(password, 10);
        const newUser = await Utilisateur.create({ nom, email, password: hashedPassword });

        res.status(201).json({ message: "Utilisateur créé", user: newUser });
    } catch (err) {
        console.error(err);
        res.status(500).json({ message: "Erreur serveur" });
    }
};

exports.login = async (req, res) => {
    const { email, password } = req.body;

    if (!email || !password) {
        return res.status(400).json({ message: "Tous les champs sont requis" });
    }

    try {
        const user = await Utilisateur.findByEmail(email);
        if (!user) {
            return res.status(400).json({ message: "Email ou mot de passe incorrect" });
        }

        const validPassword = await bcrypt.compare(password, user.password);
        if (!validPassword) {
            return res.status(400).json({ message: "Email ou mot de passe incorrect" });
        }

        const token = jwt.sign({ id: user.id, email: user.email }, JWT_SECRET, { expiresIn: "1h" });
        res.status(200).json({ message: "Connexion réussie", token });
    } catch (err) {
        console.error(err);
        res.status(500).json({ message: "Erreur serveur" });
    }
};
