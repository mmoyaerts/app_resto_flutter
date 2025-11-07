import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/reservation.dart';

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
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

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
  Future<List<Reservation>?> getReservationsByUser(int userId) async {
    final url = Uri.parse('$_baseUrl/utilisateur/$userId');

    try {
      final response = await http.get(url, headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        // Convertir chaque Map JSON en Reservation
        return data.map((json) => Reservation.fromJson(json)).toList();
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }


  /// Récupérer les réservations par restaurant
  Future<List<dynamic>?> getReservationsByRestaurant(int restaurantId) async {
    final url = Uri.parse('$_baseUrl/restaurant/$restaurantId');

    try {
      final response = await http.get(url, headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        return jsonDecode(response.body); // renvoie la liste de réservations
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  /// Valider une réservation en envoyant le rôle
  Future<bool> validerReservation(int idReservation, int role) async {
    final url = Uri.parse('$_baseUrl/$idReservation/valider');

    try {
      final body = jsonEncode({
        'role_id': role,
      });

      final response = await http.patch(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['statut_id'] == 2;
      } else {
        print('❌ Erreur validation réservation : ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('❌ Exception validation réservation : $e');
      return false;
    }
  }

  /// Refuser une réservation
  Future<bool> refuserReservation(int idReservation, int role) async {
    final url = Uri.parse('$_baseUrl/$idReservation/refuser');

    try {
      final body = jsonEncode({
        'role_id': role,
      });

      final response = await http.patch(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['statut_id'] == 3;
      } else {
        print('❌ Erreur refus réservation : ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('❌ Exception refus réservation : $e');
      return false;
    }
  }
}
