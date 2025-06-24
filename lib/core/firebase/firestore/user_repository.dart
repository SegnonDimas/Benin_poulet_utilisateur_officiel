import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../models/user.dart';

/// Service pour interagir avec Firestore concernant les utilisateurs.
class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Crée ou met à jour un utilisateur dans Firestore.
  /// Si l'utilisateur existe déjà, seuls les champs spécifiés sont mis à jour grâce à `merge: true`.
  Future<void> createOrUpdateUser(AppUser user) async {
    await _db.collection('users').doc(user.userId).set(
          user.toMap(),
          SetOptions(merge: true),
        );
  }

  /// Récupère un utilisateur à partir de son ID.
  /// Retourne `null` si aucun utilisateur n'existe avec cet ID.
  Future<AppUser?> getUserById(String userId) async {
    final doc = await _db.collection('users').doc(userId).get();
    if (doc.exists) {
      return AppUser.fromMap(doc.data()!);
    } else {
      return null;
    }
  }

  /// Supprime un utilisateur de Firestore (peu courant, mais utile).
  Future<void> deleteUser(String userId) async {
    await _db.collection('users').doc(userId).delete();
  }

  /// Écoute en temps réel les changements sur le document utilisateur.
  /// Peut être utilisé pour réagir immédiatement à une mise à jour de profil.
  Stream<AppUser?> streamUser(String userId) {
    return _db.collection('users').doc(userId).snapshots().map((doc) {
      if (doc.exists) {
        return AppUser.fromMap(doc.data()!);
      } else {
        return null;
      }
    });
  }

  /// Vérifie si un utilisateur existe dans la base (utile pour éviter les doublons).
  Future<bool> userExists(String userId) async {
    final doc = await _db.collection('users').doc(userId).get();
    return doc.exists;
  }

  /// Recherche des utilisateurs par rôle (admin, seller, buyer, etc.).
  /// Peut être coûteux si beaucoup d'utilisateurs.
  Future<List<AppUser>> getUsersByRole(String role) async {
    final querySnapshot =
        await _db.collection('users').where('role', isEqualTo: role).get();
    return querySnapshot.docs
        .map((doc) => AppUser.fromMap(doc.data()))
        .toList();
  }
}
