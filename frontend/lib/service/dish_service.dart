// Fichier : lib/service/dish_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/dish.dart';

class DishService {
  final String _baseUrl = 'http://localhost:3000/api/plats';

  /// Récupère tous les plats pour un restaurant spécifique.
  /// On utilise l'ID '1' par défaut.
  Future<List<Dish>> fetchDishes(int restaurantId) async {
    // Le plat.js backend utilise findByRestaurantId, donc l'URL doit inclure l'ID.
    final url = Uri.parse('$_baseUrl/restaurant/$restaurantId');

    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);

        // Convertit la liste JSON en une liste d'objets Dish
        return jsonList.map((json) => Dish.fromJson(json)).toList();
      } else {
        print('❌ Erreur API lors de la récupération des plats: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('❌ Exception réseau lors de la récupération des plats: $e');
      return [];
    }
  }
}