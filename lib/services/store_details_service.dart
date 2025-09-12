import 'package:benin_poulet/core/firebase/firestore/product_repository.dart';
import 'package:benin_poulet/core/firebase/firestore/store_repository.dart';
import 'package:benin_poulet/core/firebase/firestore/seller_repository.dart';
import 'package:benin_poulet/core/firebase/firestore/user_repository.dart';
import 'package:benin_poulet/models/produit.dart';

class StoreDetailsService {
  static final StoreDetailsService _instance = StoreDetailsService._internal();
  factory StoreDetailsService() => _instance;
  StoreDetailsService._internal();

  final ProductRepository _productRepository = ProductRepository();
  final FirestoreStoreService _storeService = FirestoreStoreService();
  final SellerRepository _sellerRepository = SellerRepository();
  final FirestoreUserServices _userService = FirestoreUserServices();

  /// Récupère les informations complètes d'une boutique
  Future<Map<String, dynamic>?> getStoreDetails(String storeId) async {
    try {
      // Récupérer la boutique
      final store = await _storeService.getStore(storeId);
      if (store == null) return null;

      // Récupérer le vendeur
      final seller = await _sellerRepository.getSeller(store.sellerId);
      if (seller == null) return null;

      // Récupérer les informations utilisateur du vendeur
      final sellerUser = await _userService.getUserById(seller.userId);
      if (sellerUser == null) return null;

      // Récupérer les produits de la boutique
      final productsSnapshot = await _productRepository.getProductsByStore(storeId).first;

      // Calculer la note moyenne
      double averageRating = 0.0;
      if (store.storeRatings != null && store.storeRatings!.isNotEmpty) {
        averageRating = store.storeRatings!.reduce((a, b) => a + b) / store.storeRatings!.length;
      }

      return {
        'store': store,
        'seller': seller,
        'sellerUser': sellerUser,
        'realProducts': productsSnapshot,
        'averageRating': averageRating,
        'productCount': productsSnapshot.length,
        'reviewCount': store.storeRatings?.length ?? 0,
      };
    } catch (e) {
      print('Erreur lors de la récupération des détails de la boutique: $e');
      return null;
    }
  }

  /// Récupère les produits d'une boutique
  Future<List<Produit>> getStoreProducts(String storeId) async {
    try {
      return await _productRepository.getProductsByStore(storeId).first;
    } catch (e) {
      print('Erreur lors de la récupération des produits de la boutique: $e');
      return [];
    }
  }
}
