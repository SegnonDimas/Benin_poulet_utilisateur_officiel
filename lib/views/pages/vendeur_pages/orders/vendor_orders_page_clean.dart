import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lanhi/constants/routes.dart';
import 'package:lanhi/models/order_model.dart';
import 'package:lanhi/models/order_status.dart';
import 'package:lanhi/services/user_data_service.dart';
import 'package:lanhi/utils/app_utils.dart';
import 'package:lanhi/utils/order_diagnostic.dart';
import 'package:lanhi/views/colors/app_colors.dart';
import 'package:lanhi/views/sizes/text_sizes.dart';
import 'package:lanhi/widgets/app_text.dart';
import 'package:lanhi/widgets/order_card.dart';

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

  // Stream créé une seule fois
  Stream<QuerySnapshot>? _ordersStream;

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
        return;
      }

      print('✅ Vendeur récupéré:');
      print('   - userId: ${seller.userId}');
      print('   - sellerId: ${seller.sellerId}');

      if (mounted) {
        setState(() {
          sellerId = seller.userId;
          storeId = seller.storeInfos?['storeId'] as String?;
          // Créer le stream UNE SEULE FOIS
          _ordersStream = FirebaseFirestore.instance
              .collection('orders')
              .where('sellerId', isEqualTo: sellerId)
              .snapshots();
        });

        print('✅ IDs définis: sellerId=$sellerId');
        print('✅ Stream créé - Stable pour tous les onglets\n');
      }
    } catch (e) {
      print('❌ Erreur: $e');
    }
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
      body: sellerId == null || _ordersStream == null
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  AppText(text: 'Chargement...'),
                ],
              ),
            )
          : TabBarView(
              controller: _tabController,
              children: _tabs.map((tab) => _buildOrdersTab(tab)).toList(),
            ),
    );
  }

  /// Construire un onglet - Utilise le même stream pour tous
  Widget _buildOrdersTab(Map<String, dynamic> tabConfig) {
    return StreamBuilder<QuerySnapshot>(
      stream: _ordersStream!, // Réutiliser le même stream
      builder: (context, snapshot) {
        print('───────────────────────────────────');
        print('📡 Onglet "${tabConfig['title']}": ${snapshot.connectionState}');

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

        // Parser les commandes
        final allOrders = <OrderModel>[];
        for (var doc in snapshot.data!.docs) {
          try {
            allOrders.add(OrderModel.fromFirestore(doc));
          } catch (e) {
            print('❌ Erreur parsing ${doc.id}: $e');
          }
        }

        // Trier par date
        allOrders.sort((a, b) => b.createdAt.compareTo(a.createdAt));

        // Filtrer selon l'onglet
        final filteredOrders = _filterOrdersByTab(allOrders, tabConfig);

        print(
            '🎯 Commandes pour "${tabConfig['title']}": ${filteredOrders.length}');
        print('───────────────────────────────────\n');

        return _buildOrdersList(filteredOrders, tabConfig['title'] as String);
      },
    );
  }

  /// Filtrer selon le tab
  List<OrderModel> _filterOrdersByTab(
    List<OrderModel> orders,
    Map<String, dynamic> tabConfig,
  ) {
    if (tabConfig.containsKey('status')) {
      final status = tabConfig['status'] as OrderStatus;
      return orders.where((o) => o.currentStatus == status).toList();
    }

    if (tabConfig.containsKey('statuses')) {
      final statuses = tabConfig['statuses'] as List<OrderStatus>;
      return orders.where((o) => statuses.contains(o.currentStatus)).toList();
    }

    return orders;
  }

  /// Construire la liste
  Widget _buildOrdersList(List<OrderModel> orders, String tabTitle) {
    if (orders.isEmpty) {
      return ListView(
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
      );
    }

    // Grouper par date
    final groupedOrders = _groupOrdersByDate(orders);

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _calculateTotalItems(groupedOrders),
      itemBuilder: (context, index) {
        return _buildItemAtIndex(groupedOrders, index);
      },
    );
  }

  /// Grouper par date
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

  int _calculateTotalItems(Map<String, List<OrderModel>> groupedOrders) {
    int total = 0;
    groupedOrders.forEach((dateKey, orders) {
      total++;
      total += orders.length;
    });
    return total;
  }

  Widget _buildItemAtIndex(
      Map<String, List<OrderModel>> groupedOrders, int index) {
    int currentIndex = 0;

    for (var entry in groupedOrders.entries) {
      final dateKey = entry.key;
      final orders = entry.value;

      if (currentIndex == index) {
        return _buildDateHeader(dateKey, orders.length);
      }
      currentIndex++;

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
          message += 'Consultez la console';
        } else if (vendorOrders > 0) {
          message += '✅ Commandes trouvées !';
        }

        AppUtils.showInfoDialog(context: context, message: message);
      }
    } catch (e) {
      print('❌ Erreur diagnostic: $e');
    }
  }

  /// Debug rapide
  Future<void> _quickDebug() async {
    print('\n🔍 DEBUG RAPIDE\n');

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('orders')
          .where('sellerId', isEqualTo: sellerId)
          .get();

      print('Commandes trouvées: ${snapshot.docs.length}');

      if (mounted) {
        AppUtils.showInfoDialog(
          context: context,
          message: 'SellerId: $sellerId\nCommandes: ${snapshot.docs.length}',
        );
      }
    } catch (e) {
      print('❌ Erreur: $e');
    }
  }
}
