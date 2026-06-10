import 'package:flutter/material.dart';
import '../models/contact.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class AddContactScreen extends StatefulWidget {
  final Contact? contact;

  const AddContactScreen({super.key, this.contact});

  @override
  State<AddContactScreen> createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  // 🔥 VARIABLES
  String nom = "";
  String email = "";
  String telephone = "";
  File? image;

  // 🔥 INITIALISATION
  @override
  void initState() {
    super.initState();

    if (widget.contact != null) {
      nom = widget.contact!.nom;
      email = widget.contact!.email;
      telephone = widget.contact!.telephone;
    }

    if (widget.contact != null && widget.contact!.photo.isNotEmpty) {
      image = File(widget.contact!.photo);
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        image = File(picked.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.contact == null ? "Ajouter un contact" : "Modifier le contact",
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: image != null ? FileImage(image!) : null,
                child: image == null
                    ? const Icon(Icons.camera_alt, size: 30)
                    : null,
              ),
            ),
            const SizedBox(height: 20),

            // NOM
            TextFormField(
              initialValue: nom,
              decoration: const InputDecoration(labelText: "Nom"),
              onChanged: (value) => nom = value,
            ),

            const SizedBox(height: 10),

            // EMAIL
            TextFormField(
              initialValue: email,
              decoration: const InputDecoration(labelText: "Email"),
              onChanged: (value) => email = value,
            ),

            const SizedBox(height: 10),

            // TELEPHONE
            TextFormField(
              initialValue: telephone,
              decoration: const InputDecoration(labelText: "Téléphone"),
              onChanged: (value) => telephone = value,
            ),

            const SizedBox(height: 20),

            // BOUTON
            ElevatedButton(
              onPressed: () {
                final newContact = Contact(
                  nom,
                  email,
                  telephone,
                  image != null ? image!.path : "",
                );

                Navigator.pop(context, newContact);
              },
              child: const Text("Enregistrer"),
            ),
          ],
        ),
      ),
    );
  }
}
