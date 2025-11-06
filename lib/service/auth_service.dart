import 'dart:convert';
import 'package:http/http.dart' as http;

// À compléter avec la logique d'appel HTTP (package 'http' ou 'dio')
class AuthService {
  // TODO: Définir l'URL de base de votre API (Vérifiez l'adresse locale de votre API)
  // Remarque : 10.0.2.2 est l'adresse pour accéder au localhost depuis un émulateur Android.
  final String _baseUrl = 'http://10.0.2.2:3000/api/v1';

  /// Tente de connecter l'utilisateur et retourne le token JWT en cas de succès, sinon null.
  Future<String?> login(String email, String password) async {
    try {
      final response = await http.post(
          Uri.parse('$_baseUrl/login'), // Endpoint API de connexion [cite: 26]
          headers: {'Content-Type': 'application/json'},
    body: json.encode({
    'email': email,
    'password': password
    }),
    );

    if (response.statusCode == 200) {
    // TODO: Parser la réponse pour extraire le Token (JWT)
    final data = json.decode(response.body);
    // Ex: return data['token'];
    return 'fake-jwt-token'; // Token simulé si l'API n'est pas encore connectée
    } else {
    // Gérer les erreurs (identifiants invalides, etc.)
    print('Erreur de connexion : ${response.body}');
    return null;
    }
    } catch (e) {
    print('Erreur réseau lors de la connexion : $e');
    return null;
    }
  }

  /// Tente de créer un nouveau compte.
  Future<bool> register(String email, String password) async {
    try {
      final response = await http.post(
          Uri.parse('$_baseUrl/register'), // Endpoint API de création de compte [cite: 26]
          headers: {'Content-Type': 'application/json'},
    body: json.encode({
    'email': email,
    'password': password
    }),
    );

    // 201 Created ou 200 OK
    return response.statusCode >= 200 && response.statusCode < 300;
    } catch (e) {
    print('Erreur réseau lors de l\'inscription : $e');
    return false;
    }
  }

// TODO: Ajouter des méthodes pour la déconnexion, le stockage/récupération du JWT, etc.
}