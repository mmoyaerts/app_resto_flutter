class Reservation {
  final int id;
  final DateTime dateReservation;
  final String heure;
  final int nombreCouverts;
  final String utilisateurNom;
  final String commentaire;
  final String statut;

  Reservation({
    required this.id,
    required this.dateReservation,
    required this.heure,
    required this.nombreCouverts,
    required this.utilisateurNom,
    required this.commentaire,
    required this.statut,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['id'] ?? 0,
      dateReservation: DateTime.parse(json['date_reservation']),
      heure: json['heure'] ?? '',
      nombreCouverts: json['nombre_couverts'] ?? 0,
      utilisateurNom: json['utilisateur_nom'] ?? '',
      commentaire: json['commentaire'] ?? '',
      // Convertir statut_id en texte (exemple)
      statut: _statutFromId(json['statut_id']),
    );
  }

  static String _statutFromId(dynamic id) {
    switch (id) {
      case 1:
        return 'en attente';
      case 2:
        return 'confirmé';
      case 3:
        return 'annulé';
      default:
        return 'inconnu';
    }
  }
}
