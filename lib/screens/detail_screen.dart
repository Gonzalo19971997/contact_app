import 'package:flutter/material.dart';
import '../models/contact.dart';

class DetailScreen extends StatelessWidget {
  final Contact contact;

  // Constructeur pour recevoir le contact
  const DetailScreen({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Détail du contact")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Photo
            CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(contact.photo),
            ),

            const SizedBox(height: 20),

            // Nom
            Text(
              contact.nom,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            // Email
            Text(contact.email),

            const SizedBox(height: 10),

            // Téléphone
            Text(contact.telephone),
          ],
        ),
      ),
    );
  }
}
