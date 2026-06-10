import 'package:flutter/material.dart';
import '../models/contact.dart';
import '../services/api_service.dart';
import 'detail_screen.dart';
import 'add_contact_screen.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

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

  //Sauvegarde de contact

  Future<void> saveContacts() async {
    final prefs = await SharedPreferences.getInstance();

    List<String> data = contacts.map((c) => jsonEncode(c.toJson())).toList();

    await prefs.setStringList("contacts", data);
  }

  //Chargement de contact
  void loadContacts() async {
    final prefs = await SharedPreferences.getInstance();
    final localData = prefs.getStringList("contacts");

    if (localData != null && localData.isNotEmpty) {
      setState(() {
        contacts = localData
            .map((e) => Contact.fromJson(jsonDecode(e)))
            .toList();
        isLoading = false;
      });
    } else {
      final data = await apiService.fetchContacts();
      setState(() {
        contacts = data;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = contacts.where((c) {
      return c.nom.toLowerCase().contains(search);
    }).toList();

    return Scaffold(
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
                            backgroundImage: contact.photo.isNotEmpty
                                ? (contact.photo.startsWith("http")
                                      ? NetworkImage(contact.photo)
                                      : FileImage(File(contact.photo))
                                            as ImageProvider)
                                : null,
                          ),

                          title: Text(contact.nom),
                          subtitle: Text(contact.telephone),

                          // 👁 DETAIL
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DetailScreen(contact: contact),
                              ),
                            );
                          },

                          // 🔥 BOUTONS ACTIONS
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // ✏️ MODIFIER
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                                onPressed: () async {
                                  final updated = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          AddContactScreen(contact: contact),
                                    ),
                                  );

                                  if (updated != null) {
                                    setState(() {
                                      contacts[index] = updated;
                                      saveContacts();
                                    });
                                  }
                                },
                              ),

                              // 🗑 SUPPRIMER
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text("Supprimer"),
                                      content: const Text(
                                        "Voulez-vous supprimer ce contact ?",
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text("Annuler"),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            setState(() {
                                              contacts.removeAt(index);
                                              saveContacts();
                                            });
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Supprimer"),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

      // ➕ AJOUT
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
              saveContacts();
            });
          }
        },
      ),
    );
  }
}
