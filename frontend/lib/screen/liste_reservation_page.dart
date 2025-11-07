import 'package:flutter/material.dart';
import '../model/reservation.dart';
import '../service/reservation_service.dart';
import '../widgets/reservation_card.dart';

class ListeReservationPage extends StatefulWidget {
  final int restaurantId;

  const ListeReservationPage({super.key, required this.restaurantId});

  @override
  State<ListeReservationPage> createState() => _ListeReservationPageState();
}

class _ListeReservationPageState extends State<ListeReservationPage> {
  late Future<List<Reservation>?> _futureReservations;
  final ReservationService _reservationService = ReservationService();

  @override
  void initState() {
    super.initState();
    _futureReservations =
        _loadReservations(); // charge les réservations au démarrage
  }

  Future<List<Reservation>?> _loadReservations() async {
    final data =
    await _reservationService.getReservationsByRestaurant(widget.restaurantId);

    if (data != null) {
      // Transformer la liste JSON en objets Reservation
      return data.map<Reservation>((json) => Reservation.fromJson(json)).toList();
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Liste des réservations')),
      body: FutureBuilder<List<Reservation>?>(
        future: _futureReservations,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Chargement
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Erreur
            return Center(child: Text('Erreur : ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Liste vide
            return const Center(child: Text('Aucune réservation trouvée.'));
          }

          // Liste des réservations
          final reservations = snapshot.data!;

          return ListView.builder(
            itemCount: reservations.length,
            itemBuilder: (context, index) {
              return ReservationCard(
                reservation: reservations[index],
                onRefresh: () {
                  // Mettre à jour la liste après action
                  setState(() {
                    _futureReservations = _loadReservations();
                  });
                },
              );
            },
          );
        },
      ),
    );
  }
}
