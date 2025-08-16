import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String uid;
  final String email;
  final String role;

  AppUser({
    required this.uid,
    required this.email,
    required this.role,
  });

  /// Save user data to Firestore
  Future<void> saveToFirestore() async {
    final doc = FirebaseFirestore.instance.collection('users').doc(uid);
    await doc.set({
      'uid': uid,
      'email': email,
      'role': role,
    });
  }

  /// Convert Firestore document → AppUser
  factory AppUser.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AppUser(
      uid: data['uid'] ?? '',
      email: data['email'] ?? '',
      role: data['role'] ?? 'customer', // default role
    );
  }
}
