import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/client/orders_client_bloc.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_text.dart';
import '../../colors/app_colors.dart';
import '../../../constants/routes.dart';

class OrdersClientPage extends StatefulWidget {
  const OrdersClientPage({super.key});

  @override
  State<OrdersClientPage> createState() => _OrdersClientPageState();
}

class _OrdersClientPageState extends State<OrdersClientPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this, initialIndex: 0);
    context.read<OrdersClientBloc>().add(LoadOrders());
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
        title: const AppText(text: 'Mes Commandes'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Onglets de filtrage
          _buildTabBar(),

          // Contenu des onglets
          Expanded(
            child: BlocBuilder<OrdersClientBloc, OrdersClientState>(
              builder: (context, state) {
                if (state is OrdersClientLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is OrdersClientLoaded) {
                  return TabBarView(
                    controller: _tabController,
                    children: [
                      _buildOrdersList(state.orders
                          .where((order) => order.status == 'En cours')
                          .toList()),
                      _buildOrdersList(state.orders
                          .where((order) => order.status == 'Confirmée')
                          .toList()),
                      _buildOrdersList(state.orders
                          .where((order) => order.status == 'Livrée')
                          .toList()),
                      _buildOrdersList(state.orders
                          .where((order) => order.status == 'Annulée')
                          .toList()),
                    ],
                  );
                }

                if (state is OrdersClientError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        AppText(
                          text: state.message,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(height: 16),
                        AppButton(
                          onTap: () {
                            context.read<OrdersClientBloc>().add(LoadOrders());
                          },
                          color: AppColors.primaryColor,
                          child: AppText(
                            text: 'Réessayer',
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return const Center(
                  child: AppText(text: 'Chargement...'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(25),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(25),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: AppColors.primaryColor,
        isScrollable: true,
        tabs: const [
          Tab(text: 'En cours'),
          Tab(text: 'Confirmée'),
          Tab(text: 'Livrée'),
          Tab(text: 'Annulée'),
        ],
      ),
    );
  }

  Widget _buildOrdersList(List<Order> orders) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 100,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 24),
            AppText(
              text: 'Aucune commande trouvée',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
            const SizedBox(height: 12),
            AppText(
              text: 'Commencez vos achats pour voir vos commandes ici',
              color: Colors.grey.shade500,
            ),
            const SizedBox(height: 32),
            AppButton(
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.HOME);
              },
              color: AppColors.primaryColor,
              child: AppText(
                text: 'Découvrir nos produits',
                color: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return _buildOrderCard(order);
      },
    );
  }

  Widget _buildOrderCard(Order order) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête de la commande
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        text: 'Commande #${order.id}',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      const SizedBox(height: 4),
                      AppText(
                        text: order.date,
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ],
                  ),
                ),
                _buildStatusChip(order.status),
              ],
            ),

            const SizedBox(height: 16),

            // Produits de la commande
            ...order.items.map((item) => _buildOrderItem(item)),

            const SizedBox(height: 16),

            // Informations de livraison
            _buildDeliveryInfo(order),

            const SizedBox(height: 16),

            // Résumé des coûts
            _buildCostSummary(order),

            const SizedBox(height: 16),

            // Actions
            _buildOrderActions(order),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color chipColor;
    Color textColor;

    switch (status) {
      case 'En cours':
        chipColor = AppColors.orangeColor;
        textColor = Colors.white;
        break;
      case 'Confirmée':
        chipColor = AppColors.blueColor;
        textColor = Colors.white;
        break;
      case 'Livrée':
        chipColor = AppColors.primaryColor;
        textColor = Colors.white;
        break;
      case 'Annulée':
        chipColor = AppColors.redColor;
        textColor = Colors.white;
        break;
      default:
        chipColor = Colors.grey;
        textColor = Colors.white;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: AppText(
        text: status,
        color: textColor,
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildOrderItem(OrderItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              item.product.imageUrl,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 50,
                  height: 50,
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.image, color: Colors.grey, size: 24),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: item.product.name,
                  fontWeight: FontWeight.w500,
                ),
                AppText(
                  text: 'Quantité: ${item.quantity}',
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
              ],
            ),
          ),
          AppText(
            text: '${item.totalPrice.toStringAsFixed(0)} FCFA',
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryInfo(Order order) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            text: 'Adresse de livraison',
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          const SizedBox(height: 8),
          AppText(
            text: order.deliveryAddress,
            color: Colors.grey.shade600,
            fontSize: 12,
          ),
          const SizedBox(height: 8),
          AppText(
            text: 'Livraison: ${order.deliveryMethod}',
            color: Colors.grey.shade600,
            fontSize: 12,
          ),
        ],
      ),
    );
  }

  Widget _buildCostSummary(Order order) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText(text: 'Sous-total'),
            AppText(
              text: '${order.subtotal.toStringAsFixed(0)} FCFA',
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText(text: 'Livraison'),
            AppText(
              text: '${order.shippingCost.toStringAsFixed(0)} FCFA',
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
        const Divider(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText(
              text: 'Total',
              fontWeight: FontWeight.bold,
            ),
            AppText(
              text: '${order.total.toStringAsFixed(0)} FCFA',
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
              fontSize: 16,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOrderActions(Order order) {
    return Row(
      children: [
        if (order.status == 'En cours') ...[
          Expanded(
            child: AppButton(
              onTap: () {
                _showCancelOrderDialog(order);
              },
              color: AppColors.redColor,
              height: 40,
              child: AppText(
                text: 'Annuler',
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],
        Expanded(
          child: AppButton(
            onTap: () {
                              Navigator.pushNamed(context, AppRoutes.ORDERDETAILS, arguments: order);
            },
            color: AppColors.primaryColor,
            height: 40,
            child: AppText(
              text: 'Voir les détails',
              color: Colors.white,
            ),
          ),
        ),
        if (order.status == 'Livrée') ...[
          const SizedBox(width: 12),
          Expanded(
            child: AppButton(
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.REVIEW, arguments: order);
              },
              color: AppColors.secondaryColor,
              height: 40,
              child: AppText(
                text: 'Laisser un avis',
                color: Colors.white,
              ),
            ),
          ),
        ],
      ],
    );
  }

  void _showCancelOrderDialog(Order order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const AppText(text: 'Annuler la commande'),
        content: AppText(
          text: 'Êtes-vous sûr de vouloir annuler la commande #${order.id} ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: AppText(text: 'Non'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<OrdersClientBloc>().add(
                    CancelOrder(orderId: order.id),
                  );
            },
            child: AppText(
              text: 'Oui, annuler',
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
