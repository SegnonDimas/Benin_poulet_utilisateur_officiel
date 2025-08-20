import 'package:benin_poulet/views/colors/app_colors.dart';
import 'package:benin_poulet/views/sizes/app_sizes.dart';
import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:benin_poulet/widgets/app_text.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models_ui/model_commande.dart';
import '../../../bloc/order/order_bloc.dart';
import '../../../models/order.dart';

class VCommandeListPage extends StatefulWidget {
  const VCommandeListPage({super.key});

  @override
  State<VCommandeListPage> createState() => _VCommandeListPageState();
}

class _VCommandeListPageState extends State<VCommandeListPage> {
  final List<String> _statut = [
    'Toutes',
    'pending',
    'active',
    'cancelled',
    'completed',
  ];

  String _statutSelected = 'Toutes';

  @override
  void initState() {
    super.initState();
    // Charger les commandes du vendeur connecté
    context.read<OrderBloc>().add(LoadVendorOrders());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText(text: 'Commandes'),
        centerTitle: true,
      ),
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          if (state is OrderLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is OrderError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  AppText(
                    text: 'Erreur',
                    fontSize: largeText(),
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 8),
                  AppText(
                    text: state.message,
                    fontSize: mediumText(),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<OrderBloc>().add(LoadVendorOrders());
                    },
                    child: AppText(text: 'Réessayer'),
                  ),
                ],
              ),
            );
          }

          if (state is OrdersLoaded) {
            final orders = state.orders;
            final filteredOrders = _statutSelected == 'Toutes' 
                ? orders 
                : orders.where((order) => order.status == _statutSelected).toList();

            return SingleChildScrollView(
              child: SizedBox(
                height: appHeightSize(context),
                child: Column(
                  children: [
                    /// nombre de commandes + choix de commandes à afficher
                    SizedBox(
                      height: appHeightSize(context) * 0.06,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: AppText(text: '${filteredOrders.length} commandes'),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Container(
                              alignment: Alignment.center,
                              height: appHeightSize(context) * 0.05,
                              width: appWidthSize(context) * 0.35,
                              decoration: BoxDecoration(
                                color: _getStatusColor(_statutSelected),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: DropdownButton<String>(
                                underline: Container(),
                                hint: AppText(
                                  text: _getStatusDisplayName(_statutSelected),
                                  color: Colors.white,
                                ),
                                value: _statutSelected,
                                items: _statut.map((String statut) {
                                  return DropdownMenuItem<String>(
                                    value: statut,
                                    child: AppText(
                                      text: _getStatusDisplayName(statut),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _statutSelected = newValue!;
                                  });
                                  // Recharger les commandes avec le nouveau filtre
                                  if (newValue == 'Toutes') {
                                    context.read<OrderBloc>().add(LoadVendorOrders());
                                  } else {
                                    context.read<OrderBloc>().add(LoadVendorOrders(status: newValue));
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    //espace
                    SizedBox(
                      height: appHeightSize(context) * 0.01,
                    ),

                    /// liste des commandes
                    Expanded(
                      child: filteredOrders.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.shopping_cart_outlined,
                                    size: 64,
                                    color: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.5),
                                  ),
                                  const SizedBox(height: 16),
                                  AppText(
                                    text: 'Aucune commande trouvée',
                                    fontSize: mediumText(),
                                    color: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.7),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              itemCount: filteredOrders.length,
                              itemBuilder: (context, index) {
                                final order = filteredOrders[index];
                                return _buildOrderCard(order);
                              },
                            ),
                    ),
                  ],
                ),
              ),
            );
          }

          return const Center(
            child: AppText(text: 'Aucune donnée disponible'),
          );
        },
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: Theme.of(context).colorScheme.background,
        onTap: (index) {
          // Navigation entre les différents statuts
          String status = 'Toutes';
          switch (index) {
            case 0: // Nouvelles
              status = 'pending';
              break;
            case 1: // En cours
              status = 'active';
              break;
            case 2: // Prêtes
              status = 'completed';
              break;
            case 3: // Historique
              status = 'Toutes';
              break;
          }
          
          setState(() {
            _statutSelected = status;
          });
          
          if (status == 'Toutes') {
            context.read<OrderBloc>().add(LoadVendorOrders());
          } else {
            context.read<OrderBloc>().add(LoadVendorOrders(status: status));
          }
        },
        items: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.notifications_active_outlined),
              AppText(
                text: 'Nouvelles',
                fontSize: smallText() * 0.8,
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.hourglass_top_rounded),
              AppText(
                text: 'En cours',
                fontSize: smallText() * 0.8,
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shopping_cart_checkout_outlined),
              AppText(
                text: 'Prêtes',
                fontSize: smallText() * 0.8,
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.history_edu_outlined),
              AppText(
                text: 'Historique',
                fontSize: smallText() * 0.8,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildOrderCard(Order order) {
    return Padding(
      padding: EdgeInsets.only(
        top: appHeightSize(context) * 0.005,
        bottom: appHeightSize(context) * 0.01,
        left: appWidthSize(context) * 0.02,
        right: appWidthSize(context) * 0.02,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Theme.of(context).colorScheme.background,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.background.withOpacity(0.9),
              blurRadius: 3,
              offset: const Offset(3, 4),
              blurStyle: BlurStyle.inner,
            ),
            BoxShadow(
              color: Theme.of(context).colorScheme.background.withOpacity(0.9),
              blurRadius: 1,
              blurStyle: BlurStyle.inner,
              spreadRadius: 0,
            )
          ],
        ),
        padding: EdgeInsets.only(
          top: appHeightSize(context) * 0.01,
          bottom: appHeightSize(context) * 0.01,
          left: appWidthSize(context) * 0.04,
          right: appWidthSize(context) * 0.02,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: order.customerName,
                    color: primaryColor,
                  ),
                  SizedBox(
                    child: Row(
                      children: [
                        AppText(text: '${order.totalAmount.toStringAsFixed(0)}F'),
                        const SizedBox(width: 10),
                        AppText(
                          text: '#${order.orderId.substring(0, 8)}',
                          fontSize: smallText(),
                          color: Theme.of(context)
                              .colorScheme
                              .inversePrimary
                              .withOpacity(0.5),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    child: Row(
                      children: [
                        AppText(
                          text: order.deliveryAddress,
                          fontSize: smallText() * 1.1,
                          color: Theme.of(context)
                              .colorScheme
                              .inversePrimary
                              .withOpacity(0.5),
                        ),
                        const SizedBox(width: 10),
                        AppText(
                          text: _formatDate(order.orderDate),
                          color: primaryColor,
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(order.status),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: AppText(
                      text: _getStatusDisplayName(order.status),
                      fontSize: smallText(),
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            // Boutons d'action
            Column(
              children: [
                IconButton(
                  onPressed: () {
                    _showOrderDetails(order);
                  },
                  icon: Icon(
                    Icons.info_outline,
                    color: primaryColor,
                  ),
                ),
                if (order.status == 'pending')
                  IconButton(
                    onPressed: () {
                      _updateOrderStatus(order.orderId, 'active');
                    },
                    icon: Icon(
                      Icons.check_circle_outline,
                      color: Colors.green,
                    ),
                  ),
                if (order.status == 'active')
                  IconButton(
                    onPressed: () {
                      _updateOrderStatus(order.orderId, 'completed');
                    },
                    icon: Icon(
                      Icons.done_all,
                      color: Colors.blue,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.amber;
      case 'active':
        return primaryColor;
      case 'cancelled':
        return Colors.redAccent;
      case 'completed':
        return Colors.green;
      default:
        return primaryColor;
    }
  }

  String _getStatusDisplayName(String status) {
    switch (status) {
      case 'Toutes':
        return 'Toutes';
      case 'pending':
        return 'En attente';
      case 'active':
        return 'Actifs';
      case 'cancelled':
        return 'Annulées';
      case 'completed':
        return 'Terminées';
      default:
        return status;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}j';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}min';
    } else {
      return 'À l\'instant';
    }
  }

  void _updateOrderStatus(String orderId, String status) {
    context.read<OrderBloc>().add(UpdateOrderStatus(orderId, status));
  }

  void _showOrderDetails(Order order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: AppText(text: 'Détails de la commande'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(text: 'Client: ${order.customerName}'),
            AppText(text: 'Adresse: ${order.deliveryAddress}'),
            AppText(text: 'Montant: ${order.totalAmount.toStringAsFixed(0)}F'),
            AppText(text: 'Statut: ${_getStatusDisplayName(order.status)}'),
            AppText(text: 'Date: ${order.orderDate.toString().substring(0, 16)}'),
            const SizedBox(height: 16),
            AppText(text: 'Produits:', fontWeight: FontWeight.bold),
            ...order.items.map((item) => AppText(
              text: '• ${item.productName} x${item.quantity} - ${item.totalPrice.toStringAsFixed(0)}F',
            )),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: AppText(text: 'Fermer'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
