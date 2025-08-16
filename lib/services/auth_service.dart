// File: lib/services/auth_service.dart
import 'package:flutter/foundation.dart'; // for kIsWeb and debugPrint
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ================= Email Signup =================
  Future<User?> registerWithEmail(String email, String password,
      {required String role}) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = cred.user;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'email': user.email,
          'role': role,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
      return user;
    } catch (e) {
      debugPrint('Email signup error: $e');
      return null;
    }
  }

  // ================= Email Login =================
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return cred.user;
    } catch (e) {
      debugPrint('Email login error: $e');
      return null;
    }
  }

  // ================= Google Login =================
  Future<User?> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        final userCredential = await _auth.signInWithPopup(googleProvider);
        final user = userCredential.user;
        if (user != null) {
          final doc = await _firestore.collection('users').doc(user.uid).get();
          if (!doc.exists) {
            await _firestore.collection('users').doc(user.uid).set({
              'uid': user.uid,
              'email': user.email,
              'role': 'buyer',
              'createdAt': FieldValue.serverTimestamp(),
            });
          }
        }
        return user;
      } else {
        final gUser = await GoogleSignIn().signIn();
        if (gUser == null) return null;
        final gAuth = await gUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: gAuth.accessToken,
          idToken: gAuth.idToken,
        );
        final cred = await _auth.signInWithCredential(credential);
        final user = cred.user;
        if (user != null) {
          final doc = await _firestore.collection('users').doc(user.uid).get();
          if (!doc.exists) {
            await _firestore.collection('users').doc(user.uid).set({
              'uid': user.uid,
              'email': user.email,
              'role': 'buyer',
              'createdAt': FieldValue.serverTimestamp(),
            });
          }
        }
        return user;
      }
    } catch (e) {
      debugPrint('Google sign-in error: $e');
      return null;
    }
  }

  // ================= Facebook Login =================
  Future<User?> signInWithFacebook() async {
    try {
      final result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        final credential =
            FacebookAuthProvider.credential(result.accessToken!.tokenString);
        final cred = await _auth.signInWithCredential(credential);
        final user = cred.user;
        if (user != null) {
          final doc = await _firestore.collection('users').doc(user.uid).get();
          if (!doc.exists) {
            await _firestore.collection('users').doc(user.uid).set({
              'uid': user.uid,
              'email': user.email,
              'role': 'buyer',
              'createdAt': FieldValue.serverTimestamp(),
            });
          }
        }
        return user;
      }
      return null;
    } catch (e) {
      debugPrint('Facebook login error: $e');
      return null;
    }
  }

  // ================= Sign Out =================
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      try {
        await GoogleSignIn().signOut();
      } catch (_) {}
      try {
        await FacebookAuth.instance.logOut();
      } catch (_) {}
    } catch (e) {
      debugPrint('Sign out error: $e');
    }
  }

  // ================= Get User Role =================
  Future<String?> getUserRole(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      return doc.data()?['role'] as String?;
    } catch (e) {
      debugPrint('Get role error: $e');
      return null;
    }
  }
}
