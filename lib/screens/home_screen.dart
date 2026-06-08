import 'package:flutter/material.dart';
import '../models/contact.dart';
import '../services/api_service.dart';
import 'detail_screen.dart';
import 'add_contact_screen.dart';

class HomeScreen extends StatelessWidget {
  final ApiService apiService = ApiService();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mes Contacts"), centerTitle: true),
      // 👇 LISTE DES CONTACTS
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

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(contact.photo),
                    ),

                    title: Text(
                      contact.nom,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),

                    subtitle: Text(contact.telephone),

                    trailing: const Icon(Icons.arrow_forward_ios),

                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(contact: contact),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }

          return const Center(child: Text("Aucun contact"));
        },
      ),

      // 👇 BOUTON AJOUT (BIEN PLACÉ)
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddContactScreen()),
          );
        },
      ),
      backgroundColor: Colors.grey[100],
    );
  }
}
