import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Send OTP
  Future<void> sendOtp({
    required String phoneNumber,
    required void Function(String verificationId) onCodeSent,
    required void Function(FirebaseAuthException e) onFailed,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Optional: auto-sign in
        final cred = await _auth.signInWithCredential(credential);
        await _ensureProfile(cred.user!);
      },
      verificationFailed: onFailed,
      codeSent: (String verificationId, int? resendToken) {
        onCodeSent(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  // Verify OTP and sign in
  Future<User?> verifyOtp({
    required String verificationId,
    required String smsCode,
    String? name,
    String? role,
  }) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    final userCredential = await _auth.signInWithCredential(credential);
    final user = userCredential.user;

    if (user != null) {
      await _ensureProfile(user, name: name, role: role);
    }

    return user;
  }

  // Ensure user profile exists in Firestore
  Future<void> _ensureProfile(User user, {String? name, String? role}) async {
    final doc = await _db.collection('users').doc(user.uid).get();
    if (!doc.exists) {
      await _db.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'name': name ?? user.displayName ?? 'Unknown',
        'phone': user.phoneNumber,
        'role': role ?? 'customer',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  // Auth state stream
  Stream<User?> authState() => _auth.authStateChanges();

  // Get user role
  Future<String?> getRole(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    return doc.data()?['role'] as String?;
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
