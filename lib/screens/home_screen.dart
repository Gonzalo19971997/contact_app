import 'dart:io';
import 'package:flutter/material.dart';
import '../models/contact.dart';
import '../services/api_service.dart';
import 'detail_screen.dart';
import 'add_contact_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService apiService = ApiService();

  List<Contact> contacts = [];
  String search = "";
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    loadContacts();
  }

  // 🔄 Charger API
  void loadContacts() async {
    try {
      final data = await apiService.fetchContacts();
      setState(() {
        contacts = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = "Erreur de chargement";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // 🔍 Filtrer contacts
    final filtered = contacts.where((c) {
      return c.nom.toLowerCase().contains(search);
    }).toList();

    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(title: const Text("Mes Contacts"), centerTitle: true),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Erreur de chargement"),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isLoading = true;
                        error = null;
                      });
                      loadContacts();
                    },
                    child: const Text("Réessayer"),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                // 🔍 RECHERCHE
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Rechercher...",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        search = value.toLowerCase();
                      });
                    },
                  ),
                ),

                // 📋 LISTE
                Expanded(
                  child: ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final contact = filtered[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 25,
                            backgroundImage: contact.photo.startsWith("http")
                                ? NetworkImage(contact.photo)
                                : FileImage(File(contact.photo))
                                      as ImageProvider,
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
                                builder: (_) => DetailScreen(contact: contact),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

      // ➕ AJOUT CONTACT
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final newContact = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddContactScreen()),
          );

          if (newContact != null) {
            setState(() {
              contacts.insert(0, newContact);
            });
          }
        },
      ),
    );
  }
}
