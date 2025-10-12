import 'package:benin_poulet/constants/routes.dart';
import 'package:benin_poulet/models/order_model.dart';
import 'package:benin_poulet/models/order_status.dart';
import 'package:benin_poulet/services/user_data_service.dart';
import 'package:benin_poulet/utils/app_utils.dart';
import 'package:benin_poulet/utils/order_diagnostic.dart';
import 'package:benin_poulet/views/colors/app_colors.dart';
import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:benin_poulet/widgets/app_button.dart';
import 'package:benin_poulet/widgets/app_text.dart';
import 'package:benin_poulet/widgets/order_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Page de gestion des commandes vendeur - VERSION STABLE
class VendorOrdersPage extends StatefulWidget {
  const VendorOrdersPage({super.key});

  @override
  State<VendorOrdersPage> createState() => _VendorOrdersPageState();
}

class _VendorOrdersPageState extends State<VendorOrdersPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? sellerId;
  String? storeId;
  final UserDataService _userDataService = UserDataService();

  // Stream pour les commandes (créé une seule fois)
  Stream<List<OrderModel>>? _ordersStream;

  final List<Map<String, dynamic>> _tabs = [
    {
      'title': 'Nouvelles',
      'status': OrderStatus.pendingValidation,
      'icon': Icons.notification_important,
    },
    {
      'title': 'En préparation',
      'statuses': [
        OrderStatus.validated,
        OrderStatus.inPreparation,
        OrderStatus.readyForDelivery,
      ],
      'icon': Icons.kitchen,
    },
    {
      'title': 'En route',
      'statuses': [OrderStatus.inDelivery, OrderStatus.delivered],
      'icon': Icons.local_shipping,
    },
    {
      'title': 'Terminées',
      'status': OrderStatus.completed,
      'icon': Icons.check_circle,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _loadSellerInfo();
  }

  Future<void> _loadSellerInfo() async {
    print('\n╔════════════════════════════════════════╗');
    print('║  VENDOR ORDERS: Chargement vendeur     ║');
    print('╚════════════════════════════════════════╝\n');

    try {
      final seller = await _userDataService.getCurrentSeller();

      if (seller == null) {
        print('❌ ERREUR: Aucun vendeur connecté !');
        if (mounted) {
          AppUtils.showErrorNotification(
            context,
            'Erreur: Aucun vendeur connecté',
            null,
          );
        }
        return;
      }

      print('✅ Vendeur récupéré:');
      print('   - userId: ${seller.userId}');
      print('   - sellerId: ${seller.sellerId}');
      print('   - storeInfos: ${seller.storeInfos}');

      if (mounted) {
        setState(() {
          sellerId = seller.userId;
          storeId = seller.storeInfos?['storeId'] as String?;
          // Créer le stream UNE SEULE FOIS
          _ordersStream = _createOrdersStream();
        });

        print('✅ IDs définis:');
        print('   - sellerId: $sellerId');
        print('   - storeId: ${storeId ?? "NON DÉFINI"}');
        print('🎯 Stream créé - Prêt à charger\n');
      }
    } catch (e, stackTrace) {
      print('❌ Erreur lors du chargement du vendeur:');
      print('   $e');
      print('   $stackTrace');

      if (mounted) {
        AppUtils.showErrorNotification(
          context,
          'Erreur de chargement: $e',
          null,
        );
      }
    }
  }

  /// Créer le stream des commandes (appelé une seule fois)
  Stream<List<OrderModel>> _createOrdersStream() {
    print('🔄 Création du stream pour sellerId: $sellerId');

    return FirebaseFirestore.instance
        .collection('orders')
        .where('sellerId', isEqualTo: sellerId)
        .snapshots()
        .map((snapshot) {
      print('📦 Documents reçus: ${snapshot.docs.length}');

      final orders = <OrderModel>[];

      for (var doc in snapshot.docs) {
        try {
          final order = OrderModel.fromFirestore(doc);
          orders.add(order);
        } catch (e) {
          print('  ❌ ${doc.id} ERREUR: $e');
        }
      }

      // Trier par date
      orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      print('✅ Total parsé: ${orders.length}');
      return orders;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText(
          text: 'Mes Commandes',
          fontSize: mediumText(),
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.medical_services, color: Colors.red),
            tooltip: 'Diagnostic complet',
            onPressed: () => _runFullDiagnostic(),
          ),
          IconButton(
            icon: const Icon(Icons.bug_report),
            tooltip: 'Debug rapide',
            onPressed: () => _quickDebug(),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: AppColors.primaryColor,
          labelColor: AppColors.primaryColor,
          unselectedLabelColor: Colors.grey,
          tabs: _tabs.map((tab) {
            return Tab(
              icon: Icon(tab['icon'] as IconData),
              text: tab['title'] as String,
            );
          }).toList(),
        ),
      ),
      body: sellerId == null
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  AppText(text: 'Chargement de votre boutique...'),
                ],
              ),
            )
          : TabBarView(
              controller: _tabController,
              children: _tabs.map((tab) {
                return _buildOrdersTab(tab);
              }).toList(),
            ),
    );
  }

  /// Construit un onglet avec StreamBuilder STABLE
  Widget _buildOrdersTab(Map<String, dynamic> tabConfig) {
    // Utiliser le stream créé une seule fois
    if (_ordersStream == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return StreamBuilder<List<OrderModel>>(
      stream: _ordersStream,
      builder: (context, snapshot) {
        print('───────────────────────────────────');
        print(
            '📡 StreamBuilder "${tabConfig['title']}": ${snapshot.connectionState}');

        // Gestion de l'état de connexion
        if (snapshot.connectionState == ConnectionState.waiting) {
          print('⏳ En attente de la première donnée...');
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                AppText(text: 'Chargement des commandes...'),
              ],
            ),
          );
        }

        // Gestion des erreurs
        if (snapshot.hasError) {
          print('❌ ERREUR StreamBuilder: ${snapshot.error}');
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  AppText(
                    text: 'Erreur de chargement',
                    fontSize: mediumText(),
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 8),
                  AppText(
                    text: '${snapshot.error}',
                    fontSize: smallText(),
                    textAlign: TextAlign.center,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 20),
                  AppButton(
                    onTap: () {
                      setState(() {}); // Force rebuild
                    },
                    color: AppColors.primaryColor,
                    child: const AppText(
                      text: 'Réessayer',
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // Vérifier si des données existent
        if (!snapshot.hasData) {
          print('⚠️ Pas de données (hasData=false)');
          return const Center(
            child: AppText(text: 'Aucune donnée disponible'),
          );
        }

        final allOrders = snapshot.data!;
        print('📊 Total commandes reçues: ${allOrders.length}');

        // Filtrer selon l'onglet
        final filteredOrders = _filterOrdersByTab(allOrders, tabConfig);

        print(
            '🎯 Commandes filtrées pour "${tabConfig['title']}": ${filteredOrders.length}');
        print('───────────────────────────────────\n');

        // Afficher la liste
        return _buildOrdersList(filteredOrders, tabConfig['title'] as String);
      },
    );
  }

  /// Filtrer les commandes selon la configuration de l'onglet
  List<OrderModel> _filterOrdersByTab(
    List<OrderModel> orders,
    Map<String, dynamic> tabConfig,
  ) {
    // Si un seul statut
    if (tabConfig.containsKey('status')) {
      final status = tabConfig['status'] as OrderStatus;
      return orders.where((o) => o.currentStatus == status).toList();
    }

    // Si plusieurs statuts
    if (tabConfig.containsKey('statuses')) {
      final statuses = tabConfig['statuses'] as List<OrderStatus>;
      return orders.where((o) => statuses.contains(o.currentStatus)).toList();
    }

    return orders;
  }

  /// Construire la liste des commandes
  Widget _buildOrdersList(List<OrderModel> orders, String tabTitle) {
    if (orders.isEmpty) {
      return RefreshIndicator(
        onRefresh: () async {
          setState(() {}); // Force rebuild
        },
        child: ListView(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.3),
            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    size: 80,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 16),
                  AppText(
                    text: 'Aucune commande',
                    fontSize: mediumText(),
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 8),
                  AppText(
                    text: 'Les commandes "$tabTitle" apparaîtront ici',
                    fontSize: smallText(),
                    color: Colors.grey.shade600,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // Grouper les commandes par date
    final groupedOrders = _groupOrdersByDate(orders);

    return RefreshIndicator(
      onRefresh: () async {
        setState(() {}); // Force rebuild du stream
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _calculateTotalItems(groupedOrders),
        itemBuilder: (context, index) {
          return _buildItemAtIndex(groupedOrders, index);
        },
      ),
    );
  }

  /// Grouper les commandes par date
  Map<String, List<OrderModel>> _groupOrdersByDate(List<OrderModel> orders) {
    final grouped = <String, List<OrderModel>>{};
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    for (var order in orders) {
      final orderDate = DateTime(
        order.createdAt.year,
        order.createdAt.month,
        order.createdAt.day,
      );

      String dateKey;
      if (orderDate == today) {
        dateKey = 'Aujourd\'hui';
      } else if (orderDate == yesterday) {
        dateKey = 'Hier';
      } else if (orderDate.isAfter(today.subtract(const Duration(days: 7)))) {
        dateKey = _getWeekdayName(orderDate);
      } else {
        dateKey = DateFormat('dd MMMM yyyy', 'fr_FR').format(orderDate);
      }

      if (!grouped.containsKey(dateKey)) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(order);
    }

    return grouped;
  }

  /// Calculer le nombre total d'items
  int _calculateTotalItems(Map<String, List<OrderModel>> groupedOrders) {
    int total = 0;
    groupedOrders.forEach((dateKey, orders) {
      total++; // Header de date
      total += orders.length; // Commandes
    });
    return total;
  }

  /// Construire l'item à l'index donné
  Widget _buildItemAtIndex(
      Map<String, List<OrderModel>> groupedOrders, int index) {
    int currentIndex = 0;

    for (var entry in groupedOrders.entries) {
      final dateKey = entry.key;
      final orders = entry.value;

      // Header de date
      if (currentIndex == index) {
        return _buildDateHeader(dateKey, orders.length);
      }
      currentIndex++;

      // Commandes de cette date
      for (var order in orders) {
        if (currentIndex == index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: OrderCard(
              order: order,
              showClient: true,
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.VENDOR_ORDER_DETAILS,
                  arguments: order,
                );
              },
            ),
          );
        }
        currentIndex++;
      }
    }

    return const SizedBox.shrink();
  }

  /// Construire le header de date
  Widget _buildDateHeader(String dateLabel, int count) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 1,
              color: Colors.grey.shade300,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: AppColors.primaryColor,
                ),
                const SizedBox(width: 8),
                AppText(
                  text: dateLabel,
                  fontSize: smallText(),
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
                const SizedBox(width: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: AppText(
                    text: '$count',
                    fontSize: smallText() * 0.85,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              height: 1,
              color: Colors.grey.shade300,
            ),
          ),
        ],
      ),
    );
  }

  /// Obtenir le nom du jour de la semaine
  String _getWeekdayName(DateTime date) {
    final weekdays = [
      'Lundi',
      'Mardi',
      'Mercredi',
      'Jeudi',
      'Vendredi',
      'Samedi',
      'Dimanche'
    ];
    return weekdays[date.weekday - 1];
  }

  /// Diagnostic complet
  Future<void> _runFullDiagnostic() async {
    print('\n🚀 Lancement du diagnostic complet...\n');

    try {
      final result = await OrderDiagnostic.runVendorDiagnostic();

      OrderDiagnostic.printSummary(result);

      if (mounted) {
        final totalOrders = result['totalOrders'] ?? 0;
        final vendorOrders = result['vendorOrdersBySellerId'] ?? 0;

        String message = 'Diagnostic terminé\n\n';
        message += 'Total commandes: $totalOrders\n';
        message += 'Vos commandes: $vendorOrders\n\n';

        if (vendorOrders == 0 && totalOrders > 0) {
          message += '⚠️ Problème: Les IDs ne correspondent pas\n\n';
          message += 'Consultez la console pour plus de détails';
        } else if (vendorOrders > 0) {
          message += '✅ Commandes trouvées !\n';
          message += 'Le problème est dans l\'affichage';
        }

        AppUtils.showInfoDialog(
          context: context,
          message: message,
        );
      }
    } catch (e) {
      print('❌ Erreur diagnostic: $e');
      if (mounted) {
        AppUtils.showErrorNotification(
          context,
          'Erreur diagnostic: $e',
          null,
        );
      }
    }
  }

  /// Debug rapide
  Future<void> _quickDebug() async {
    print('\n🔍 DEBUG RAPIDE\n');

    try {
      print('1. SellerId: $sellerId');
      print('2. StoreId: $storeId');

      final snapshot = await FirebaseFirestore.instance
          .collection('orders')
          .where('sellerId', isEqualTo: sellerId)
          .get();

      print('3. Commandes trouvées: ${snapshot.docs.length}');

      for (var doc in snapshot.docs) {
        final data = doc.data();
        print('   - ${doc.id}: ${data['currentStatus']}');
      }

      if (mounted) {
        AppUtils.showInfoDialog(
          context: context,
          message: 'Debug rapide\n\n'
              'SellerId: $sellerId\n'
              'Commandes: ${snapshot.docs.length}\n\n'
              'Consultez la console',
        );
      }
    } catch (e) {
      print('❌ Erreur: $e');
    }
  }
}

/// Widget pour un onglet avec filtrage
class _OrderTabContent extends StatelessWidget {
  final Stream<List<OrderModel>> ordersStream;
  final Map<String, dynamic> tabConfig;
  final Function(List<OrderModel>, Map<String, dynamic>) filterCallback;
  final Function(List<OrderModel>, String) buildListCallback;

  const _OrderTabContent({
    required this.ordersStream,
    required this.tabConfig,
    required this.filterCallback,
    required this.buildListCallback,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<OrderModel>>(
      stream: ordersStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                AppText(text: 'Chargement...'),
              ],
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: AppText(
              text: 'Erreur: ${snapshot.error}',
              color: Colors.red,
            ),
          );
        }

        if (!snapshot.hasData) {
          return const Center(child: AppText(text: 'Aucune donnée'));
        }

        final allOrders = snapshot.data!;
        final filteredOrders = filterCallback(allOrders, tabConfig);

        return buildListCallback(filteredOrders, tabConfig['title'] as String);
      },
    );
  }
}
