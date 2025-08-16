import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../role_router.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _auth = AuthService();
  bool _loading = false;

  Future<void> _loginEmail() async {
    setState(() => _loading = true);
    final user = await _auth.signInWithEmailAndPassword(
      _email.text.trim(),
      _password.text.trim(),
    );
    if (!mounted) return;
    setState(() => _loading = false);
    if (user != null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const RoleRouter()));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Login failed')));
    }
  }

  Future<void> _loginGoogle() async {
    setState(() => _loading = true);
    final user = await _auth.signInWithGoogle();
    if (!mounted) return;
    setState(() => _loading = false);
    if (user != null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const RoleRouter()));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Google login failed')));
    }
  }

  Future<void> _loginFacebook() async {
    setState(() => _loading = true);
    final user = await _auth.signInWithFacebook();
    if (!mounted) return;
    setState(() => _loading = false);
    if (user != null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const RoleRouter()));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Facebook login failed')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(controller: _email, decoration: const InputDecoration(labelText: 'Email')),
              const SizedBox(height: 12),
              TextField(controller: _password, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
              const SizedBox(height: 20),
              _loading ? const CircularProgressIndicator() : ElevatedButton(onPressed: _loginEmail, child: const Text('Login')),
              const SizedBox(height: 12),
              OutlinedButton.icon(icon: Image.asset('assets/images/google_logo.png', height: 20), label: const Text('Login with Google'), onPressed: _loginGoogle),
              const SizedBox(height: 12),
              OutlinedButton.icon(icon: Image.asset('assets/images/facebook_logo.png', height: 20), label: const Text('Login with Facebook'), onPressed: _loginFacebook),
              const SizedBox(height: 20),
              TextButton(onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const SignupScreen()));
              }, child: const Text("Don't have an account? Sign up")),
            ],
          ),
        ),
      ),
    );
  }
}
