import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/reservation.dart';
import '../providers/auth_provider.dart';
import '../service/reservation_service.dart';

class ReservationCard extends StatelessWidget {
  final Reservation reservation;
  final VoidCallback? onRefresh; // callback pour rafraîchir la liste

  const ReservationCard({
    super.key,
    required this.reservation,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final reservationService = ReservationService();

    final dateStr =
        '${reservation.dateReservation.day.toString().padLeft(2, '0')}/${reservation.dateReservation.month.toString().padLeft(2, '0')}/${reservation.dateReservation.year}';

    Future<void> updateStatus(String action) async {
      bool success = false;
      if (action == 'confirmé') {
        success = await reservationService.validerReservation(reservation.id, auth.role!);
      } else if (action == 'annulé') {
        success = await reservationService.refuserReservation(reservation.id, auth.role!);
      }

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Réservation ${action} avec succès')),
        );
        if (onRefresh != null) onRefresh!(); // rafraîchir la liste
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur lors de la mise à jour')),
        );
      }
    }

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
                Text('Date : $dateStr', style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('Heure : ${reservation.heure}', style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Client : ${reservation.utilisateurNom}'),
                Text('Couverts : ${reservation.nombreCouverts}'),
              ],
            ),
            const SizedBox(height: 8),
            if (reservation.commentaire.isNotEmpty) Text('Commentaire : ${reservation.commentaire}'),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('Statut : '),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(reservation.statut),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(reservation.statut, style: const TextStyle(color: Colors.white)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Boutons pour role 2 et réservation en attente
            if (auth.role == 2 && reservation.statut.toLowerCase() == 'en attente')
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () => updateStatus('confirmé'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text('Valider'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => updateStatus('annulé'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text('Refuser'),
                  ),
                ],
              ),
            // Bouton Supprimer pour role 1
            if (auth.role == 1 && reservation.statut.toLowerCase() == 'en attente')
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      bool success = await reservationService.deleteReservation(reservation.id, auth.role!);
                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Réservation supprimée avec succès')),
                        );
                        if (onRefresh != null) onRefresh!();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Erreur lors de la suppression')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text('Supprimer'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

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
