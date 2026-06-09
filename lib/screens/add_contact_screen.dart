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

  // 📸 Choisir image
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

      Contact newContact = Contact(
        nom,
        email,
        telephone,
        image != null ? image!.path : "",
      );

      Navigator.pop(context, newContact);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ajouter un contact"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // NOM
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Nom",
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onSaved: (value) => nom = value!,
                validator: (value) => value!.isEmpty ? "Entrer un nom" : null,
              ),

              const SizedBox(height: 15),

              // EMAIL
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Email",
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onSaved: (value) => email = value!,
                validator: (value) =>
                    !value!.contains("@") ? "Email invalide" : null,
              ),

              const SizedBox(height: 15),

              // TELEPHONE
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Téléphone",
                  prefixIcon: const Icon(Icons.phone),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onSaved: (value) => telephone = value!,
                validator: (value) =>
                    value!.length < 8 ? "Numéro invalide" : null,
              ),

              const SizedBox(height: 20),

              // BOUTON IMAGE
              ElevatedButton.icon(
                onPressed: pickImage,
                icon: const Icon(Icons.image),
                label: const Text("Choisir une image"),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // APERCU IMAGE
              if (image != null) Image.file(image!, height: 100),

              const SizedBox(height: 20),

              // BOUTON ENREGISTRER
              ElevatedButton(
                onPressed: saveContact,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text("Enregistrer"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
