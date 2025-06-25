import 'package:firebase_auth/firebase_auth.dart';

import '../../../models/user.dart';
import '../firestore/user_repository.dart';

class AuthServices {
  static final auth = FirebaseAuth.instance;
  static final firestoreService = FirestoreService();

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
}
