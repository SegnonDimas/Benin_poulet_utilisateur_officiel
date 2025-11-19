import 'package:lanhi/models/order_model.dart';
import 'package:lanhi/models/order_status.dart';
import 'package:lanhi/services/user_data_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Classe utilitaire pour diagnostiquer les problèmes de commandes
class OrderDiagnostic {
  static final UserDataService _userDataService = UserDataService();
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Diagnostic complet pour le vendeur
  static Future<Map<String, dynamic>> runVendorDiagnostic() async {
    print('\n╔════════════════════════════════════════╗');
    print('║  DIAGNOSTIC COMPLET COMMANDES VENDEUR  ║');
    print('╚════════════════════════════════════════╝\n');

    final result = <String, dynamic>{};

    try {
      // 1. Vérifier l'utilisateur connecté
      print('📍 ÉTAPE 1: Vérification utilisateur connecté');
      print('─────────────────────────────────────────');

      final seller = await _userDataService.getCurrentSeller();

      if (seller == null) {
        print('❌ ERREUR CRITIQUE: Aucun vendeur connecté !');
        result['error'] = 'Aucun vendeur connecté';
        return result;
      }

      print('✅ Vendeur connecté:');
      print('   - userId: ${seller.userId}');
      print('   - sellerId: ${seller.sellerId}');

      if (seller.storeInfos != null) {
        print('   - storeId: ${seller.storeInfos!['storeId'] ?? "NON DÉFINI"}');
        print('   - storeName: ${seller.storeInfos!['name'] ?? "NON DÉFINI"}');
      } else {
        print('   - storeInfos: NULL');
      }

      result['seller'] = {
        'userId': seller.userId,
        'sellerId': seller.sellerId,
        'storeId': seller.storeInfos?['storeId'],
      };

      // 2. Récupérer TOUTES les commandes
      print('\n📍 ÉTAPE 2: Analyse de TOUTES les commandes');
      print('─────────────────────────────────────────');

      final allOrdersSnapshot = await _firestore.collection('orders').get();

      print(
          '✅ Total commandes dans Firestore: ${allOrdersSnapshot.docs.length}');

      if (allOrdersSnapshot.docs.isEmpty) {
        print('⚠️ ATTENTION: Aucune commande dans Firestore !');
        result['totalOrders'] = 0;
        result['vendorOrders'] = 0;
        return result;
      }

      result['totalOrders'] = allOrdersSnapshot.docs.length;

      // Analyser chaque commande
      print('\n📋 Liste de toutes les commandes:');
      final sellerIds = <String>{};
      final storeIds = <String>{};

      for (var doc in allOrdersSnapshot.docs) {
        final data = doc.data();
        final docSellerId = data['sellerId'] as String?;
        final docStoreId = data['storeId'] as String?;
        final docStatus = data['currentStatus'] as String?;

        print('\n  📦 ${doc.id}:');
        print('     - clientId: ${data['clientId']}');
        print('     - clientName: ${data['clientName']}');
        print('     - sellerId: $docSellerId');
        print('     - storeId: $docStoreId');
        print('     - currentStatus: $docStatus');
        print('     - totalAmount: ${data['totalAmount']}');

        if (docSellerId != null) sellerIds.add(docSellerId);
        if (docStoreId != null) storeIds.add(docStoreId);
      }

      print('\n📊 IDs uniques trouvés:');
      print('   - sellerIds: ${sellerIds.toList()}');
      print('   - storeIds: ${storeIds.toList()}');

      result['uniqueSellerIds'] = sellerIds.toList();
      result['uniqueStoreIds'] = storeIds.toList();

      // 3. Test requête par sellerId
      print('\n📍 ÉTAPE 3: Test requête par sellerId');
      print('─────────────────────────────────────────');
      print('🔍 Recherche avec sellerId: ${seller.userId}');

      final sellerOrdersSnapshot = await _firestore
          .collection('orders')
          .where('sellerId', isEqualTo: seller.userId)
          .get();

      print('✅ Commandes trouvées: ${sellerOrdersSnapshot.docs.length}');

      if (sellerOrdersSnapshot.docs.isEmpty) {
        print('⚠️ AUCUNE commande pour ce sellerId !');
        print('💡 Vérifiez que les commandes dans Firestore ont bien:');
        print('   sellerId = "${seller.userId}"');
      } else {
        print('📋 Détails:');
        for (var doc in sellerOrdersSnapshot.docs) {
          final data = doc.data();
          print(
              '  - ${doc.id}: ${data['currentStatus']} (${data['totalAmount']} F)');
        }
      }

      result['vendorOrdersBySellerId'] = sellerOrdersSnapshot.docs.length;

      // 4. Test requête par storeId (si disponible)
      if (seller.storeInfos?['storeId'] != null) {
        print('\n📍 ÉTAPE 4: Test requête par storeId');
        print('─────────────────────────────────────────');
        print('🔍 Recherche avec storeId: ${seller.storeInfos!['storeId']}');

        final storeOrdersSnapshot = await _firestore
            .collection('orders')
            .where('storeId', isEqualTo: seller.storeInfos!['storeId'])
            .get();

        print('✅ Commandes trouvées: ${storeOrdersSnapshot.docs.length}');

        result['vendorOrdersByStoreId'] = storeOrdersSnapshot.docs.length;
      }

      // 5. Test de parsing
      print('\n📍 ÉTAPE 5: Test de parsing des commandes');
      print('─────────────────────────────────────────');

      int successCount = 0;
      int errorCount = 0;
      final errors = <String>[];

      for (var doc in sellerOrdersSnapshot.docs) {
        try {
          final order = OrderModel.fromFirestore(doc);
          print('  ✅ ${doc.id} parsé: ${order.currentStatus.value}');
          successCount++;
        } catch (e) {
          print('  ❌ ${doc.id} ERREUR: $e');
          errors.add('${doc.id}: $e');
          errorCount++;
        }
      }

      print('\n📊 Résumé parsing:');
      print('   - Succès: $successCount');
      print('   - Erreurs: $errorCount');

      result['parsingSuccess'] = successCount;
      result['parsingErrors'] = errorCount;
      result['errors'] = errors;

      // 6. Recommandations
      print('\n📍 ÉTAPE 6: Recommandations');
      print('─────────────────────────────────────────');

      if (sellerOrdersSnapshot.docs.isEmpty) {
        print('⚠️ PROBLÈME IDENTIFIÉ: Aucune commande pour ce vendeur');
        print('\n💡 SOLUTIONS:');
        print('   1. Vérifier que les commandes créées ont bien:');
        print('      sellerId = "${seller.userId}"');
        print(
            '   2. OU utiliser storeId si les commandes sont liées à la boutique');
        print('   3. Comparer avec les IDs trouvés: $sellerIds');

        // Chercher une correspondance approximative
        for (var foundId in sellerIds) {
          if (foundId.contains(seller.userId.substring(0, 5)) ||
              seller.userId.contains(foundId.substring(0, 5))) {
            print('\n   ⚠️ ID similaire trouvé: $foundId');
            print('      Peut-être une variation de l\'ID vendeur ?');
          }
        }
      } else {
        print('✅ Commandes trouvées ! Le problème est ailleurs.');
        print('\n🔍 Vérifications supplémentaires:');
        print('   - Le StreamBuilder reçoit-il les données ?');
        print('   - Les états sont-ils correctement gérés ?');
        print('   - Y a-t-il des erreurs de parsing ?');
      }

      print('\n╔════════════════════════════════════════╗');
      print('║         FIN DU DIAGNOSTIC              ║');
      print('╚════════════════════════════════════════╝\n');

      return result;
    } catch (e, stackTrace) {
      print('❌ ERREUR CRITIQUE PENDANT LE DIAGNOSTIC:');
      print('   $e');
      print('\n📚 Stack trace:');
      print('   $stackTrace');

      result['criticalError'] = e.toString();
      return result;
    }
  }

