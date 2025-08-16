import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../auth/login_screen.dart';

class FarmerDashboard extends StatelessWidget {
  const FarmerDashboard({super.key});
  @override
  Widget build(BuildContext context) {
    final auth = AuthService();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Farmer Dashboard'),
        actions: [
          IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await auth.signOut();
                if (!context.mounted) return;
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => const LoginScreen()));
              }),
        ],
      ),
      body: const Center(child: Text('Welcome Farmer!')),
    );
  }
}
