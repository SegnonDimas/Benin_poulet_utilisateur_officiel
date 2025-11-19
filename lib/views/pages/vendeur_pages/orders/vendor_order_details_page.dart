import 'package:lanhi/bloc/orders/order_bloc.dart';
import 'package:lanhi/bloc/orders/order_event.dart';
import 'package:lanhi/bloc/orders/order_state.dart';
import 'package:lanhi/models/order_model.dart';
import 'package:lanhi/models/order_status.dart';
import 'package:lanhi/utils/app_utils.dart';
import 'package:lanhi/views/colors/app_colors.dart';
import 'package:lanhi/views/sizes/text_sizes.dart';
import 'package:lanhi/widgets/app_button.dart';
import 'package:lanhi/widgets/app_text.dart';
import 'package:lanhi/widgets/app_textField.dart';
import 'package:lanhi/widgets/order_status_chip.dart';
import 'package:lanhi/widgets/order_timeline.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

/// Page de détails d'une commande (vendeur) - Version StreamBuilder
class VendorOrderDetailsPage extends StatefulWidget {
  final OrderModel order;

  const VendorOrderDetailsPage({super.key, required this.order});

  @override
  State<VendorOrderDetailsPage> createState() => _VendorOrderDetailsPageState();
}

class _VendorOrderDetailsPageState extends State<VendorOrderDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText(
          text: 'Détails commande',
          fontSize: mediumText(),
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .doc(widget.order.orderId)
            .snapshots(),
        builder: (context, snapshot) {
          print('───────────────────────────────────');
          print('📡 StreamBuilder Details: État: ${snapshot.connectionState}');

          // Gestion de l'état de connexion
          if (snapshot.connectionState == ConnectionState.waiting) {
            print('⏳ StreamBuilder Details: En attente...');
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  AppText(text: 'Chargement des détails...'),
                ],
              ),
            );
          }

          // Gestion des erreurs
          if (snapshot.hasError) {
            print('❌ StreamBuilder Details: ERREUR: ${snapshot.error}');
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline,
                        size: 64, color: AppColors.redColor),
                    const SizedBox(height: 16),
                    AppText(
                      text: 'Erreur lors du chargement',
                      fontSize: mediumText(),
                      fontWeight: FontWeight.bold,
                      color: AppColors.redColor,
                    ),
                    const SizedBox(height: 8),
                    AppText(
                      text: '${snapshot.error}',
                      fontSize: smallText(),
                      textAlign: TextAlign.center,
                      color: Theme.of(context)
                          .colorScheme
                          .inverseSurface
                          .withOpacity(0.5),
                    ),
                  ],
                ),
              ),
            );
          }

          // Vérifier si le document existe
          if (!snapshot.hasData || !snapshot.data!.exists) {
            print('⚠️ StreamBuilder Details: Document n\'existe pas');
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off,
                      size: 64,
                      color: Theme.of(context)
                          .colorScheme
                          .inverseSurface
                          .withOpacity(0.5)),
                  const SizedBox(height: 16),
                  AppText(
                    text: 'Commande introuvable',
                    fontSize: mediumText(),
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
            );
          }

          // Parser la commande
          try {
            final order = OrderModel.fromFirestore(snapshot.data!);
            print('✅ Commande parsée: ${order.currentStatus.label}');
            print('───────────────────────────────────\n');

            return BlocListener<OrderBloc, OrderState>(
              listener: (context, state) {
                if (state is OrderStatusUpdated) {
                  AppUtils.showSuccessNotification(context, state.message);
                } else if (state is OrderValidated) {
                  AppUtils.showSuccessNotification(
                    context,
                    'Commande validée avec succès',
                  );
                } else if (state is OrderRejected) {
                  AppUtils.showSuccessNotification(
                    context,
                    'Commande refusée',
                  );
                  Navigator.pop(context);
                } else if (state is OrderError) {
                  AppUtils.showErrorNotification(context, state.message, null);
                }
              },
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // En-tête avec statut
                  _buildHeader(order),

                  const SizedBox(height: 20),

                  // Informations client
                  _buildClientInfo(order),

                  const SizedBox(height: 20),

                  // Articles
                  _buildItemsSection(order),

                  const SizedBox(height: 20),

                  // Timeline
                  _buildTimelineSection(order),

                  const SizedBox(height: 20),

                  // Actions
                  _buildActions(order),

                  const SizedBox(height: 20),
                ],
              ),
            );
          } catch (e) {
            print('❌ Erreur parsing commande: $e');
            return Center(
              child: AppText(
                text: 'Erreur de format des données',
                fontSize: mediumText(),
                color: AppColors.redColor,
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildHeader(OrderModel order) {
    // Couleur adaptée au statut
    final statusColor = _getStatusColor(order.currentStatus);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [statusColor, statusColor.withOpacity(0.7), statusColor],
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          AppText(
            text: 'Commande #${order.orderId.substring(0, 8).toUpperCase()}',
            fontSize: largeText(),
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          const SizedBox(height: 8),
          AppText(
            text: DateFormat('dd MMMM yyyy à HH:mm', 'fr_FR')
                .format(order.createdAt),
            fontSize: smallText(),
            color: Colors.white70,
          ),
          const SizedBox(height: 16),
          OrderStatusChip(
            status: order.currentStatus,
            fontSize: mediumText() * 0.9,
          ),
        ],
      ),
    );
  }

  Widget _buildClientInfo(OrderModel order) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
            color:
                Theme.of(context).colorScheme.inverseSurface.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            text: 'Informations client',
            fontSize: mediumText(),
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 16),
          _buildInfoRow(Icons.person, 'Nom', order.clientName),
          const SizedBox(height: 12),
          _buildInfoRow(Icons.phone, 'Téléphone', order.clientPhone),
          const SizedBox(height: 12),
          _buildInfoRow(
            Icons.location_on,
            'Adresse',
            order.deliveryInfo.fullAddress,
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            Icons.local_shipping,
            'Mode de livraison',
            _getDeliveryModeLabel(order.deliveryInfo.deliveryMode),
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            Icons.payment,
            'Paiement',
            order.paymentInfo.methodLabel,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppColors.primaryColor),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                text: label,
                fontSize: smallText(),
                color: Theme.of(context)
                    .colorScheme
                    .inverseSurface
                    .withOpacity(0.5),
              ),
              AppText(
                text: value,
                fontSize: smallText(),
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildItemsSection(OrderModel order) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
            color:
                Theme.of(context).colorScheme.inverseSurface.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            text: 'Articles (${order.items.length})',
            fontSize: mediumText(),
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 16),

          ...order.items.map((item) => _buildItemRow(item)).toList(),

          Divider(
            height: 24,
            color:
                Theme.of(context).colorScheme.inverseSurface.withOpacity(0.3),
          ),

          // Sous-total
          _buildTotalRow('Sous-total', order.totalAmount),
          const SizedBox(height: 8),
          _buildTotalRow('Livraison', order.deliveryFee),
          Divider(
            height: 20,
            color:
                Theme.of(context).colorScheme.inverseSurface.withOpacity(0.3),
          ),
          _buildTotalRow(
            'Total',
            order.grandTotal,
            isBold: true,
            color: AppColors.primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildItemRow(OrderItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: AppText(
                text: '${item.quantity}',
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: item.productName,
                  fontWeight: FontWeight.w600,
                ),
                AppText(
                  text:
                      '${NumberFormat.currency(locale: 'fr_FR', symbol: 'F', decimalDigits: 0).format(item.unitPrice)} × ${item.quantity}',
                  fontSize: smallText(),
                  color: Theme.of(context)
                      .colorScheme
                      .inverseSurface
                      .withOpacity(0.5),
                ),
              ],
            ),
          ),
          AppText(
            text: NumberFormat.currency(
              locale: 'fr_FR',
              symbol: 'F',
              decimalDigits: 0,
            ).format(item.totalPrice),
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }

  Widget _buildTotalRow(
    String label,
    double amount, {
    bool isBold = false,
    Color? color,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText(
          text: label,
          fontSize: smallText(),
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        ),
        AppText(
          text: NumberFormat.currency(
            locale: 'fr_FR',
            symbol: 'F',
            decimalDigits: 0,
          ).format(amount),
          fontSize: smallText(),
          fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
          color: color,
        ),
      ],
    );
  }

  Widget _buildTimelineSection(OrderModel order) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
            color:
                Theme.of(context).colorScheme.inverseSurface.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            text: 'Historique',
            fontSize: mediumText(),
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 16),
          OrderTimeline(order: order),
        ],
      ),
    );
  }

  Widget _buildActions(OrderModel order) {
    final status = order.currentStatus;

    return Column(
      children: [
        // Actions selon le statut
        if (status == OrderStatus.pendingValidation) ...[
          _buildActionButton(
            'Valider la commande',
            Icons.check_circle,
            AppColors.primaryColor,
            () => _handleValidateOrder(order),
          ),
          const SizedBox(height: 12),
          _buildActionButton(
            'Refuser la commande',
            Icons.cancel,
            AppColors.redColor,
            () => _handleRejectOrder(order),
          ),
        ],

        if (status == OrderStatus.validated) ...[
          _buildActionButton(
            'Commencer la préparation',
            Icons.kitchen,
            AppColors.primaryColor,
            () => _handleStatusUpdate(order, OrderStatus.inPreparation),
          ),
        ],

        if (status == OrderStatus.inPreparation) ...[
          _buildActionButton(
            'Marquer comme prête',
            Icons.inventory_2,
            Colors.teal,
            () => _handleStatusUpdate(order, OrderStatus.readyForDelivery),
          ),
        ],

        if (status == OrderStatus.readyForDelivery) ...[
          _buildActionButton(
            'Commencer la livraison',
            Icons.local_shipping,
            Colors.indigo,
            () => _handleStatusUpdate(order, OrderStatus.inDelivery),
          ),
        ],

        if (status == OrderStatus.inDelivery) ...[
          _buildActionButton(
            'Marquer comme livrée',
            Icons.home,
            Colors.lightGreen,
            () => _handleStatusUpdate(order, OrderStatus.delivered),
          ),
        ],
      ],
    );
  }

  Widget _buildActionButton(
    String text,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return AppButton(
      onTap: onTap,
      color: color,
      width: context.width * 0.95,
      height: context.height * 0.06,
      bordeurRadius: 10,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 8),
          AppText(
            text: text,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
    );
  }

  void _handleValidateOrder(OrderModel order) {
    AppUtils.showDialog(
      context: context,
      title: 'Valider la commande',
      content: 'Confirmez-vous la validation de cette commande ?',
      confirmText: 'Valider',
      cancelText: 'Annuler',
    ).then((confirmed) {
      if (confirmed == true) {
        print('🟢 Validation commande: ${order.orderId}');
        context.read<OrderBloc>().add(
              ValidateOrderEvent(orderId: order.orderId),
            );
      }
    });
  }

  void _handleRejectOrder(OrderModel order) {
    final reasonController = TextEditingController();

    AppUtils.showDialog(
      context: context,
      isContentWidget: true,
      title: 'Refuser la commande',
      contentWidget: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const AppText(
            text: 'Veuillez indiquer la raison du refus',
            overflow: TextOverflow.visible,
            textAlign: TextAlign.center,
            fontSize: 14,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface.withOpacity(0.07),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color: Theme.of(context)
                      .colorScheme
                      .inverseSurface
                      .withOpacity(0.06)),
            ),
            child: AppTextField(
              controller: reasonController,
              //hintText: 'Raison du refus',
              expands: true,
              maxLines: 3,
              fontSize: context.smallText * 1.1,
              preficIconWidget: Icon(
                Icons.edit,
                size: 17,
              ),
              isPrefixIconWidget: true,
            ),
          ),
        ],
      ),
      confirmText: 'Annuler',
      cancelText: 'Refuser',
      confirmTextColor: AppColors.redColor,
      cancelTextColor: AppColors.primaryColor,
      onConfirm: () => Navigator.pop(context),
      onCancel: () {
        if (reasonController.text.isEmpty) {
          AppUtils.showErrorNotification(
            context,
            'Veuillez indiquer une raison',
            null,
          );
          return;
        }
        Navigator.pop(context);
        print('🔴 Rejet commande: ${order.orderId}');
        context.read<OrderBloc>().add(
              RejectOrderEvent(
                orderId: order.orderId,
                reason: reasonController.text,
              ),
            );
      },
    );
  }

  void _handleStatusUpdate(OrderModel order, OrderStatus newStatus) {
    String title;
    String message;

    switch (newStatus) {
      case OrderStatus.inPreparation:
        title = 'Commencer la préparation';
        message = 'La préparation de cette commande va commencer';
        break;
      case OrderStatus.readyForDelivery:
        title = 'Commande prête';
        message = 'Cette commande est prête pour la livraison';
        break;
      case OrderStatus.inDelivery:
        title = 'Commencer la livraison';
        message = 'La livraison va commencer';
        break;
      case OrderStatus.delivered:
        title = 'Livraison effectuée';
        message = 'Cette commande a été livrée au client';
        break;
      default:
        title = 'Mise à jour';
        message = 'Confirmer la mise à jour du statut';
    }

    AppUtils.showDialog(
      context: context,
      title: title,
      content: message,
      confirmText: 'Confirmer',
      cancelText: 'Annuler',
    ).then((confirmed) {
      if (confirmed == true) {
        print('🔄 Mise à jour statut: ${newStatus.label}');
        // Dispatcher l'événement approprié
        switch (newStatus) {
          case OrderStatus.inPreparation:
            context.read<OrderBloc>().add(
                  StartPreparationEvent(orderId: order.orderId),
                );
            break;
          case OrderStatus.readyForDelivery:
            context.read<OrderBloc>().add(
                  MarkReadyForDeliveryEvent(orderId: order.orderId),
                );
            break;
          case OrderStatus.inDelivery:
            context.read<OrderBloc>().add(
                  StartDeliveryEvent(orderId: order.orderId),
                );
            break;
          case OrderStatus.delivered:
            context.read<OrderBloc>().add(
                  MarkAsDeliveredEvent(orderId: order.orderId),
                );
            break;
          default:
            break;
        }
      }
    });
  }

  String _getDeliveryModeLabel(String mode) {
    switch (mode) {
      case 'standard':
        return 'Standard (2-3 jours)';
      case 'express':
        return 'Express (24h)';
      case 'pickup':
        return 'Retrait en boutique';
      default:
        return mode;
    }
  }

  /// Obtenir la couleur selon le statut de la commande
  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pendingValidation:
        return Colors.orange; // En attente → Orange
      case OrderStatus.validated:
        return Colors.blue; // Validée → Bleu
      case OrderStatus.inPreparation:
        return Colors.purple; // En préparation → Violet
      case OrderStatus.readyForDelivery:
        return Colors.teal; // Prête → Sarcelle
      case OrderStatus.inDelivery:
        return Colors.indigo; // En route → Indigo
      case OrderStatus.delivered:
        return Colors.lightGreen; // Livrée → Vert clair
      case OrderStatus.completed:
        return AppColors.primaryColor; // Terminée → Vert (succès)
      case OrderStatus.rejected:
        return Colors.red; // Refusée → Rouge
      case OrderStatus.cancelled:
        return Colors.red.shade700; // Annulée → Rouge foncé
      default:
        return Colors.grey; // Par défaut → Gris
    }
  }
}

