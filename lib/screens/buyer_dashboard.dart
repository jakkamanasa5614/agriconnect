import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../auth/login_screen.dart';

class BuyerDashboard extends StatelessWidget {
  const BuyerDashboard({super.key});
  @override
  Widget build(BuildContext context) {
    final auth = AuthService();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buyer Dashboard'),
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
      body: const Center(child: Text('Welcome Buyer!')),
    );
  }
}
