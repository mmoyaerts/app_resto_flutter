const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const Utilisateur = require('../models/utilisateur');

exports.register = async (req, res) => {
  const { nom, email, password, role_id } = req.body;

  if (!nom || !email || !password || !role_id) {
    return res.status(400).json({ message: 'Tous les champs (nom, email, password, role_id) sont requis.' });
  }

  try {
    const existingUser = await Utilisateur.findByEmail(email);
    if (existingUser) {
      return res.status(400).json({ message: 'Un utilisateur avec cet email existe déjà.' });
    }

    const hashedPassword = await bcrypt.hash(password, 10);
    const newUser = await Utilisateur.create(nom, email, hashedPassword, role_id);

    res.status(201).json({
      message: 'Utilisateur créé avec succès',
      utilisateur: { id: newUser.id, nom: newUser.nom, email: newUser.email, role_id: newUser.role_id },
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Erreur serveur', error });
  }
};

exports.login = async (req, res) => {
  const { email, password } = req.body;

  if (!email || !password) {
    return res.status(400).json({ message: 'Email et mot de passe requis.' });
  }

  try {
    const user = await Utilisateur.findByEmail(email);
    if (!user) {
      return res.status(400).json({ message: 'Utilisateur non trouvé.' });
    }

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(401).json({ message: 'Mot de passe incorrect.' });
    }

    const token = jwt.sign(
      { id: user.id, role_id: user.role_id },
      process.env.JWT_SECRET || 'secret',
      { expiresIn: '1h' }
    );

    res.status(200).json({
      message: 'Connexion réussie',
      token,
      utilisateur: { id: user.id, nom: user.nom, email: user.email, role_id: user.role_id },
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Erreur serveur', error });
  }
};
