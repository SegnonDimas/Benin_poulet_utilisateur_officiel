import 'package:benin_poulet/constants/authProviders.dart';
import 'package:benin_poulet/constants/userRoles.dart';
import 'package:benin_poulet/utils/app_utils.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:path/path.dart';

import '../../../models/user.dart';
import '../firestore/user_repository.dart';

class AuthServices {
  static final auth = FirebaseAuth.instance;
  static final firestoreService = FirestoreService();
  static final userId = auth.currentUser?.uid;
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
        lastLogin: DateTime.now(),
      );

      firestoreService.createOrUpdateUser(user);
    }
  }

  //========================================
  // créer une inscription/connexion email
  //========================================
  static Future<void> createEmailAuth(
    String _email,
    String _password, {
    String role = UserRoles.BUYER,
    String authProvider = AuthProviders.EMAIL,
  }) async {
    try {
      await auth.createUserWithEmailAndPassword(
        email: _email,
        password: _password,
      );

      // creation de l'utilisateur anonyme dans la collection 'user' sur Firebase
      AppUser user = AppUser(userId: userId!);
      user = user.copyWith(
        authProvider: authProvider,
        authIdentifier: _email,
        createdAt: DateTime.now(),
        lastLogin: DateTime.now(),
      );

      firestoreService.createOrUpdateUser(user);
    } catch (e) {
      if (kDebugMode) {
        print('::::::::::::::Erreur lors de la connexion : $e ::::::::::::::');
      }
    }
  }

  //========================================
  // créer une inscription/connexion phone
  //========================================
  static Future<void> createPhoneAuth(
    PhoneNumber _phoneNumber,
    String _password, {
    String role = UserRoles.BUYER,
    String authProvider = AuthProviders.PHONE,
    String? fullName,
  }) async {
    try {
      await auth.createUserWithEmailAndPassword(
        email: _formatEmailFromPhone(_phoneNumber),
        password: _password,
      );

      // creation de l'utilisateur dans la collection 'users' sur Firebase
      AppUser user = AppUser(userId: userId!);
      user = user.copyWith(
        authProvider: authProvider,
        authIdentifier: _phoneNumber.phoneNumber!,
        fullName: fullName,
        createdAt: DateTime.now(),
        lastLogin: DateTime.now(),
        isAnonymous: false,
        role: role,
      );

      firestoreService.createOrUpdateUser(user);
    } catch (e) {
      if (e.toString().contains('already')) {
        AppUtils.showSnackBar(
          context as BuildContext,
          "Cette adresse est deja associee a un compte",
        );
      }
      if (kDebugMode) {
        print('::::::::::::::Erreur lors de la connexion : $e ::::::::::::::');
      }
    }
  }

  //============================================
  // créer une inscription/connexion avec Google
  //============================================
  //static Future<void> createGoogleAuth() async {}

  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  //final GoogleSignIn googleSignIn = GoogleSignIn.instance;

  static Future<User?> signInWithGoogle() async {
    try {
      // Déclenche le flux de connexion
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Si l'utilisateur annule, googleUser est null
      if (googleUser == null) {
        return null;
      }

      // Obtient les détails d'authentification à partir de la requête
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Crée un credential pour Firebase
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Se connecte à Firebase avec le credential
      final UserCredential userCredential =
          await auth.signInWithCredential(credential);

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print('Erreur FirebaseAuth: ${e.code} - ${e.message}');
      return null;
    } catch (e) {
      print('Erreur générale de connexion Google: $e');
      return null;
    }
  }

  static Future<void> signOutOfGoogle() async {
    try {
      await GoogleSignIn().signOut();
      await auth.signOut();
    } catch (e) {
      print('Erreur lors de la déconnexion: $e');
    }
  }

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

String _formatEmailFromPhone(PhoneNumber phone) {
  var dialCode = phone.dialCode?.replaceAll('+', '00') ?? '';
  var isoCode = phone.isoCode?.toLowerCase() ?? '';
  var prefix = dialCode + isoCode;
  var number = phone.phoneNumber
          ?.replaceAll(phone.dialCode ?? '', '')
          .replaceAll(' ', '') ??
      '';
  return '$prefix$number@gmail.com';
}
