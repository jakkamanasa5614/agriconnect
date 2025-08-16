import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../role_router.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _auth = AuthService();
  bool _loading = false;

  final List<String> _roles = const ['buyer', 'farmer', 'admin'];
  String _selectedRole = 'buyer';

  Future<void> _signup() async {
    setState(() => _loading = true);
    final user = await _auth.registerWithEmail(
      _email.text.trim(),
      _password.text.trim(),
      role: _selectedRole,
    );
    if (!mounted) return;
    setState(() => _loading = false);

    if (user != null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const RoleRouter()));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Sign-up failed')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(controller: _email, decoration: const InputDecoration(labelText: 'Email')),
              const SizedBox(height: 12),
              TextField(controller: _password, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedRole,
                items: _roles.map((r) => DropdownMenuItem(value: r, child: Text(r.toUpperCase()))).toList(),
                onChanged: (v) => setState(() => _selectedRole = v ?? 'buyer'),
                decoration: const InputDecoration(labelText: 'Select Role'),
              ),
              const SizedBox(height: 20),
              _loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(onPressed: _signup, child: const Text('Create Account')),
            ],
          ),
        ),
      ),
    );
  }
}
