import 'package:benin_poulet/constants/authProviders.dart';
import 'package:benin_poulet/constants/userRoles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../../models/user.dart';
import '../firestore/firestore_service.dart';
import '../firestore/user_repository.dart';

class AuthServices {
  static final auth = FirebaseAuth.instance; //actuelle instance
  static final firestoreService = FirestoreUserServices();
  static var userId = auth.currentUser?.uid;
  //static final GoogleSignInAccount? googleUser = GoogleSignIn().signIn();;

  // Variable pour éviter les appels multiples simultanés
  static bool _isGoogleSignInInProgress = false;

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

        userId = anonymousUser.user?.uid;

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
  // VÉRIFICATION DE L'EXISTENCE DE L'UTILISATEUR
  //========================================

  /// Vérifie si un utilisateur existe avec l'email donné
  static Future<bool> userExistsWithEmail(String email) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .where('authIdentifier', isEqualTo: email)
          .get();

      return userDoc.docs.isNotEmpty;
    } catch (e) {
      if (kDebugMode) {
        print(
            'Erreur lors de la vérification de l\'existence de l\'utilisateur: $e');
      }
      return false;
    }
  }

  /// Vérifie si un utilisateur existe avec le numéro de téléphone donné
  static Future<bool> userExistsWithPhone(String phoneNumber) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .where('authIdentifier', isEqualTo: phoneNumber)
          .get();

      return userDoc.docs.isNotEmpty;
    } catch (e) {
      if (kDebugMode) {
        print(
            'Erreur lors de la vérification de l\'existence de l\'utilisateur: $e');
      }
      return false;
    }
  }

  /// Récupère le rôle de l'utilisateur connecté
  static Future<String?> getUserRole() async {
    try {
      final currentUser = auth.currentUser;
      if (currentUser == null) return null;

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      if (userDoc.exists) {
        return userDoc.data()?['role'] as String?;
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la récupération du rôle: $e');
      }
      return null;
    }
  }

  /// Met à jour la dernière connexion de l'utilisateur
  static Future<void> updateLastLogin() async {
    try {
      final currentUser = auth.currentUser;
      if (currentUser == null) return;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .update({
        'lastLogin': DateTime.now(),
      });
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la mise à jour de la dernière connexion: $e');
      }
    }
  }

  //========================================
  // créer une inscription/connexion email
  //========================================

  //Inscription avec email
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

      userId = emailUser.user?.uid;

      // creation de l'utilisateur avec email dans la collection 'users' sur Firebase
      AppUser user = AppUser(
        userId: emailUser.user!.uid,
        isAnonymous: false,
      );
      user = user.copyWith(
          authProvider: authProvider,
          authIdentifier: _email,
          fullName: emailUser.user!.displayName,
          photoUrl: emailUser.user!.photoURL,
          role: role,
          createdAt: DateTime.now(),
          lastLogin: DateTime.now(),
          password: _password);

      await firestoreService.createOrUpdateUser(user);

      // Si c'est un vendeur, créer le profil vendeur avec les informations de base
      if (role == UserRoles.SELLER) {
        final firestoreServiceInstance = FirestoreService();
        await firestoreServiceInstance.createCompleteSeller(
          sellerId: emailUser.user!.uid,
          userId: emailUser.user!.uid,
          createdAt: DateTime.now(),
          documentsVerified: false, // À vérifier par l'admin
          sectors: [], // Sera mis à jour lors de la création de la boutique
          subSectors: [], // Sera mis à jour lors de la création de la boutique
          storeIds: [], // Liste vide au début
          mobileMoney: [], // Sera mis à jour lors de la création de la boutique
          deliveryInfos: {}, // Sera mis à jour lors de la création de la boutique
          fiscality: {}, // Sera mis à jour lors de la création de la boutique
          storeInfos: {
            'name': '',
            'phone': '',
            'email': _email,
          },
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('::::::::::::::Erreur lors de la connexion : $e ::::::::::::::');
      }
      rethrow;
    }
  }

  // Connexion avec email
  static Future<void> signInWithEmailAndPassword(
    String _email,
    String _password,
  ) async {
    try {
      var email = _email.trim();
      var password = _password.trim();

      // Vérifier d'abord si l'utilisateur existe
      final userExists = await userExistsWithEmail(email);
      if (!userExists) {
        throw FirebaseAuthException(
          code: 'user-not-found',
          message:
              'Aucun compte trouvé avec cette adresse email. Veuillez vous inscrire.',
        );
      }

      final emailUser = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      // Mettre à jour la dernière connexion
      await updateLastLogin();

      emailUser;
    } catch (e) {
      if (kDebugMode) {
        print('::::::::::::::Erreur lors de la connexion : $e ::::::::::::::');
      }
      rethrow;
    }
  }

  //========================================
  // créer une inscription/connexion phone
  //========================================

  //Inscription avec phoneNumber
  static Future<void> createPhoneAuth(
      PhoneNumber _phoneNumber, String _password,
      {String role = UserRoles.BUYER,
      String authProvider = AuthProviders.PHONE,
      String? fullName,
      String? password}) async {
    final phoneUser = await auth.createUserWithEmailAndPassword(
      email: _formatEmailFromPhone(_phoneNumber),
      password: _password,
    );

    phoneUser;

    userId = phoneUser.user?.uid;

    // creation de l'utilisateur dans la collection 'users' sur Firebase
    AppUser user = AppUser(userId: phoneUser.user!.uid);
    user = user.copyWith(
      authProvider: authProvider,
      authIdentifier: _phoneNumber.phoneNumber!,
      fullName: fullName,
      createdAt: DateTime.now(),
      lastLogin: DateTime.now(),
      password: _password,
      isAnonymous: false,
      role: role,
    );

    await firestoreService.createOrUpdateUser(user);

    // Si c'est un vendeur, créer le profil vendeur avec les informations de base
    if (role == UserRoles.SELLER) {
      final firestoreServiceInstance = FirestoreService();
      await firestoreServiceInstance.createCompleteSeller(
        sellerId: phoneUser.user!.uid,
        userId: phoneUser.user!.uid,
        createdAt: DateTime.now(),
        documentsVerified: false, // À vérifier par l'admin
        sectors: [], // Sera mis à jour lors de la création de la boutique
        subSectors: [], // Sera mis à jour lors de la création de la boutique
        storeIds: [], // Liste vide au début
        mobileMoney: [], // Sera mis à jour lors de la création de la boutique
        deliveryInfos: {}, // Sera mis à jour lors de la création de la boutique
        fiscality: {}, // Sera mis à jour lors de la création de la boutique
        storeInfos: {
          'name': fullName ?? '',
          'phone': _phoneNumber.phoneNumber!,
          'email': _formatEmailFromPhone(_phoneNumber),
        },
      );
    }
  }

  //Connexion avec phoneNumber
  static Future<void> signInWithPhone(
    PhoneNumber _phoneNumber,
    String _password,
  ) async {
    try {
      var email = _formatEmailFromPhone(_phoneNumber).trim();
      var password = _password.trim();

      // Vérifier d'abord si l'utilisateur existe
      final userExists = await userExistsWithPhone(_phoneNumber.phoneNumber!);
      if (!userExists) {
        throw FirebaseAuthException(
          code: 'user-not-found',
          message:
              'Aucun compte trouvé avec ce numéro de téléphone. Veuillez vous inscrire.',
        );
      }

      final phoneUser = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      // Mettre à jour la dernière connexion
      await updateLastLogin();

      phoneUser;
    } catch (e) {
      if (kDebugMode) {
        print('::::::::::::::Erreur lors de la connexion : $e ::::::::::::::');
      }
      rethrow;
    }
  }

  //============================================
  // CONNEXION avec Google (pas d'inscription automatique)
  //============================================
  static Future<User?> signInWithGoogle() async {
    // Vérifier si une opération de connexion Google est déjà en cours
    if (_isGoogleSignInInProgress) {
      if (kDebugMode) {
        print('Connexion Google déjà en cours, ignoré.');
      }
      return null;
    }

    // Marquer le début de l'opération
    _isGoogleSignInInProgress = true;

    try {
      // Créer une nouvelle instance de GoogleSignIn avec des paramètres personnalisés
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
      );

      // Vérifier si un utilisateur est déjà connecté et le déconnecter silencieusement
      if (await googleSignIn.isSignedIn()) {
        try {
          await googleSignIn.signOut();
        } catch (e) {
          // Ignorer les erreurs de déconnexion
          if (kDebugMode) {
            print('Déconnexion silencieuse: $e');
          }
        }
      }

      // Déclenche le flux de connexion avec force de sélection
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      // Si l'utilisateur annule, googleUser est null
      if (googleUser == null) {
        return null;
      }

      // Vérifier si l'utilisateur existe déjà dans notre base
      final userExists = await userExistsWithEmail(googleUser.email);
      if (!userExists) {
        // L'utilisateur n'existe pas, déconnecter et lever une exception
        await googleSignIn.signOut();
        throw FirebaseAuthException(
          code: 'user-not-found',
          message:
              'Aucun compte n\'est associé à cette adresse Google. Veuillez vous inscrire.',
        );
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

      // Mettre à jour la dernière connexion
      await updateLastLogin();

      return userCredential.user;
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la connexion Google: $e');
      }
      rethrow;
    } finally {
      // Marquer la fin de l'opération
      _isGoogleSignInInProgress = false;
    }
  }

  //============================================
  // INSCRIPTION avec Google
  //============================================
  static Future<User?> signUpWithGoogle({
    String authProvider = AuthProviders.GOOGLE,
    String role = UserRoles.BUYER,
  }) async {
    // Vérifier si une opération de connexion Google est déjà en cours
    if (_isGoogleSignInInProgress) {
      if (kDebugMode) {
        print('Inscription Google déjà en cours, ignoré.');
      }
      return null;
    }

    // Marquer le début de l'opération
    _isGoogleSignInInProgress = true;

    try {
      // Créer une nouvelle instance de GoogleSignIn avec des paramètres personnalisés
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
      );

      // Vérifier si un utilisateur est déjà connecté et le déconnecter silencieusement
      if (await googleSignIn.isSignedIn()) {
        try {
          await googleSignIn.signOut();
        } catch (e) {
          // Ignorer les erreurs de déconnexion
          if (kDebugMode) {
            print('Déconnexion silencieuse: $e');
          }
        }
      }

      // Déclenche le flux de connexion avec force de sélection
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      // Si l'utilisateur annule, googleUser est null
      if (googleUser == null) {
        return null;
      }

      // Vérifier si l'utilisateur existe déjà
      final userExists = await userExistsWithEmail(googleUser.email);
      if (userExists) {
        // L'utilisateur existe déjà, déconnecter et lever une exception
        await googleSignIn.signOut();
        throw FirebaseAuthException(
          code: 'email-already-in-use',
          message: 'Un compte existe déjà avec cette adresse email.',
        );
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

      // Création de l'utilisateur avec google dans la collection 'users' sur Firebase
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

      await firestoreService.createOrUpdateUser(user);

      // Si c'est un vendeur, créer le profil vendeur avec les informations de base
      if (role == UserRoles.SELLER) {
        final firestoreServiceInstance = FirestoreService();
        await firestoreServiceInstance.createCompleteSeller(
          sellerId: googleUser.id,
          userId: googleUser.id,
          createdAt: DateTime.now(),
          documentsVerified: false, // À vérifier par l'admin
          sectors: [], // Sera mis à jour lors de la création de la boutique
          subSectors: [], // Sera mis à jour lors de la création de la boutique
          storeIds: [], // Liste vide au début
          mobileMoney: [], // Sera mis à jour lors de la création de la boutique
          deliveryInfos: {}, // Sera mis à jour lors de la création de la boutique
          fiscality: {}, // Sera mis à jour lors de la création de la boutique
          storeInfos: {
            'name': googleUser.displayName ?? '',
            'phone': '',
            'email': googleUser.email,
          },
        );
      }

      // Mettre à jour la dernière connexion
      await updateLastLogin();

      return userCredential.user;
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de l\'inscription Google: $e');
      }
      rethrow;
    } finally {
      // Marquer la fin de l'opération
      _isGoogleSignInInProgress = false;
    }
  }

  //========================================
  // UTILITAIRES
  //========================================

  static String _formatEmailFromPhone(PhoneNumber phoneNumber) {
    return '${phoneNumber.phoneNumber}@phone.beninpoulet.com';
  }

  static void signOut() {
    auth.signOut();
  }
}
