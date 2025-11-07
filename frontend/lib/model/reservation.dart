class Reservation {
  final int id;
  final int utilisateurId;
  final int restaurantId;
  final DateTime dateReservation;
  final String heure;
  final int nombreCouverts;
  final String commentaire;
  final String statut;
  final String utilisateurNom;
  final String restaurantNom;

  Reservation({
    required this.id,
    required this.utilisateurId,
    required this.restaurantId,
    required this.dateReservation,
    required this.heure,
    required this.nombreCouverts,
    required this.commentaire,
    required this.statut,
    required this.utilisateurNom,
    required this.restaurantNom,
  });

  /// Convertit un JSON en objet Reservation
  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['id'],
      utilisateurId: json['utilisateur_id'],
      restaurantId: json['restaurant_id'],
      dateReservation: DateTime.parse(json['date_reservation']),
      heure: json['heure'],
      nombreCouverts: json['nombre_couverts'],
      commentaire: json['commentaire'],
      statut: json['statut'],
      utilisateurNom: json['utilisateur_nom'],
      restaurantNom: json['restaurant_nom'],
    );
  }

  /// Convertit l'objet Reservation en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'utilisateur_id': utilisateurId,
      'restaurant_id': restaurantId,
      'date_reservation': dateReservation.toIso8601String(),
      'heure': heure,
      'nombre_couverts': nombreCouverts,
      'commentaire': commentaire,
      'statut': statut,
      'utilisateur_nom': utilisateurNom,
      'restaurant_nom': restaurantNom,
    };
  }
}
