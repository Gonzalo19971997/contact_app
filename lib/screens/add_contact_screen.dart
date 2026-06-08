import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/contact.dart';

class AddContactScreen extends StatefulWidget {
  const AddContactScreen({super.key});

  @override
  State<AddContactScreen> createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  final _formKey = GlobalKey<FormState>();

  String nom = "";
  String email = "";
  String telephone = "";
  File? image;

  final ImagePicker picker = ImagePicker();

  // 📸 Choisir image depuis galerie
  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
    }
  }

  // 💾 Enregistrer contact
  void saveContact() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Créer contact (image locale ou image vide)
      Contact newContact = Contact(
        nom,
        email,
        telephone,
        image != null ? image!.path : "",
      );

      // Retourner le contact à l'écran précédent
      Navigator.pop(context, newContact);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ajouter un contact")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Champ Nom
              TextFormField(
                decoration: const InputDecoration(labelText: "Nom"),
                onSaved: (value) => nom = value!,
                validator: (value) => value!.isEmpty ? "Entrer un nom" : null,
              ),

              // Champ Email
              TextFormField(
                decoration: const InputDecoration(labelText: "Email"),
                onSaved: (value) => email = value!,
                validator: (value) =>
                    !value!.contains("@") ? "Email invalide" : null,
              ),

              // Champ Téléphone
              TextFormField(
                decoration: const InputDecoration(labelText: "Téléphone"),
                onSaved: (value) => telephone = value!,
                validator: (value) =>
                    value!.length < 8 ? "Numéro invalide" : null,
              ),

              const SizedBox(height: 20),

              // Bouton image
              ElevatedButton(
                onPressed: pickImage,
                child: const Text("Choisir une image"),
              ),

              const SizedBox(height: 10),

              // Aperçu image
              if (image != null) Image.file(image!, height: 100),

              const SizedBox(height: 20),

              // Bouton enregistrer
              ElevatedButton(
                onPressed: saveContact,
                child: const Text("Enregistrer"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
