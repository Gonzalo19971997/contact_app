import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mes Contacts')),
      body: Center(child: Text('Bienvenue dans Contact App')),
    );
  }
}
