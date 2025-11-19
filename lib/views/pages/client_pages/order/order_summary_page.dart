import 'package:lanhi/bloc/orders/order_bloc.dart';
import 'package:lanhi/bloc/orders/order_event.dart';
import 'package:lanhi/bloc/orders/order_state.dart';
import 'package:lanhi/constants/routes.dart';
import 'package:lanhi/models/order_model.dart';
import 'package:lanhi/models/order_status.dart';
import 'package:lanhi/services/user_data_service.dart';
import 'package:lanhi/utils/app_utils.dart';
import 'package:lanhi/views/colors/app_colors.dart';
import 'package:lanhi/views/sizes/text_sizes.dart';
import 'package:lanhi/widgets/app_button.dart';
import 'package:lanhi/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

/// Page récapitulatif de la commande avant validation
class OrderSummaryPage extends StatefulWidget {
  final List<OrderItem> items;
  final double totalAmount;
  final Map<String, dynamic> deliveryInfo;
  final Map<String, dynamic> paymentInfo;
  final String sellerId; // ID du vendeur propriétaire
  final String storeId; // ID de la boutique
  final String sellerName;

  const OrderSummaryPage({
    super.key,
    required this.items,
    required this.totalAmount,
    required this.deliveryInfo,
    required this.paymentInfo,
    required this.sellerId,
    required this.storeId,
    required this.sellerName,
  });

  @override
  State<OrderSummaryPage> createState() => _OrderSummaryPageState();
}

class _OrderSummaryPageState extends State<OrderSummaryPage> {
  final UserDataService _userDataService = UserDataService();
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final deliveryFee = widget.deliveryInfo['deliveryFee'] ?? 0.0;
    final grandTotal = widget.totalAmount + deliveryFee;

