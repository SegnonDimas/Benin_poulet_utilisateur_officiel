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
import 'package:lanhi/widgets/order_timeline.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../widgets/app_textField.dart';

/// Page de suivi de commande en temps réel - VERSION STREAMBUILDER
class OrderTrackingPage extends StatefulWidget {
  final String orderId;

  const OrderTrackingPage({super.key, required this.orderId});

  @override
  State<OrderTrackingPage> createState() => _OrderTrackingPageState();
}

class _OrderTrackingPageState extends State<OrderTrackingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText(
          text: 'Suivi de commande',
          fontSize: context.mediumText,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .doc(widget.orderId)
            .snapshots(),
        builder: (context, snapshot) {
          print('───────────────────────────────────');
          print('📡 StreamBuilder Tracking: État: ${snapshot.connectionState}');

          // Gestion de l'état de connexion
          if (snapshot.connectionState == ConnectionState.waiting) {
            print('⏳ StreamBuilder Tracking: En attente...');
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  AppText(text: 'Chargement du suivi...'),
                ],
              ),
            );
          }

          // Gestion des erreurs
          if (snapshot.hasError) {
            print('❌ StreamBuilder Tracking: ERREUR: ${snapshot.error}');
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
                      fontSize: context.mediumText,
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
                          .withOpacity(0.3),
                    ),
                    const SizedBox(height: 20),
                    AppButton(
                      height: context.height * 0.06,
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

          // Vérifier si le document existe
          if (!snapshot.hasData || !snapshot.data!.exists) {
            print('⚠️ StreamBuilder Tracking: Commande introuvable');
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off,
                      size: 64,
                      color: Theme.of(context)
                          .colorScheme
                          .inverseSurface
                          .withOpacity(0.3)),
                  const SizedBox(height: 16),
                  AppText(
                    text: 'Commande introuvable',
                    fontSize: context.mediumText,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 8),
                  AppText(
                    text: 'Cette commande n\'existe pas ou a été supprimée',
                    fontSize: smallText(),
                    textAlign: TextAlign.center,
                    color: Theme.of(context)
                        .colorScheme
                        .inverseSurface
                        .withOpacity(0.3),
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
                } else if (state is OrderError) {
                  AppUtils.showErrorNotification(context, state.message, null);
                }
              },
              child: RefreshIndicator(
                onRefresh: () async {
                  setState(() {}); // Force rebuild du stream
                },
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // En-tête avec numéro de commande
                    _buildOrderHeader(order),

                    const SizedBox(height: 20),

                    // Timeline
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                            color: Theme.of(context)
                                .colorScheme
                                .inverseSurface
                                .withOpacity(0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            text: 'État de la commande',
                            fontSize: context.mediumText,
                            fontWeight: FontWeight.bold,
                          ),
                          const SizedBox(height: 20),
                          OrderTimeline(order: order),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Détails de la commande
                    _buildOrderDetails(order),

                    const SizedBox(height: 20),

                    // Actions disponibles
                    if (order.currentStatus == OrderStatus.delivered)
                      _buildConfirmDeliveryButton(order),

                    if (order.currentStatus == OrderStatus.pendingValidation ||
                        order.currentStatus == OrderStatus.validated)
                      _buildCancelButton(order),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          } catch (e) {
            print('❌ Erreur parsing commande: $e');
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline,
                      size: 64, color: AppColors.redColor),
                  const SizedBox(height: 16),
                  AppText(
                    text: 'Erreur de format des données',
                    fontSize: context.mediumText,
                    fontWeight: FontWeight.bold,
                    color: AppColors.redColor,
                  ),
                  const SizedBox(height: 8),
                  AppText(
                    text: '$e',
                    fontSize: smallText(),
                    textAlign: TextAlign.center,
                    color: Theme.of(context)
                        .colorScheme
                        .inverseSurface
                        .withOpacity(0.3),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildOrderHeader(OrderModel order) {
    // Couleur adaptée au statut
    final statusColor = _getStatusColor(order.currentStatus);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            statusColor,
            statusColor.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          AppText(
            text: 'Commande #${widget.orderId.substring(0, 8).toUpperCase()}',
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: AppText(
              text: order.currentStatus.label,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderDetails(OrderModel order) {
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
            text: 'Détails de la commande',
            fontSize: context.mediumText,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 16),

          // Articles
          ...order.items.map((item) => _buildItemRow(item)).toList(),

          const Divider(height: 24),

          // Vendeur
          _buildInfoRow(Icons.store, 'Vendeur', order.sellerName),
          const SizedBox(height: 8),

          // Adresse
          _buildInfoRow(
            Icons.location_on,
            'Livraison',
            order.deliveryInfo.fullAddress,
          ),
          const SizedBox(height: 8),

          // Paiement
          _buildInfoRow(
            Icons.payment,
            'Paiement',
            order.paymentInfo.methodLabel,
          ),

          const Divider(height: 24),

          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                text: 'Total',
                fontSize: context.mediumText,
                fontWeight: FontWeight.bold,
              ),
              AppText(
                text: NumberFormat.currency(
                  locale: 'fr_FR',
                  symbol: 'F',
                  decimalDigits: 0,
                ).format(order.grandTotal),
                fontSize: context.mediumText,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ],
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
            width: 40,
            height: 40,
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
            child: AppText(
              text: item.productName,
              fontSize: smallText(),
            ),
          ),
          AppText(
            text: NumberFormat.currency(
              locale: 'fr_FR',
              symbol: 'F',
              decimalDigits: 0,
            ).format(item.totalPrice),
            fontSize: smallText(),
            fontWeight: FontWeight.w600,
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
                    .withOpacity(0.3),
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

  Widget _buildConfirmDeliveryButton(OrderModel order) {
    return AppButton(
      onTap: () {
        AppUtils.showDialog(
          context: context,
          title: 'Confirmer la réception',
          content: 'Avez-vous bien reçu votre commande ?',
          confirmText: 'Oui, j\'ai reçu',
          cancelText: 'Pas encore',
        ).then((confirmed) {
          if (confirmed == true) {
            print('✅ Confirmation réception: ${widget.orderId}');
            context.read<OrderBloc>().add(
                  ConfirmDeliveryEvent(orderId: widget.orderId),
                );
            AppUtils.showSuccessNotification(
              context,
              'Merci ! Votre commande est terminée.',
            );
          }
        });
      },
      color: AppColors.primaryColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle, color: Colors.white),
          const SizedBox(width: 8),
          AppText(
            text: 'Confirmer la réception',
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
    );
  }

  Widget _buildCancelButton(OrderModel order) {
    return AppButton(
      onTap: () {
        _showCancelDialog();
      },
      color: Theme.of(context).colorScheme.inverseSurface.withOpacity(0.02),
      borderColor: AppColors.redColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.cancel, color: AppColors.redColor),
          const SizedBox(width: 8),
          AppText(
            text: 'Annuler la commande',
            color: AppColors.redColor,
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
    );
  }

  void _showCancelDialog() {
    final reasonController = TextEditingController();

    AppUtils.showDialog(
      context: context,
      isContentWidget: true,
      title: 'Annuler la commande',
      titleSize: context.smallText * 1.1,
      contentWidget: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const AppText(
            text: 'Pourquoi souhaitez-vous annuler cette commande ?',
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
              border: Border.all(color: Colors.grey.shade300),
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
      onConfirm: () => Navigator.pop(context),
      onCancel: () {
        Navigator.pop(context);
        print('🔴 Annulation commande: ${widget.orderId}');
        context.read<OrderBloc>().add(
              CancelOrderEvent(
                orderId: widget.orderId,
                reason: reasonController.text.isEmpty
                    ? 'Annulée par le client'
                    : reasonController.text,
              ),
            );
        AppUtils.showSuccessNotification(
          context,
          'Commande annulée',
        );
      },
      cancelText: 'Confirmer l\'annulation',
      confirmText: 'Retour',
      confirmTextColor: AppColors.redColor,
      cancelTextColor: AppColors.primaryColor,
    );
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
