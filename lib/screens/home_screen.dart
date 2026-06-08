import 'package:flutter/material.dart';
import '../models/contact.dart';
import '../services/api_service.dart';

class HomeScreen extends StatelessWidget {
  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mes Contacts")),
      body: FutureBuilder<List<Contact>>(
        future: apiService.fetchContacts(),
        builder: (context, snapshot) {
          // 🔄 Chargement
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // ❌ Erreur
          else if (snapshot.hasError) {
            return Center(child: Text("Erreur : ${snapshot.error}"));
          }
          // ✅ Succès
          else if (snapshot.hasData) {
            final contacts = snapshot.data!;

            return ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                final contact = contacts[index];

                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(contact.photo),
                  ),
                  title: Text(contact.nom),
                  subtitle: Text(contact.telephone),
                );
              },
            );
          }

          return const Center(child: Text("Aucun contact"));
        },
      ),
    );
  }
}
