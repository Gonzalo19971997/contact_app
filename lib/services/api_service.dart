import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/contact.dart';

class ApiService {
  // URL de l'API
  final String url = "https://randomuser.me/api/?results=10";

  // Méthode pour récupérer les contacts
  Future<List<Contact>> fetchContacts() async {
    try {
      // Requête GET vers l'API
      final response = await http.get(Uri.parse(url));

      // Vérifier si la requête a réussi
      if (response.statusCode == 200) {
        // Convertir la réponse JSON
        final data = json.decode(response.body);

        // Récupérer la liste des utilisateurs
        List results = data['results'];

        // Convertir en liste d'objets Contact
        return results.map((json) => Contact.fromJson(json)).toList();
      } else {
        throw Exception("Erreur lors du chargement des contacts");
      }
    } catch (e) {
      // Gestion des erreurs
      throw Exception("Erreur réseau : $e");
    }
  }
}
