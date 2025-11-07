import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../service/reservation_service.dart';
import '../model/reservation.dart';
import '../widgets/reservation_card.dart';
import 'login_screen.dart';

class ReservationPage extends StatefulWidget {
  const ReservationPage({super.key});

  @override
  State<ReservationPage> createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  DateTime? _selectedDate;
  String? _selectedTimeStr;
  int _numberOfPeople = 1;
  final TextEditingController _commentController = TextEditingController();
  bool _isSubmitting = false;

  final ReservationService _reservationService = ReservationService();
  late Future<List<Reservation>?> _futureReservations;

  @override
  void initState() {
    super.initState();
    final auth = Provider.of<AuthProvider>(context, listen: false);
    _futureReservations = _reservationService.getReservationsByUser(auth.id!);
  }

  List<String> _generateTimeSlots() {
    List<String> slots = [];

    // Midi : 11h00 -> 15h00
    for (int hour = 11; hour <= 15; hour++) {
      slots.add('${hour.toString().padLeft(2, '0')}:00');
      if (hour != 15) slots.add('${hour.toString().padLeft(2, '0')}:30');
    }

    // Soir : 19h00 -> 22h00
    for (int hour = 19; hour <= 22; hour++) {
      slots.add('${hour.toString().padLeft(2, '0')}:00');
      if (hour != 22) slots.add('${hour.toString().padLeft(2, '0')}:30');
    }

    return slots;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 1),
      locale: const Locale('fr', 'FR'),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _submitReservation() async {
    if (_selectedDate == null || _selectedTimeStr == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez choisir une date et une heure.')),
      );
      return;
    }

    final auth = Provider.of<AuthProvider>(context, listen: false);
    if (!auth.isLoggedIn) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vous devez être connecté pour réserver.')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    // Date + heure
    final parts = _selectedTimeStr!.split(':');
    final reservationDate = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );

    final dateStr =
        '${reservationDate.year}-${reservationDate.month.toString().padLeft(2,'0')}-${reservationDate.day.toString().padLeft(2,'0')}';
    final heureStr = _selectedTimeStr!;

    final response = await _reservationService.createReservation(
      userId: auth.id!,
      date: dateStr,
      heure: heureStr,
      commentaire: _commentController.text,
      nombreCouvert: _numberOfPeople,
    );

    setState(() => _isSubmitting = false);

    if (response?['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Réservation confirmée le $dateStr à $heureStr pour $_numberOfPeople personne(s).',
          ),
        ),
      );

      _commentController.clear();
      setState(() {
        _selectedDate = null;
        _selectedTimeStr = null;
        _numberOfPeople = 1;
        _futureReservations = _reservationService.getReservationsByUser(auth.id!);
      });
    } else {
      final message = response?['message'] ?? 'Erreur inconnue';
      final code = response?['statusCode'] != null ? ' (Code: ${response?['statusCode']})' : '';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur réservation: $message$code')),
      );
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    if (!auth.isLoggedIn) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Vous devez être connecté pour réserver.',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                },
                child: const Text('Se connecter'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Liste des réservations de l'utilisateur
              FutureBuilder<List<Reservation>?>(
                future: _futureReservations,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Erreur : ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('Aucune réservation trouvée.'));
                  }

                  final reservations = snapshot.data!;
                  return Column(
                    children: reservations
                        .map((res) => ReservationCard(reservation: res))
                        .toList(),
                  );
                },
              ),

              const SizedBox(height: 30),

              const Text(
                'Nouvelle réservation',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 20),

              // Sélection de la date
              const Text(
                'Choisissez votre date :',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: () => _selectDate(context),
                icon: const Icon(Icons.calendar_today),
                label: Text(
                  _selectedDate == null
                      ? 'Sélectionner une date'
                      : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                ),
              ),
              const SizedBox(height: 20),

              // Sélection de l'heure
              const Text(
                'Choisissez votre heure :',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              DropdownButton<String>(
                value: _selectedTimeStr,
                hint: const Text('Sélectionner une heure'),
                items: _generateTimeSlots().map((time) {
                  return DropdownMenuItem(
                    value: time,
                    child: Text(time),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedTimeStr = value;
                  });
                },
              ),
              const SizedBox(height: 20),

              // Nombre de couverts
              const Text(
                'Nombre de personnes :',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              DropdownButton<int>(
                value: _numberOfPeople,
                items: List.generate(10, (index) => index + 1)
                    .map((e) => DropdownMenuItem(
                  value: e,
                  child: Text(e.toString()),
                ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) setState(() => _numberOfPeople = value);
                },
              ),
              const SizedBox(height: 20),

              // Commentaire
              const Text(
                'Commentaire :',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _commentController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Exemple : Je veux une table en terrasse...',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30),

              // Bouton confirmer
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submitReservation,
                style: ElevatedButton.styleFrom(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: _isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Confirmer la réservation',
                    style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
