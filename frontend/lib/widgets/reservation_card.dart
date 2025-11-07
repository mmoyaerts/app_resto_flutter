import 'package:flutter/material.dart';
import '../model/reservation.dart'; // adapte le chemin

class ReservationCard extends StatelessWidget {
  final Reservation reservation;

  const ReservationCard({super.key, required this.reservation});

  @override
  Widget build(BuildContext context) {
    // Formater la date en JJ/MM/AAAA
    final dateStr =
        '${reservation.dateReservation.day.toString().padLeft(2, '0')}/${reservation.dateReservation.month.toString().padLeft(2, '0')}/${reservation.dateReservation.year}';

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date et heure
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Date : $dateStr',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Heure : ${reservation.heure}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Nom et nombre de couverts
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Client : ${reservation.utilisateurNom}'),
                Text('Couverts : ${reservation.nombreCouverts}'),
              ],
            ),
            const SizedBox(height: 8),
            // Commentaire
            if (reservation.commentaire.isNotEmpty)
              Text('Commentaire : ${reservation.commentaire}'),
            const SizedBox(height: 8),
            // Statut avec couleur
            Row(
              children: [
                const Text('Statut : '),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(reservation.statut),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    reservation.statut,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Méthode pour choisir la couleur selon le statut
  Color _getStatusColor(String statut) {
    switch (statut.toLowerCase()) {
      case 'confirmé':
        return Colors.green;
      case 'annulé':
        return Colors.red;
      case 'en attente':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
