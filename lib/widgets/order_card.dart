import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lanhi/models/order_model.dart';
import 'package:lanhi/views/colors/app_colors.dart';
import 'package:lanhi/views/sizes/text_sizes.dart';
import 'package:lanhi/widgets/app_text.dart';
import 'package:lanhi/widgets/order_status_chip.dart';

/// Widget pour afficher une carte de commande
class OrderCard extends StatelessWidget {
  final OrderModel order;
  final VoidCallback? onTap;
  final bool showSeller;
  final bool showClient;

  const OrderCard({
    super.key,
    required this.order,
    this.onTap,
    this.showSeller = false,
    this.showClient = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
              color: Theme.of(context)
                  .colorScheme
                  .inverseSurface
                  .withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header avec ID et statut
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text:
                      'Commande #${order.orderId.substring(0, 8).toUpperCase()}',
                  fontWeight: FontWeight.bold,
                  fontSize: context.mediumText,
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: AppText(
                        text: DateFormat('dd/MM/yyyy à HH:mm')
                            .format(order.createdAt),
                        fontSize: context.smallText * 0.9,
                        color: Theme.of(context)
                            .colorScheme
                            .inverseSurface
                            .withOpacity(0.8),
                      ),
                    ),
                    OrderStatusChip(status: order.currentStatus),
                  ],
                ),
              ],
            ),

            Divider(
                color: Theme.of(context)
                    .colorScheme
                    .inverseSurface
                    .withOpacity(0.5),
                height: 20),

            // Informations client/vendeur
            if (showSeller) ...[
              Row(
                children: [
                  Icon(Icons.store, size: 16, color: AppColors.primaryColor),
                  const SizedBox(width: 8),
                  Expanded(
                    child: AppText(
                      text: order.sellerName,
                      fontSize: context.smallText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],

            if (showClient) ...[
              Row(
                children: [
                  Icon(Icons.person, size: 16, color: AppColors.primaryColor),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          text: order.clientName,
                          fontSize: context.smallText,
                          fontWeight: FontWeight.w600,
                        ),
                        AppText(
                          text: order.clientPhone,
                          fontSize: context.smallText * 0.9,
                          color: Theme.of(context)
                              .colorScheme
                              .inverseSurface
                              .withOpacity(0.4),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],

            // Articles
            Row(
              children: [
                Icon(Icons.shopping_bag,
                    size: 16,
                    color: Theme.of(context)
                        .colorScheme
                        .inverseSurface
                        .withOpacity(0.4)),
                const SizedBox(width: 8),
                AppText(
                  text: '${order.items.length} article(s)',
                  fontSize: context.smallText,
                  color: Theme.of(context)
                      .colorScheme
                      .inverseSurface
                      .withOpacity(0.5),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Adresse de livraison
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.location_on,
                    size: 16,
                    color: Theme.of(context)
                        .colorScheme
                        .inverseSurface
                        .withOpacity(0.4)),
                const SizedBox(width: 8),
                Expanded(
                  child: AppText(
                    text: order.deliveryInfo.fullAddress,
                    fontSize: context.smallText,
                    color: Theme.of(context)
                        .colorScheme
                        .inverseSurface
                        .withOpacity(0.5),
                    maxLine: 2,
                  ),
                ),
              ],
            ),

            Divider(
                color: Theme.of(context)
                    .colorScheme
                    .inverseSurface
                    .withOpacity(0.5),
                height: 20),

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
      ),
    );
  }
}
