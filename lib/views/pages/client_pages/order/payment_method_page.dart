import 'package:lanhi/views/colors/app_colors.dart';
import 'package:lanhi/views/sizes/text_sizes.dart';
import 'package:lanhi/widgets/app_button.dart';
import 'package:lanhi/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Page de sélection du mode de paiement
class PaymentMethodPage extends StatefulWidget {
  final String? selectedMethod;

  const PaymentMethodPage({super.key, this.selectedMethod});

  @override
  State<PaymentMethodPage> createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage> {
  String _selectedMethod = 'cash';

  @override
  void initState() {
    super.initState();
    if (widget.selectedMethod != null) {
      _selectedMethod = widget.selectedMethod!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText(
          text: 'Mode de paiement',
          fontSize: mediumText(),
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AppText(
            text: 'Choisissez votre mode de paiement',
            fontSize: mediumText(),
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 20),

          _buildPaymentMethodCard(
            method: 'cash',
            title: 'Paiement à la livraison',
            subtitle: 'Payez en espèces lors de la réception',
            icon: Icons.payments,
            color: AppColors.primaryColor,
          ),
          const SizedBox(height: 12),

          _buildPaymentMethodCard(
            method: 'mobile_money',
            title: 'Mobile Money',
            subtitle: 'MTN Money, Moov Money, etc.',
            icon: Icons.phone_android,
            color: AppColors.orangeColor,
          ),
          const SizedBox(height: 12),

          _buildPaymentMethodCard(
            method: 'card',
            title: 'Carte bancaire',
            subtitle: 'Visa, Mastercard',
            icon: Icons.credit_card,
            color: AppColors.blueColor,
            isAvailable: false,
          ),
          const SizedBox(height: 12),

          _buildPaymentMethodCard(
            method: 'bank_transfer',
            title: 'Virement bancaire',
            subtitle: 'Paiement par virement',
            icon: Icons.account_balance,
            color: Colors.purple,
            isAvailable: false,
          ),

          const SizedBox(height: 30),

          // Info sécurité
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.blueColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.blueColor),
            ),
            child: Row(
              children: [
                Icon(Icons.security, color: AppColors.blueColor),
                const SizedBox(width: 12),
                Expanded(
                  child: AppText(
                    text: 'Vos paiements sont sécurisés et protégés',
                    fontSize: context.smallText,
                    color: AppColors.blueColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
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
            onTap: _handleContinue,
            color: AppColors.primaryColor,
            child: AppText(
              text: 'Continuer',
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethodCard({
    required String method,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    bool isAvailable = true,
  }) {
    final isSelected = _selectedMethod == method && isAvailable;

    return Opacity(
      opacity: isAvailable ? 1.0 : 0.4,
      child: InkWell(
        onTap: isAvailable
            ? () {
                setState(() {
                  _selectedMethod = method;
                });
              }
            : null,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primaryColor.withOpacity(0.1)
                : Theme.of(context)
                    .colorScheme
                    .inverseSurface
                    .withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? AppColors.primaryColor
                  : Theme.of(context)
                      .colorScheme
                      .inverseSurface
                      .withOpacity(0.2),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? color
                      : Theme.of(context)
                          .colorScheme
                          .inverseSurface
                          .withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: isSelected
                      ? Colors.white
                      : Theme.of(context).colorScheme.surface.withOpacity(0.9),
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        AppText(
                          text: title,
                          fontWeight: FontWeight.bold,
                        ),
                        if (!isAvailable) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.orangeColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: AppText(
                              text: 'Bientôt',
                              fontSize: context.smallText * 0.8,
                              fontWeight: FontWeight.bold,
                              color: AppColors.orangeColor,
                            ),
                          ),
                        ],
                      ],
                    ),
                    AppText(
                        text: subtitle,
                        fontSize: context.smallText,
                        color:
                            Theme.of(context).colorScheme.onSurface.withOpacity(
                                  0.5,
                                )),
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: AppColors.primaryColor,
                  size: 24,
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleContinue() {
    Navigator.pop(context, {
      'method': _selectedMethod,
    });
  }
}
