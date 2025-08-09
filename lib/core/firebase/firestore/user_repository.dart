import 'package:benin_poulet/constants/firebase_collections/firebaseCollections.dart';
import 'package:benin_poulet/core/firebase/auth/auth_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../models/user.dart';
import 'seller_repository.dart';

/// Service pour interagir avec Firestore concernant les utilisateurs.
class FirestoreUserServices {
  final FirebaseFirestore firebaseInstance = FirebaseFirestore.instance;
  final SellerRepository _sellerRepository = SellerRepository();

  static final currentUser = FirebaseFirestore.instance
      .collection(FirebaseCollections.usersCollection)
      .doc(AuthServices.userId)
      .get();

  /// Crée ou met à jour un utilisateur dans Firestore.
  /// Si l'utilisateur existe déjà, seuls les champs spécifiés sont mis à jour grâce à `merge: true`.
  /// Si l'utilisateur est un vendeur, crée ou met à jour son profil vendeur en préservant les données existantes.
  Future<void> createOrUpdateUser(AppUser user) async {
    final userData = user.toMap();

    // Mise à jour de l'utilisateur dans la collection FirebaseCollections.usersCollection
    await firebaseInstance
        .collection(FirebaseCollections.usersCollection)
        .doc(user.userId)
        .set(
          userData,
          SetOptions(merge: true),
        );

    // Si l'utilisateur est un vendeur, on s'assure qu'il existe dans la collection 'sellers'
    if (user.role == 'seller') {
      // On passe le repository pour pouvoir récupérer les données existantes si nécessaire
      final seller = await SellerRepository.createSellerFromUser(
        userId: user.userId,
        role: user.role,
        fullName: user.fullName,
        email: user.authIdentifier,
        phoneNumber: user
            .authIdentifier, // Supposant que l'identifiant est un numéro de téléphone
        repository: _sellerRepository,
      );

      await _sellerRepository.createOrUpdateSeller(seller);
    }
  }

  /// Récupère un utilisateur à partir de son ID.
  /// Retourne `null` si aucun utilisateur n'existe avec cet ID.
  Future<AppUser?> getUserById(String userId) async {
    final doc = await firebaseInstance
        .collection(FirebaseCollections.usersCollection)
        .doc(userId)
        .get();
    if (doc.exists) {
      return AppUser.fromMap(doc.data()!);
    } else {
      return null;
    }
  }

  /// Supprime un utilisateur de Firestore (peu courant, mais utile).
  Future<void> deleteUser(String userId) async {
    await firebaseInstance
        .collection(FirebaseCollections.usersCollection)
        .doc(userId)
        .delete();
  }

  /// Écoute en temps réel les changements sur le document utilisateur.
  /// Peut être utilisé pour réagir immédiatement à une mise à jour de profil.
  Stream<AppUser?> streamUser(String userId) {
    return firebaseInstance
        .collection(FirebaseCollections.usersCollection)
        .doc(userId)
        .snapshots()
        .map((doc) {
      if (doc.exists) {
        return AppUser.fromMap(doc.data()!);
      } else {
        return null;
      }
    });
  }

  /// Vérifie si un utilisateur existe dans la base (utile pour éviter les doublons).
  Future<bool> userExists(String userId) async {
    final doc = await firebaseInstance
        .collection(FirebaseCollections.usersCollection)
        .doc(userId)
        .get();
    return doc.exists;
  }

  /// Recherche des utilisateurs par rôle (admin, seller, buyer, etc.).
  /// Peut être coûteux si beaucoup d'utilisateurs.
  Future<List<AppUser>> getUsersByRole(String role) async {
    final querySnapshot = await firebaseInstance
        .collection(FirebaseCollections.usersCollection)
        .where('role', isEqualTo: role)
        .get();
    return querySnapshot.docs
        .map((doc) => AppUser.fromMap(doc.data()))
        .toList();
  }
}
