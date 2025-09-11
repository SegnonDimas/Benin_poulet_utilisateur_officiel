import 'package:benin_poulet/core/firebase/auth/auth_services.dart';
import 'package:benin_poulet/core/firebase/firestore/user_repository.dart';

/// Service pour gérer le panier de l'utilisateur
class CartService {
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();

  final FirestoreUserServices _userService = FirestoreUserServices();

  /// Ajoute un produit au panier (favoritesProductIds)
  Future<bool> addProductToCart(String productId) async {
    try {
      final currentUser = AuthServices.auth.currentUser;
      if (currentUser == null) {
        print('Aucun utilisateur connecté');
        return false;
      }

      // Récupérer l'utilisateur actuel
      final user = await _userService.getUserById(currentUser.uid);
      if (user == null) {
        print('Utilisateur non trouvé');
        return false;
      }

      // Vérifier si le produit n'est pas déjà dans le panier
      final currentCart = user.favoriteProductIds ?? [];
      if (currentCart.contains(productId)) {
        print('Produit déjà dans le panier');
        return true; // Considéré comme succès car déjà présent
      }

      // Ajouter le produit au panier
      final updatedCart = [...currentCart, productId];
      final updatedUser = user.copyWith(favoriteProductIds: updatedCart);

      // Mettre à jour dans Firestore
      await _userService.createOrUpdateUser(updatedUser);
      print('Produit ajouté au panier avec succès');
      return true;
    } catch (e) {
      print('Erreur lors de l\'ajout au panier: $e');
      return false;
    }
  }

  /// Retire un produit du panier
  Future<bool> removeProductFromCart(String productId) async {
    try {
      final currentUser = AuthServices.auth.currentUser;
      if (currentUser == null) {
        print('Aucun utilisateur connecté');
        return false;
      }

      // Récupérer l'utilisateur actuel
      final user = await _userService.getUserById(currentUser.uid);
      if (user == null) {
        print('Utilisateur non trouvé');
        return false;
      }

      // Retirer le produit du panier
      final currentCart = user.favoriteProductIds ?? [];
      final updatedCart = currentCart.where((id) => id != productId).toList();
      final updatedUser = user.copyWith(favoriteProductIds: updatedCart);

      // Mettre à jour dans Firestore
      await _userService.createOrUpdateUser(updatedUser);
      print('Produit retiré du panier avec succès');
      return true;
    } catch (e) {
      print('Erreur lors de la suppression du panier: $e');
      return false;
    }
  }

  /// Vide complètement le panier
  Future<bool> clearCart() async {
    try {
      final currentUser = AuthServices.auth.currentUser;
      if (currentUser == null) {
        print('Aucun utilisateur connecté');
        return false;
      }

      // Récupérer l'utilisateur actuel
      final user = await _userService.getUserById(currentUser.uid);
      if (user == null) {
        print('Utilisateur non trouvé');
        return false;
      }

      // Vider le panier
      final updatedUser = user.copyWith(favoriteProductIds: []);
      await _userService.createOrUpdateUser(updatedUser);
      print('Panier vidé avec succès');
      return true;
    } catch (e) {
      print('Erreur lors du vidage du panier: $e');
      return false;
    }
  }

  /// Récupère la liste des IDs de produits dans le panier
  Future<List<String>> getCartProductIds() async {
    try {
      final currentUser = AuthServices.auth.currentUser;
      if (currentUser == null) {
        print('Aucun utilisateur connecté');
        return [];
      }

      // Récupérer l'utilisateur actuel
      final user = await _userService.getUserById(currentUser.uid);
      if (user == null) {
        print('Utilisateur non trouvé');
        return [];
      }

      return user.favoriteProductIds ?? [];
    } catch (e) {
      print('Erreur lors de la récupération du panier: $e');
      return [];
    }
  }

  /// Vérifie si un produit est dans le panier
  Future<bool> isProductInCart(String productId) async {
    try {
      final cartIds = await getCartProductIds();
      return cartIds.contains(productId);
    } catch (e) {
      print('Erreur lors de la vérification du panier: $e');
      return false;
    }
  }

  /// Récupère le nombre de produits dans le panier
  Future<int> getCartCount() async {
    try {
      final cartIds = await getCartProductIds();
      return cartIds.length;
    } catch (e) {
      print('Erreur lors du comptage du panier: $e');
      return 0;
    }
  }
}
