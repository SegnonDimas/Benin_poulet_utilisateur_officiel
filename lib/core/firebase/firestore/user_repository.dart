import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../models/user.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // 🔹 Ajout ou mise à jour d'un utilisateur
  Future<void> createOrUpdateUser(User user) async {
    await _db.collection('users').doc(user.userId).set(
          user.toMap(),
          SetOptions(
              merge:
                  true), // merge permet de ne pas écraser les champs non spécifiés
        );
  }

  // 🔹 Récupérer un utilisateur par son ID
  Future<User?> getUserById(String userId) async {
    final doc = await _db.collection('users').doc(userId).get();
    if (doc.exists) {
      return User.fromMap(doc.data()!);
    } else {
      return null;
    }
  }

  // 🔹 Supprimer un utilisateur (peu probable mais utile à savoir)
  Future<void> deleteUser(String userId) async {
    await _db.collection('users').doc(userId).delete();
  }

  // 🔹 Écoute en temps réel (ex: mise à jour profil utilisateur en direct)
  Stream<User?> streamUser(String userId) {
    return _db.collection('users').doc(userId).snapshots().map((doc) {
      if (doc.exists) {
        return User.fromMap(doc.data()!);
      } else {
        return null;
      }
    });
  }
}
