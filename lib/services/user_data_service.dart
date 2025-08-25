import 'package:benin_poulet/constants/userRoles.dart';
import 'package:benin_poulet/core/firebase/auth/auth_services.dart';
import 'package:benin_poulet/core/firebase/firestore/firestore_service.dart';
import 'package:benin_poulet/core/firebase/firestore/user_repository.dart';
import 'package:benin_poulet/core/firebase/firestore/seller_repository.dart';
import 'package:benin_poulet/models/seller.dart';
import 'package:benin_poulet/models/user.dart';

/// Service pour récupérer les données de l'utilisateur connecté
class UserDataService {
  static final UserDataService _instance = UserDataService._internal();
  factory UserDataService() => _instance;
  UserDataService._internal();

  final FirestoreService _firestoreService = FirestoreService();
  final FirestoreUserServices _userService = FirestoreUserServices();
  final SellerRepository _sellerRepository = SellerRepository();

  /// Récupère l'utilisateur connecté avec ses informations complètes
  Future<AppUser?> getCurrentUser() async {
    try {
      // Récupérer l'ID utilisateur de manière dynamique
      final currentUserId = AuthServices.auth.currentUser?.uid;
      if (currentUserId == null) {
        print('Aucun utilisateur connecté dans Firebase Auth');
        return null;
      }

      return await _userService.getUserById(currentUserId);
    } catch (e) {
      print('Erreur lors de la récupération de l\'utilisateur: $e');
      return null;
    }
  }

  /// Récupère le vendeur connecté avec ses informations complètes
  Future<Seller?> getCurrentSeller() async {
    try {
      // Récupérer l'ID utilisateur de manière dynamique
      final currentUserId = AuthServices.auth.currentUser?.uid;
      if (currentUserId == null) return null;

      return await _sellerRepository.getSellerByUserId(currentUserId);
    } catch (e) {
      print('Erreur lors de la récupération du vendeur: $e');
      return null;
    }
  }

  /// Récupère l'utilisateur et le vendeur connecté (si applicable)
  Future<Map<String, dynamic>?> getCurrentUserWithSeller() async {
    try {
      // Récupérer l'ID utilisateur de manière dynamique
      final currentUserId = AuthServices.auth.currentUser?.uid;
      if (currentUserId == null) return null;

      return await _firestoreService.getUserWithSellerInfo(currentUserId);
    } catch (e) {
      print('Erreur lors de la récupération des données utilisateur: $e');
      return null;
    }
  }

  /// Vérifie si l'utilisateur connecté est un vendeur
  Future<bool> isCurrentUserSeller() async {
    try {
      final user = await getCurrentUser();
      return user?.role == UserRoles.SELLER;
    } catch (e) {
      print('Erreur lors de la vérification du rôle: $e');
      return false;
    }
  }

  /// Vérifie si l'utilisateur connecté est un client
  Future<bool> isCurrentUserClient() async {
    try {
      final user = await getCurrentUser();
      return user?.role == UserRoles.BUYER;
    } catch (e) {
      print('Erreur lors de la vérification du rôle: $e');
      return false;
    }
  }

  /// Récupère le nom de la boutique du vendeur connecté
  Future<String?> getCurrentSellerShopName() async {
    try {
      final seller = await getCurrentSeller();
      if (seller?.storeInfos != null) {
        return seller!.storeInfos!['name'] as String?;
      }
      return null;
    } catch (e) {
      print('Erreur lors de la récupération du nom de boutique: $e');
      return null;
    }
  }

  /// Récupère l'email de la boutique du vendeur connecté
  Future<String?> getCurrentSellerShopEmail() async {
    try {
      final seller = await getCurrentSeller();
      if (seller?.storeInfos != null) {
        return seller!.storeInfos!['email'] as String?;
      }
      return null;
    } catch (e) {
      print('Erreur lors de la récupération de l\'email de boutique: $e');
      return null;
    }
  }

  /// Récupère les secteurs d'activité du vendeur connecté
  Future<List<String>?> getCurrentSellerSectors() async {
    try {
      final seller = await getCurrentSeller();
      return seller?.sectors;
    } catch (e) {
      print('Erreur lors de la récupération des secteurs: $e');
      return null;
    }
  }

  /// Récupère le statut de vérification du vendeur connecté
  Future<bool?> getCurrentSellerVerificationStatus() async {
    try {
      final seller = await getCurrentSeller();
      return seller?.documentsVerified;
    } catch (e) {
      print('Erreur lors de la récupération du statut de vérification: $e');
      return null;
    }
  }

  /// Récupère le nombre de commandes du client connecté
  Future<int> getCurrentClientOrdersCount() async {
    try {
      // TODO: Implémenter la récupération des commandes depuis Firestore
      // Pour l'instant, retourner une valeur par défaut
      return 0;
    } catch (e) {
      print('Erreur lors de la récupération du nombre de commandes: $e');
      return 0;
    }
  }

  /// Récupère le nombre de favoris du client connecté
  Future<int> getCurrentClientFavoritesCount() async {
    try {
      final user = await getCurrentUser();
      if (user?.favoriteStoreIds != null) {
        return user!.favoriteStoreIds!.length;
      }
      return 0;
    } catch (e) {
      print('Erreur lors de la récupération du nombre de favoris: $e');
      return 0;
    }
  }

  /// Récupère le nombre d'avis du client connecté
  Future<int> getCurrentClientReviewsCount() async {
    try {
      // TODO: Implémenter la récupération des avis depuis Firestore
      // Pour l'instant, retourner une valeur par défaut
      return 0;
    } catch (e) {
      print('Erreur lors de la récupération du nombre d\'avis: $e');
      return 0;
    }
  }
}
