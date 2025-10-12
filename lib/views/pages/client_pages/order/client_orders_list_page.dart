import 'package:benin_poulet/constants/routes.dart';
import 'package:benin_poulet/models/order_model.dart';
import 'package:benin_poulet/models/order_status.dart';
import 'package:benin_poulet/services/user_data_service.dart';
import 'package:benin_poulet/utils/app_utils.dart';
import 'package:benin_poulet/views/colors/app_colors.dart';
import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:benin_poulet/widgets/app_button.dart';
import 'package:benin_poulet/widgets/app_text.dart';
import 'package:benin_poulet/widgets/order_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Page listant toutes les commandes d'un client (Version StreamBuilder direct)
class ClientOrdersListPage extends StatefulWidget {
  const ClientOrdersListPage({super.key});

  @override
  State<ClientOrdersListPage> createState() => _ClientOrdersListPageState();
}

class _ClientOrdersListPageState extends State<ClientOrdersListPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? clientId;
  final UserDataService _userDataService = UserDataService();

  final List<Map<String, dynamic>> _tabs = [
    {
      'title': 'Toutes',
      'icon': Icons.all_inclusive,
    },
    {
      'title': 'En cours',
      'icon': Icons.pending_actions,
      'statuses': [
        OrderStatus.pendingValidation,
        OrderStatus.validated,
        OrderStatus.inPreparation,
        OrderStatus.readyForDelivery,
        OrderStatus.inDelivery,
        OrderStatus.delivered,
      ],
    },
    {
      'title': 'Terminées',
      'icon': Icons.check_circle,
      'statuses': [OrderStatus.completed],
    },
    {
      'title': 'Annulées',
      'icon': Icons.cancel,
      'statuses': [OrderStatus.rejected, OrderStatus.cancelled],
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _loadClientId();
  }

  Future<void> _loadClientId() async {
    print('═══════════════════════════════════════');
    print('🔄 CLIENT ORDERS: Démarrage du chargement');
    print('═══════════════════════════════════════');

    final user = await _userDataService.getCurrentUser();
    print('👤 User récupéré: ${user?.userId ?? "NULL"}');
    print('👤 User fullName: ${user?.fullName ?? "NULL"}');

    if (user != null && mounted) {
      setState(() {
        clientId = user.userId;
      });
      print('✅ ClientId défini dans le state: $clientId');
      print('✅ Widget monté: $mounted');
      print('🎯 Prêt à charger les commandes depuis Firestore');
    } else {
      print(
          '❌ PROBLÈME: user=${user != null ? "OK" : "NULL"}, mounted=$mounted');
    }

    print('═══════════════════════════════════════\n');
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
          // Bouton de debug
          IconButton(
            icon: const Icon(Icons.bug_report),
            onPressed: () => _debugFirestore(),
          ),
        ],
        bottom: TabBar(
          padding: EdgeInsets.zero,
          controller: _tabController,
          tabAlignment: TabAlignment.start,
          dividerColor:
              Theme.of(context).colorScheme.inverseSurface.withOpacity(0.06),
          indicatorSize: TabBarIndicatorSize.tab,
          unselectedLabelColor:
              Theme.of(context).colorScheme.inverseSurface.withOpacity(0.3),
          isScrollable: true,
          indicatorColor: AppColors.primaryColor,
          labelColor: AppColors.primaryColor,
          tabs: _tabs.map((tab) {
            return Tab(
              icon: Icon(tab['icon'] as IconData),
              text: tab['title'] as String,
            );
          }).toList(),
        ),
      ),
      body: clientId == null
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  AppText(text: 'Chargement de votre profil...'),
                ],
              ),
            )
          : TabBarView(
              controller: _tabController,
              children: _tabs.map((tab) {
                final statuses = tab['statuses'] as List<OrderStatus>?;
                return _buildOrdersTab(statuses);
              }).toList(),
            ),
    );
  }

  /// Construit un onglet avec StreamBuilder direct
  Widget _buildOrdersTab(List<OrderStatus>? filterStatuses) {
    print('🎨 Construction de l\'onglet pour clientId: $clientId');

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('orders')
          .where('clientId', isEqualTo: clientId)
          .snapshots(),
      builder: (context, snapshot) {
        print('───────────────────────────────────');
        print(
            '📡 StreamBuilder: État de connexion: ${snapshot.connectionState}');

        // Gestion de l'état de connexion
        if (snapshot.connectionState == ConnectionState.waiting) {
          print('⏳ StreamBuilder: En attente de la première donnée...');
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
          print('❌ StreamBuilder: ERREUR: ${snapshot.error}');
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  AppText(
                    text: 'Erreur lors du chargement',
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
        if (!snapshot.hasData || snapshot.data == null) {
          print(
              '⚠️ StreamBuilder: Pas de données (hasData=${snapshot.hasData})');
          return const Center(
            child: AppText(text: 'Aucune donnée disponible'),
          );
        }

        // Récupérer les documents
        final docs = snapshot.data!.docs;
        print('📊 StreamBuilder: ${docs.length} documents reçus de Firestore');

        // Parser les commandes
        final allOrders = <OrderModel>[];
        for (var doc in docs) {
          try {
            final order = OrderModel.fromFirestore(doc);
            allOrders.add(order);
            print(
                '  ✅ Commande ${doc.id} parsée: ${order.currentStatus.label}');
          } catch (e) {
            print('  ❌ Erreur parsing ${doc.id}: $e');
          }
        }

        print('✅ Total commandes parsées: ${allOrders.length}');

        // Filtrer selon l'onglet
        final filteredOrders = filterStatuses == null
            ? allOrders
            : allOrders
                .where((order) => filterStatuses.contains(order.currentStatus))
                .toList();

        print(
            '🎯 Commandes filtrées pour cet onglet: ${filteredOrders.length}');
        print('───────────────────────────────────\n');

        // Afficher la liste
        return _buildOrdersList(filteredOrders);
      },
    );
  }

  /// Construire la liste des commandes
  Widget _buildOrdersList(List<OrderModel> orders) {
    if (orders.isEmpty) {
      return RefreshIndicator(
        onRefresh: () async {
          setState(() {}); // Force rebuild du stream
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
                    text: 'Vos commandes apparaîtront ici',
                    fontSize: smallText(),
                    color: Colors.grey.shade600,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        AppText(
                          text: 'Info Debug',
                          fontSize: smallText(),
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                        AppText(
                          text: 'ClientId: ${clientId ?? "non défini"}',
                          fontSize: smallText() * 0.9,
                          color: Colors.grey.shade600,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // Trier par date (plus récent en premier)
    orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));

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
        // Cette semaine
        dateKey = _getWeekdayName(orderDate);
      } else {
        // Date complète pour les commandes plus anciennes
        dateKey = DateFormat('dd MMMM yyyy', 'fr_FR').format(orderDate);
      }

      if (!grouped.containsKey(dateKey)) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(order);
    }

    return grouped;
  }

  /// Calculer le nombre total d'items (headers + commandes)
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
              showSeller: true,
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.ORDER_TRACKING,
                  arguments: order.orderId,
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
              color:
                  Theme.of(context).colorScheme.inverseSurface.withOpacity(0.2),
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
              color:
                  Theme.of(context).colorScheme.inverseSurface.withOpacity(0.2),
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

  /// Debug Firestore - Afficher toutes les commandes
  Future<void> _debugFirestore() async {
    print('\n═══════════════════════════════════════');
    print('🧪 DEBUG FIRESTORE - ANALYSE COMPLÈTE');
    print('═══════════════════════════════════════');

    try {
      // Test 1: Toutes les commandes
      print('\n📊 TEST 1: Récupération de TOUTES les commandes');
      final allSnapshot =
          await FirebaseFirestore.instance.collection('orders').get();

      print('✅ Total documents dans "orders": ${allSnapshot.docs.length}');

      if (allSnapshot.docs.isEmpty) {
        print('⚠️ La collection "orders" est VIDE');
      } else {
        print('\n📋 Liste de toutes les commandes:');
        for (var doc in allSnapshot.docs) {
          final data = doc.data();
          print('  📦 ${doc.id}:');
          print('     - clientId: ${data['clientId']}');
          print('     - sellerId: ${data['sellerId']}');
          print('     - status: ${data['currentStatus']}');
          print('     - total: ${data['totalAmount']}');
        }
      }

      // Test 2: Commandes de l'utilisateur actuel
      print('\n📊 TEST 2: Commandes du client actuel');
      print('ClientId recherché: $clientId');

      final userSnapshot = await FirebaseFirestore.instance
          .collection('orders')
          .where('clientId', isEqualTo: clientId)
          .get();

      print('✅ Commandes trouvées pour ce client: ${userSnapshot.docs.length}');

      if (userSnapshot.docs.isEmpty) {
        print('⚠️ Aucune commande pour clientId: $clientId');
        print(
            '💡 Vérifiez que le clientId dans Firestore correspond bien à: $clientId');
      } else {
        print('\n📋 Détails des commandes de ce client:');
        for (var doc in userSnapshot.docs) {
          final data = doc.data();
          print('  📦 ${doc.id}: ${data['currentStatus']}');
        }
      }

      // Test 3: Test de parsing
      print('\n📊 TEST 3: Test de parsing');
      for (var doc in userSnapshot.docs) {
        try {
          final order = OrderModel.fromFirestore(doc);
          print(
              '  ✅ ${doc.id} parsé: ${order.items.length} articles, ${order.grandTotal} F');
        } catch (e) {
          print('  ❌ ${doc.id} ERREUR: $e');
        }
      }

      print('\n═══════════════════════════════════════');
      print('🧪 FIN DU DEBUG');
      print('═══════════════════════════════════════\n');

      // Afficher un résumé à l'utilisateur
      if (mounted) {
        AppUtils.showInfoDialog(
          context: context,
          message: 'Debug terminé\n\n'
              'Total commandes: ${allSnapshot.docs.length}\n'
              'Vos commandes: ${userSnapshot.docs.length}\n\n'
              'Consultez la console pour plus de détails',
        );
      }
    } catch (e) {
      print('❌ Erreur lors du debug: $e');
      if (mounted) {
        AppUtils.showErrorNotification(
          context,
          'Erreur debug: $e',
          null,
        );
      }
    }
  }
}