  /// Diagnostic pour une commande spécifique
  static Future<void> diagnoseOrder(String orderId) async {
    print('\n╔════════════════════════════════════════╗');
    print('║    DIAGNOSTIC COMMANDE INDIVIDUELLE    ║');
    print('╚════════════════════════════════════════╝\n');

    try {
      print('🔍 Recherche de la commande: $orderId');

      final doc = await _firestore.collection('orders').doc(orderId).get();

      if (!doc.exists) {
        print('❌ ERREUR: Cette commande n\'existe pas dans Firestore !');
        return;
      }

      print('✅ Commande trouvée !');

      final data = doc.data()!;
      print('\n📋 Données brutes:');
      data.forEach((key, value) {
        print('   $key: $value (${value.runtimeType})');
      });

      print('\n🧪 Test de parsing:');
      try {
        final order = OrderModel.fromFirestore(doc);
        print('✅ Parsing réussi !');
        print('   - Statut: ${order.currentStatus.label}');
        print('   - Client: ${order.clientName}');
        print('   - Vendeur: ${order.sellerName}');
        print('   - Total: ${order.grandTotal} F');
        print('   - Articles: ${order.items.length}');
        print('   - Historique: ${order.statusHistory.length} entrées');
      } catch (e) {
        print('❌ Erreur de parsing: $e');
      }

      print('\n╔════════════════════════════════════════╗');
      print('║         FIN DU DIAGNOSTIC              ║');
      print('╚════════════════════════════════════════╝\n');
    } catch (e, stackTrace) {
      print('❌ ERREUR: $e');
      print('📚 Stack trace: $stackTrace');
    }
  }

  /// Afficher un résumé visuel
  static void printSummary(Map<String, dynamic> result) {
    print('\n╔════════════════════════════════════════╗');
    print('║         RÉSUMÉ DU DIAGNOSTIC           ║');
    print('╚════════════════════════════════════════╝\n');

    if (result.containsKey('error')) {
      print('❌ ERREUR: ${result['error']}');
      return;
    }

    if (result.containsKey('criticalError')) {
      print('❌ ERREUR CRITIQUE: ${result['criticalError']}');
      return;
    }

    final totalOrders = result['totalOrders'] ?? 0;
    final vendorOrders = result['vendorOrdersBySellerId'] ?? 0;

    print('📊 RÉSULTATS:');
    print('   ┌─────────────────────────────────────');
    print('   │ Total commandes Firestore: $totalOrders');
    print('   │ Commandes de ce vendeur: $vendorOrders');
    print('   └─────────────────────────────────────');

    if (vendorOrders == 0 && totalOrders > 0) {
      print('\n⚠️ PROBLÈME: Le vendeur n\'a aucune commande !');
      print('   Les IDs ne correspondent pas.');
      print('\n   IDs vendeur: ${result['seller']['userId']}');
      print('   IDs trouvés: ${result['uniqueSellerIds']}');
    } else if (vendorOrders > 0) {
      print('\n✅ SUCCÈS: Les commandes sont trouvées !');
      print('   Le problème est dans l\'affichage/parsing.');

      if (result['parsingErrors'] > 0) {
        print('\n⚠️ Erreurs de parsing détectées:');
        for (var error in result['errors'] ?? []) {
          print('   - $error');
        }
      }
    } else if (totalOrders == 0) {
      print('\n⚠️ Aucune commande dans Firestore.');
      print('   Créez une commande test côté client.');
    }

    print('\n╚════════════════════════════════════════╝\n');
  }
}
