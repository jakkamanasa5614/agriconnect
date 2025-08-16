import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'services/auth_service.dart';
import 'screens/admin_dashboard.dart';
import 'screens/farmer_dashboard.dart';
import 'screens/buyer_dashboard.dart';
import 'auth/login_screen.dart';

class RoleRouter extends StatelessWidget {
  const RoleRouter({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const LoginScreen();

    final authService = AuthService();

    return FutureBuilder<String?>(
      future: authService.getUserRole(user.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasError) {
          return const Scaffold(body: Center(child: Text('Error loading user role')));
        }
        final role = snapshot.data?.toLowerCase();
        switch (role) {
          case 'admin':
            return const AdminDashboard();
          case 'farmer':
            return const FarmerDashboard();
          case 'buyer':
            return const BuyerDashboard();
          default:
            return const Scaffold(body: Center(child: Text('Unknown role')));
        }
      },
    );
  }
}
