import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lanhi/models/order_model.dart';
import 'package:lanhi/models/order_status.dart';
import 'package:lanhi/views/colors/app_colors.dart';
import 'package:lanhi/views/sizes/text_sizes.dart';
import 'package:lanhi/widgets/app_text.dart';
import 'package:timeline_tile/timeline_tile.dart';

/// Widget pour afficher la timeline des statuts de commande
class OrderTimeline extends StatelessWidget {
  final OrderModel order;

  const OrderTimeline({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    // Créer la liste de tous les statuts possibles
    final allStatuses = _getExpectedStatuses();

    return Column(
      children: List.generate(allStatuses.length, (index) {
        final status = allStatuses[index];
        final historyEntry = _findHistoryEntry(status);
        final isCompleted = historyEntry != null;
        final isCurrent = order.currentStatus == status;
        final isLast = index == allStatuses.length - 1;

        // Vérifier si CE statut spécifique est le statut d'annulation/rejet
        final isRejectedOrCancelled =
            status == OrderStatus.rejected || status == OrderStatus.cancelled;
        final isFinalNegativeStatus = isRejectedOrCancelled && isCompleted;

        return TimelineTile(
          alignment: TimelineAlign.manual,
          lineXY: 0.1,
          isFirst: index == 0,
          isLast: isLast,
          beforeLineStyle: LineStyle(
            color: isCompleted
                ? (isFinalNegativeStatus
                    ? AppColors.redColor
                    : AppColors.primaryColor)
                : Theme.of(context).colorScheme.inverseSurface.withOpacity(0.3),
            thickness: 3,
          ),
          afterLineStyle: LineStyle(
            color: isCompleted && !isLast && !isFinalNegativeStatus
                ? AppColors.primaryColor
                : Theme.of(context).colorScheme.inverseSurface.withOpacity(0.3),
            thickness: 3,
          ),
          indicatorStyle: IndicatorStyle(
            width: 40,
            height: 40,
            indicator: Container(
              decoration: BoxDecoration(
                color: isCompleted
                    ? (isFinalNegativeStatus
                        ? AppColors
                            .redColor // Rouge seulement si c'est le statut rejeté/annulé
                        : AppColors
                            .primaryColor) // Vert pour les autres statuts complétés
                    : (isCurrent
                        ? Colors.orange // Orange pour le statut en cours
                        : Theme.of(context)
                            .colorScheme
                            .inverseSurface
                            .withOpacity(0.3)), // Gris pour les statuts futurs
                shape: BoxShape.circle,
                border: Border.all(
                  color: isCompleted || isCurrent
                      ? Colors.white
                      : Theme.of(context)
                          .colorScheme
                          .inverseSurface
                          .withOpacity(0.4),
                  width: 3,
                ),
                boxShadow: isCompleted || isCurrent
                    ? [
                        BoxShadow(
                          color: (isCompleted
                                  ? (isFinalNegativeStatus
                                      ? AppColors.redColor
                                      : AppColors.primaryColor)
                                  : Colors.orange)
                              .withOpacity(0.3),
                          blurRadius: 8,
                          spreadRadius: 2,
                        )
                      ]
                    : [],
              ),
              child: Icon(
                _getStatusIcon(status),
                color: isCompleted || isCurrent
                    ? Colors.white
                    : Theme.of(context)
                        .colorScheme
                        .inverseSurface
                        .withOpacity(0.7),
                size: 20,
              ),
            ),
          ),
          endChild: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: status.label,
                  fontWeight: FontWeight.bold,
                  fontSize: context.mediumText * 0.85,
                  color: isCompleted || isCurrent
                      ? Theme.of(context).colorScheme.onSurface
                      : Theme.of(context)
                          .colorScheme
                          .inverseSurface
                          .withOpacity(0.7),
                ),
                if (historyEntry != null) ...[
                  const SizedBox(height: 4),
                  AppText(
                    text: DateFormat('dd/MM/yyyy à HH:mm')
                        .format(historyEntry.timestamp),
                    fontSize: context.smallText,
                    color: Theme.of(context)
                        .colorScheme
                        .inverseSurface
                        .withOpacity(0.5),
                  ),
                  if (historyEntry.comment != null) ...[
                    const SizedBox(height: 4),
                    AppText(
                      text: historyEntry.comment!,
                      fontSize: context.smallText,
                      color: Theme.of(context)
                          .colorScheme
                          .inverseSurface
                          .withOpacity(0.5),
                      overflow: TextOverflow.visible,
                      maxLines: 3,
                    ),
                  ],
                ],
                if (isCurrent && !isCompleted) ...[
                  const SizedBox(height: 4),
                  AppText(
                    text: 'En cours...',
                    fontSize: context.smallText,
                    color: Colors.orange,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ],
            ),
          ),
        );
      }),
    );
  }

  /// Obtenir les statuts attendus selon le statut actuel
  List<OrderStatus> _getExpectedStatuses() {
    // Si commande rejetée ou annulée, afficher seulement le parcours jusqu'au rejet/annulation
    if (order.currentStatus == OrderStatus.rejected) {
      return [OrderStatus.pendingValidation, OrderStatus.rejected];
    }
    if (order.currentStatus == OrderStatus.cancelled) {
      return [OrderStatus.pendingValidation, OrderStatus.cancelled];
    }

    // Sinon afficher le parcours complet
    return [
      OrderStatus.pendingValidation,
      OrderStatus.validated,
      OrderStatus.inPreparation,
      OrderStatus.readyForDelivery,
      OrderStatus.inDelivery,
      OrderStatus.delivered,
      OrderStatus.completed,
    ];
  }

  /// Trouver l'entrée d'historique correspondant au statut
  StatusHistory? _findHistoryEntry(OrderStatus status) {
    try {
      return order.statusHistory.firstWhere((h) => h.status == status);
    } catch (e) {
      return null;
    }
  }

  IconData _getStatusIcon(OrderStatus status) {
    switch (status) {
      case OrderStatus.pendingValidation:
        return Icons.schedule;
      case OrderStatus.validated:
        return Icons.check_circle;
      case OrderStatus.inPreparation:
        return Icons.kitchen;
      case OrderStatus.readyForDelivery:
        return Icons.inventory_2;
      case OrderStatus.inDelivery:
        return Icons.local_shipping;
      case OrderStatus.delivered:
        return Icons.home;
      case OrderStatus.completed:
        return Icons.verified;
      case OrderStatus.rejected:
        return Icons.cancel;
      case OrderStatus.cancelled:
        return Icons.block;
    }
  }
}
