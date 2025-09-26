import 'package:flutter/material.dart';
import 'package:stride/features/auth/auth_service.dart';

class TaughtPage extends StatelessWidget {
  AuthService authService = AuthService();
  TaughtPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Taught So Far"),
        actions: [
          IconButton(onPressed: authService.signOut, icon: Icon(Icons.logout)),
        ],
      ),
      body: const Center(
        child: Text(
          "This is the Taught Page placeholder 👩‍🏫",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
