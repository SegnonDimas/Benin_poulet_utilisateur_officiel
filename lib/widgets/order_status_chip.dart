import 'package:flutter/material.dart';
import 'package:lanhi/models/order_status.dart';
import 'package:lanhi/widgets/app_text.dart';

/// Widget pour afficher un chip de statut de commande
class OrderStatusChip extends StatelessWidget {
  final OrderStatus status;
  final double fontSize;

  const OrderStatusChip({
    super.key,
    required this.status,
    this.fontSize = 12,
  });

  @override
  Widget build(BuildContext context) {
    final colors = _getStatusColors(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: colors['background'],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors['border']!, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getStatusIcon(status),
            size: fontSize + 2,
            color: colors['text'],
          ),
          const SizedBox(width: 6),
          AppText(
            text: status.label,
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: colors['text'],
          ),
        ],
      ),
    );
  }

  Map<String, Color> _getStatusColors(OrderStatus status) {
    switch (status) {
      case OrderStatus.pendingValidation:
        return {
          'background': Colors.orange.shade50,
          'border': Colors.orange.shade300,
          'text': Colors.orange.shade700,
        };
      case OrderStatus.validated:
        return {
          'background': Colors.blue.shade50,
          'border': Colors.blue.shade300,
          'text': Colors.blue.shade700,
        };
      case OrderStatus.inPreparation:
        return {
          'background': Colors.purple.shade50,
          'border': Colors.purple.shade300,
          'text': Colors.purple.shade700,
        };
      case OrderStatus.readyForDelivery:
        return {
          'background': Colors.teal.shade50,
          'border': Colors.teal.shade300,
          'text': Colors.teal.shade700,
        };
      case OrderStatus.inDelivery:
        return {
          'background': Colors.indigo.shade50,
          'border': Colors.indigo.shade300,
          'text': Colors.indigo.shade700,
        };
      case OrderStatus.delivered:
        return {
          'background': Colors.lightGreen.shade50,
          'border': Colors.lightGreen.shade400,
          'text': Colors.lightGreen.shade800,
        };
      case OrderStatus.completed:
        return {
          'background': Colors.green.shade50,
          'border': Colors.green.shade400,
          'text': Colors.green.shade800,
        };
      case OrderStatus.rejected:
        return {
          'background': Colors.red.shade50,
          'border': Colors.red.shade300,
          'text': Colors.red.shade700,
        };
      case OrderStatus.cancelled:
        return {
          'background': Colors.grey.shade100,
          'border': Colors.grey.shade400,
          'text': Colors.grey.shade700,
        };
    }
  }

  IconData _getStatusIcon(OrderStatus status) {
    switch (status) {
      case OrderStatus.pendingValidation:
        return Icons.pending;
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
