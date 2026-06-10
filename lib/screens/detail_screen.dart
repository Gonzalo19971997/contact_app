import 'package:flutter/material.dart';
import '../models/contact.dart';
import 'dart:io';

class DetailScreen extends StatelessWidget {
  final Contact contact;

  // Constructeur pour recevoir le contact
  const DetailScreen({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Détail du contact"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 📸 Photo
            CircleAvatar(
              radius: 60,
              backgroundImage: contact.photo.isNotEmpty
                  ? (contact.photo.startsWith("http")
                        ? NetworkImage(contact.photo)
                        : FileImage(File(contact.photo)) as ImageProvider)
                  : null,
            ),

            const SizedBox(height: 20),
            // 🧑 Nom
            Text(
              contact.nom,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 30),

            // 📞 Téléphone
            Card(
              child: ListTile(
                leading: const Icon(Icons.phone, color: Colors.blue),
                title: Text(contact.telephone),
              ),
            ),

            const SizedBox(height: 10),

            // 📧 Email
            Card(
              child: ListTile(
                leading: const Icon(Icons.email, color: Colors.red),
                title: Text(contact.email),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
