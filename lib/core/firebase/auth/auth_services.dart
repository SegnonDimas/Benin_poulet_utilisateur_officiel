import 'package:benin_poulet/constants/authProviders.dart';
import 'package:benin_poulet/constants/userRoles.dart';
import 'package:benin_poulet/utils/app_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:path/path.dart';

import '../../../models/user.dart';
import '../firestore/user_repository.dart';

class AuthServices {
  static final auth = FirebaseAuth.instance; //actuelle instance
  static final firestoreService = FirestoreService();
  static final userId = auth.currentUser?.uid;
  //static final GoogleSignInAccount? googleUser = GoogleSignIn().signIn();;

  //========================================
  // créer une inscription/connexion anonyme
  //========================================
  static Future<void> createAnonymousAuth() async {
    try {
      // creation de l'utilisateur anonyme si aucune session trouvée sur l'appareil
      if (auth.currentUser == null) {
        // definition de l'utilisateur anonyme
        final anonymousUser = await auth.signInAnonymously();

        // creation de l'utilisateur anonyme
        anonymousUser;

        // creation de l'utilisateur anonyme dans la collection 'users' sur Firebase
        AppUser user = AppUser(
          userId: anonymousUser.user!.uid,
        );

        user = user.copyWith(
          createdAt: DateTime.now(),
          lastLogin: DateTime.now(),
        );

        await firestoreService.createOrUpdateUser(user);
      }
    } catch (e) {
      if (kDebugMode) {
        print(
            '::::::Erreur lors de la creation de l\'utilisateur anonyme : $e :::::::');
      }
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
      final emailUser = await auth.createUserWithEmailAndPassword(
        email: _email,
        password: _password,
      );

      emailUser;

      // creation de l'utilisateur avec email dans la collection 'users' sur Firebase
      AppUser user = AppUser(
        userId: emailUser.user!.uid,
        isAnonymous: false,
      );
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
      PhoneNumber _phoneNumber, String _password,
      {String role = UserRoles.BUYER,
      String authProvider = AuthProviders.PHONE,
      String? fullName,
      String? password}) async {
    try {
      final phoneUser = await auth.createUserWithEmailAndPassword(
        email: _formatEmailFromPhone(_phoneNumber),
        password: _password,
      );

      phoneUser;

      // creation de l'utilisateur dans la collection 'users' sur Firebase
      AppUser user = AppUser(userId: phoneUser.user!.uid);
      user = user.copyWith(
          authProvider: authProvider,
          authIdentifier: _phoneNumber.phoneNumber!,
          fullName: fullName,
          createdAt: DateTime.now(),
          lastLogin: DateTime.now(),
          isAnonymous: false,
          role: role,
          password: password);

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
  static Future<User?> signInWithGoogle({
    String authProvider = AuthProviders.GOOGLE,
    String role = UserRoles.BUYER,
  }) async {
    try {
      // Déconnecte le compte mis en cache pour forcer la sélection à la prochaine connexion
      await GoogleSignIn().signOut();
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

      // creation de l'utilisateur avec google dans la collection 'user' sur Firebase
      AppUser user = AppUser(
        userId: googleUser.id,
        isAnonymous: false,
      );
      user = user.copyWith(
        authProvider: authProvider,
        authIdentifier: googleUser.email,
        photoUrl: googleUser.photoUrl,
        fullName: googleUser.displayName,
        role: role,
        createdAt: DateTime.now(),
        lastLogin: DateTime.now(),
      );

      firestoreService.createOrUpdateUser(user);

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