    return Scaffold(
      appBar: AppBar(
        title: AppText(
          text: 'Récapitulatif de commande',
          fontSize: mediumText(),
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
      ),
      body: BlocListener<OrderBloc, OrderState>(
        listener: (context, state) {
          if (state is OrderCreated) {
            setState(() => _isProcessing = false);
            // Naviguer vers la page de confirmation
            Navigator.pushReplacementNamed(
              context,
              AppRoutes.ORDER_CONFIRMATION,
              arguments: state.orderId,
            );
          } else if (state is OrderError) {
            setState(() => _isProcessing = false);
            AppUtils.showErrorNotification(context, state.message, null);
          }
        },
        child: _isProcessing
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    AppText(text: 'Création de votre commande...'),
                  ],
                ),
              )
            : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Articles
                  _buildSection(
                    'Articles commandés',
                    Column(
                      children: widget.items
                          .map((item) => _buildItemCard(item))
                          .toList(),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Livraison
                  _buildSection(
                    'Informations de livraison',
                    _buildDeliveryInfo(),
                  ),

                  const SizedBox(height: 20),

                  // Paiement
                  _buildSection(
                    'Mode de paiement',
                    _buildPaymentInfo(),
                  ),

                  const SizedBox(height: 20),

                  // Total
                  _buildTotalSection(deliveryFee, grandTotal),

                  const SizedBox(height: 100),
                ],
              ),
      ),
      bottomNavigationBar: _isProcessing
          ? null
          : Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: AppButton(
                  height: context.height * 0.06,
                  onTap: _handleConfirmOrder,
                  color: AppColors.primaryColor,
                  child: AppText(
                    text: 'Confirmer la commande',
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: mediumText(),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildSection(String title, Widget content) {
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
            text: title,
            fontSize: mediumText(),
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 12),
          content,
        ],
      ),
    );
  }

  Widget _buildItemCard(OrderItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.inverseSurface.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          if (item.productImage != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                item.productImage!,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 50,
                  height: 50,
                  color: Theme.of(context)
                      .colorScheme
                      .inverseSurface
                      .withOpacity(0.08),
                  child: Icon(Icons.image_not_supported,
                      color: Theme.of(context)
                          .colorScheme
                          .inverseSurface
                          .withOpacity(0.7)),
                ),
              ),
            )
          else
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .inverseSurface
                    .withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.shopping_bag,
                  color: Theme.of(context)
                      .colorScheme
                      .inverseSurface
                      .withOpacity(0.7)),
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
                      'Qté: ${item.quantity} × ${NumberFormat.currency(locale: 'fr_FR', symbol: 'F', decimalDigits: 0).format(item.unitPrice)}',
                  fontSize: context.smallText,
                  color: Theme.of(context)
                      .colorScheme
                      .inverseSurface
                      .withOpacity(0.7),
                ),
              ],
            ),
          ),
          AppText(
            text: NumberFormat.currency(
                    locale: 'fr_FR', symbol: 'F', decimalDigits: 0)
                .format(item.totalPrice),
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryInfo() {
    final mode = widget.deliveryInfo['deliveryMode'];
    String modeLabel;
    switch (mode) {
      case 'standard':
        modeLabel = 'Livraison standard (2-3 jours)';
        break;
      case 'express':
        modeLabel = 'Livraison express (24h)';
        break;
      case 'pickup':
        modeLabel = 'Retrait en boutique';
        break;
      default:
        modeLabel = 'Livraison';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.local_shipping, size: 18, color: AppColors.primaryColor),
            const SizedBox(width: 8),
            AppText(
              text: modeLabel,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
        if (mode != 'pickup') ...[
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.location_on,
                  size: 18,
                  color: Theme.of(context)
                      .colorScheme
                      .inverseSurface
                      .withOpacity(0.3)),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      text: widget.deliveryInfo['address'] ?? '',
                      fontSize: context.smallText,
                    ),
                    if (widget.deliveryInfo['city'] != null)
                      AppText(
                        text:
                            '${widget.deliveryInfo['city']}, ${widget.deliveryInfo['country'] ?? 'Bénin'}',
                        fontSize: context.smallText,
                        color: Theme.of(context)
                            .colorScheme
                            .inverseSurface
                            .withOpacity(0.7),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildPaymentInfo() {
    String methodLabel;
    IconData methodIcon;
    Color methodColor;

    switch (widget.paymentInfo['method']) {
      case 'cash':
        methodLabel = 'Paiement à la livraison';
        methodIcon = Icons.payments;
        methodColor = Colors.green;
        break;
      case 'mobile_money':
        methodLabel = 'Mobile Money';
        methodIcon = Icons.phone_android;
        methodColor = Colors.orange;
        break;
      case 'card':
        methodLabel = 'Carte bancaire';
        methodIcon = Icons.credit_card;
        methodColor = Colors.blue;
        break;
      case 'bank_transfer':
        methodLabel = 'Virement bancaire';
        methodIcon = Icons.account_balance;
        methodColor = Colors.purple;
        break;
      default:
        methodLabel = 'Non spécifié';
        methodIcon = Icons.payment;
        methodColor =
            Theme.of(context).colorScheme.inverseSurface.withOpacity(0.7);
    }

    return Row(
      children: [
        Icon(methodIcon, size: 18, color: methodColor),
        const SizedBox(width: 8),
        AppText(
          text: methodLabel,
          fontWeight: FontWeight.w600,
        ),
      ],
    );
  }

  Widget _buildTotalSection(double deliveryFee, double grandTotal) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryColor,
            AppColors.primaryColor.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildTotalRow(
            'Sous-total',
            widget.totalAmount,
            isWhite: true,
            isSmall: true,
          ),
          const SizedBox(height: 8),
          _buildTotalRow(
            'Frais de livraison',
            deliveryFee,
            isWhite: true,
            isSmall: true,
          ),
          const Divider(color: Colors.white54, height: 20),
          _buildTotalRow(
            'Total à payer',
            grandTotal,
            isWhite: true,
            isBold: true,
          ),
        ],
      ),
    );
  }

  Widget _buildTotalRow(
    String label,
    double amount, {
    bool isWhite = false,
    bool isSmall = false,
    bool isBold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText(
          text: label,
          fontSize: isSmall ? context.smallText : mediumText(),
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          color: isWhite ? Colors.white : null,
        ),
        AppText(
          text: NumberFormat.currency(
            locale: 'fr_FR',
            symbol: 'F',
            decimalDigits: 0,
          ).format(amount),
          fontSize: isSmall ? context.smallText : mediumText(),
          fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
          color: isWhite ? Colors.white : AppColors.primaryColor,
        ),
      ],
    );
  }

  Future<void> _handleConfirmOrder() async {
    setState(() => _isProcessing = true);

    try {
      final user = await _userDataService.getCurrentUser();

      if (user == null) {
        AppUtils.showErrorNotification(
          context,
          'Impossible de récupérer vos informations',
          null,
        );
        setState(() => _isProcessing = false);
        return;
      }

      // Créer l'objet commande
      print('📦 Création commande:');
      print('   - sellerId: ${widget.sellerId}');
      print('   - storeId: ${widget.storeId}');
      print('   - clientId: ${user.userId}');

      final order = OrderModel(
        orderId: '',
        // Sera généré par Firestore
        clientId: user.userId,
        clientName: user.fullName ?? 'Client',
        clientPhone: user.authIdentifier ?? '',
        sellerId: widget.sellerId,
        // ID du vendeur propriétaire
        sellerName: widget.sellerName,
        storeId: widget.storeId,
        // ID de la boutique
        items: widget.items,
        totalAmount: widget.totalAmount,
        deliveryFee: widget.deliveryInfo['deliveryFee'] ?? 0.0,
        deliveryInfo: DeliveryInfo(
          address: widget.deliveryInfo['address'] ?? '',
          city: widget.deliveryInfo['city'],
          receiverNum: widget.deliveryInfo['receiverNum'],
          country: widget.deliveryInfo['country'],
          additionalInfo: widget.deliveryInfo['additionalInfo'],
          deliveryMode: widget.deliveryInfo['deliveryMode'] ?? 'standard',
        ),
        paymentInfo: PaymentInfo(
          method: widget.paymentInfo['method'] ?? 'cash',
          status: 'pending',
        ),
        currentStatus: OrderStatus.pendingValidation,
        statusHistory: [
          StatusHistory(
            status: OrderStatus.pendingValidation,
            timestamp: DateTime.now(),
            comment: 'Commande créée',
            updatedBy: user.userId,
          ),
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Créer la commande via le BLoC
      context.read<OrderBloc>().add(CreateOrderEvent(order));
    } catch (e) {
      setState(() => _isProcessing = false);
      AppUtils.showErrorNotification(
        context,
        'Erreur lors de la création de la commande',
        null,
      );
    }
  }
}
