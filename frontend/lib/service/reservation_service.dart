import 'dart:convert';
import 'package:http/http.dart' as http;

class ReservationService {
  final String _baseUrl = 'http://localhost:3000/api/reservations';

  /// Créer une réservation
  Future<Map<String, dynamic>?> createReservation({
    required int userId,
    required String date,
    required String heure,
    required String commentaire,
    required int nombreCouvert,
  }) async {
    final url = Uri.parse('$_baseUrl');

    final body = jsonEncode({
      'utilisateur_id': userId,
      'restaurant_id': 1,
      'date_reservation': date,
      'heure': heure,
      'commentaire': commentaire,
      'nombre_couverts': nombreCouvert,
    });
    print('📤 Body envoyé: $body');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      print('📥 Status: ${response.statusCode}');
      print('📥 Réponse: ${response.body}');

      if (response.statusCode == 201) {
        return {
          'success': true,
          'data': jsonDecode(response.body),
        };
      } else {
        return {
          'success': false,
          'statusCode': response.statusCode,
          'message': response.body,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  /// Récupérer les réservations par utilisateur
  Future<List<dynamic>?> getReservationsByUser(int userId) async {
    final url = Uri.parse('$_baseUrl/utilisateur/$userId');

    try {
      final response = await http.get(url, headers: {'Content-Type': 'application/json'});

      print('📥 Status: ${response.statusCode}');
      print('📥 Réponse: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body); // renvoie la liste de réservations
      } else {
        print('❌ Erreur récupération réservations utilisateur');
        return null;
      }
    } catch (e) {
      print('❌ Exception récupération réservations utilisateur: $e');
      return null;
    }
  }

  /// Récupérer les réservations par restaurant
  Future<List<dynamic>?> getReservationsByRestaurant(int restaurantId) async {
    final url = Uri.parse('$_baseUrl/restaurant/$restaurantId');

    try {
      final response = await http.get(url, headers: {'Content-Type': 'application/json'});

      print('📥 Status: ${response.statusCode}');
      print('📥 Réponse: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body); // renvoie la liste de réservations
      } else {
        print('❌ Erreur récupération réservations restaurant');
        return null;
      }
    } catch (e) {
      print('❌ Exception récupération réservations restaurant: $e');
      return null;
    }
  }
}
