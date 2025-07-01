import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../models/user.dart';
import '../firestore/user_repository.dart';

class AuthServices {
  static final auth = FirebaseAuth.instance;
  static final firestoreService = FirestoreService();
  //static final GoogleSignInAccount? googleUser = GoogleSignIn().signIn();;

  //========================================
  // créer une inscription/connexion anonyme
  //========================================
  static Future<void> createAnonymousAuth() async {
    // definition de l'utilisateur anonyme
    final anonymousUser = await auth.signInAnonymously();

    // creation de l'utilisateur anonyme si aucune session trouvée sur l'appareil
    if (auth.currentUser == null) {
      // creation de l'utilisateur anonyme
      anonymousUser;

      // creation de l'utilisateur anonyme dans la collection 'user' sur Firebase
      final user = AppUser(
          userId: anonymousUser.user!.uid,
          createdAt: DateTime.now(),
          lastLogin: DateTime.now());

      firestoreService.createOrUpdateUser(user);
    }
  }

  //========================================
  // créer une inscription/connexion email
  //========================================
  static Future<void> createEmailAuth(String _email, String _password) async {
    try {
      await auth.createUserWithEmailAndPassword(
        email: _email,
        password: _password,
      );
    } catch (e) {
      if (kDebugMode) {
        print('::::::::::::::Erreur lors de la connexion : $e ::::::::::::::');
      }
    }
  }

  //========================================
  // créer une inscription/connexion phone
  //========================================

//============================================
// créer une inscription/connexion avec Google
//============================================
  //static Future<void> createGoogleAuth() async {}

  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn.instance;

  /*Future<firebase_auth.User?> signInWithGoogle() async {
    try {
      // 1. Initialiser GoogleSignIn
      await googleSignIn.initialize(
          scopes: ['email', 'profile'],
          );

      // 2. Démarrer le processus de connexion
      final account = await googleSignIn.signIn();
      if (account == null) return null; // l’utilisateur a annulé

      // 3. Récupérer les tokens
      final auth = await account.authentication;
      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: auth.accessToken,
        idToken: auth.idToken,
      );

      // 4. Se connecter à Firebase avec ces credentials
      final userCredential = await _auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      print('Erreur Google Sign-In : $e');
      return null;
    }
  }*/
}
