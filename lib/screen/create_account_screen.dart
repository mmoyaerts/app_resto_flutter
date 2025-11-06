import 'package:flutter/material.dart';
import '../widgets/custom_text_field.dart';
// Note : Vous devrez ajuster cet import si le nom de votre projet n'est pas 'resto_app'
// import 'package:resto_app/service/auth_service.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // TODO[cite: 102]: Implémenter la logique de création de compte (email/mot de passe minimum)
      // Ex: final authService = AuthService();
      // Ex: final success = await authService.register(_emailController.text, _passwordController.text);

      await Future.delayed(const Duration(seconds: 1)); // Simulation d'appel API

      setState(() {
        _isLoading = false;
      });

      if (true) { // Remplacez 'true' par la réponse réelle de l'API
        print('Compte créé : Naviguer vers l\'écran de connexion');
        // Afficher un message de succès
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Compte créé avec succès ! Veuillez vous connecter.')),
        );
        Navigator.pop(context); // Retour à l'écran de connexion
      } else {
        // Afficher une erreur
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur lors de la création du compte.')),
        );
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Créer un Compte'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text(
                'Inscrivez-vous pour pouvoir réserver votre table !',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 30),

              // Champ Email
              CustomTextField(
                controller: _emailController,
                labelText: 'Email',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains('@')) {
                    return 'Veuillez entrer un email valide.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Champ Mot de passe
              CustomTextField(
                controller: _passwordController,
                labelText: 'Mot de passe',
                prefixIcon: Icons.lock_outline,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return 'Le mot de passe doit contenir au moins 6 caractères.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Champ Confirmation Mot de passe
              CustomTextField(
                controller: _confirmPasswordController,
                labelText: 'Confirmer le Mot de passe',
                prefixIcon: Icons.lock_reset,
                obscureText: true,
                validator: (value) {
                  if (value != _passwordController.text) {
                    return 'Les mots de passe ne correspondent pas.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),

              // Bouton d'inscription
              ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                  'Créer mon compte',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 20),

              // Lien pour se connecter
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("J'ai déjà un compte ? Se connecter"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}