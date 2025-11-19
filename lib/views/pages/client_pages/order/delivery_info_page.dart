import 'package:lanhi/views/colors/app_colors.dart';
import 'package:lanhi/views/sizes/text_sizes.dart';
import 'package:lanhi/widgets/app_button.dart';
import 'package:lanhi/widgets/app_text.dart';
import 'package:lanhi/widgets/app_textField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

/// Page de saisie des informations de livraison
class DeliveryInfoPage extends StatefulWidget {
  final Map<String, dynamic>? existingInfo;

  const DeliveryInfoPage({super.key, this.existingInfo});

  @override
  State<DeliveryInfoPage> createState() => _DeliveryInfoPageState();
}

class _DeliveryInfoPageState extends State<DeliveryInfoPage> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _receiverNumController = TextEditingController();
  final _additionalInfoController = TextEditingController();

  String _selectedDeliveryMode = 'standard';
  double _deliveryFee = 500.0;

  @override
  void initState() {
    super.initState();
    if (widget.existingInfo != null) {
      _addressController.text = widget.existingInfo!['address'] ?? '';
      _cityController.text = widget.existingInfo!['city'] ?? '';
      _receiverNumController.text = widget.existingInfo!['receiverNum'] ?? '';
      _additionalInfoController.text =
          widget.existingInfo!['additionalInfo'] ?? '';
      _selectedDeliveryMode =
          widget.existingInfo!['deliveryMode'] ?? 'standard';
    }
    _updateDeliveryFee();
  }

  void _updateDeliveryFee() {
    setState(() {
      switch (_selectedDeliveryMode) {
        case 'standard':
          _deliveryFee = 500.0;
          break;
        case 'express':
          _deliveryFee = 1000.0;
          break;
        case 'pickup':
          _deliveryFee = 0.0;
          break;
      }
    });
  }

  @override
  void dispose() {
    _addressController.dispose();
    _cityController.dispose();
    _receiverNumController.dispose();
    _additionalInfoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText(
          text: 'Informations de livraison',
          fontSize: mediumText(),
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Mode de livraison
            AppText(
              text: 'Mode de livraison',
              fontSize: mediumText(),
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 12),

            _buildDeliveryModeCard(
              'standard',
              'Livraison standard',
              '2-3 jours',
              Icons.local_shipping,
              500.0,
            ),
            const SizedBox(height: 10),

            _buildDeliveryModeCard(
              'express',
              'Livraison express',
              '24h',
              Icons.rocket_launch,
              1000.0,
            ),
            const SizedBox(height: 10),

            _buildDeliveryModeCard(
              'pickup',
              'Retrait en boutique',
              'Gratuit',
              Icons.store,
              0.0,
            ),

            const SizedBox(height: 24),

            // Adresse de livraison
            if (_selectedDeliveryMode != 'pickup') ...[
              AppText(
                text: 'Adresse de livraison',
                fontSize: mediumText(),
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: _addressController,
                label: 'Adresse complète',
                labelStyle: TextStyle(fontSize: context.smallText),
                //label: null,
                prefixIcon: Icons.home_work_outlined,
                maxLines: 2,
                validator: (value) {
                  if (_selectedDeliveryMode != 'pickup' &&
                      (value == null || value.isEmpty)) {
                    return 'Veuillez entrer une adresse';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      controller: _cityController,
                      label: 'Ville',
                      labelStyle: TextStyle(fontSize: context.smallText),
                      prefixIcon: Icons.location_city,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: AppTextField(
                      controller: _receiverNumController,
                      //hintText: 'Numéro destinataire',
                      label: 'Tél. destinataire',
                      labelStyle: TextStyle(fontSize: context.smallText),
                      prefixIcon: Icons.phone,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (_selectedDeliveryMode != 'pickup' &&
                            (value == null || value.isEmpty)) {
                          return 'Requis';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: _additionalInfoController,
                label: 'Informations complémentaires',
                //labelStyle: TextStyle(fontSize: context.smallText),
                prefixIcon: Icons.info_outline,
                maxLines: 4,
              ),
            ],

            const SizedBox(height: 30),
          ],
        ),
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

  Widget _buildDeliveryModeCard(
    String mode,
    String title,
    String subtitle,
    IconData icon,
    double fee,
  ) {
    final isSelected = _selectedDeliveryMode == mode;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedDeliveryMode = mode;
          _updateDeliveryFee();
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryColor.withOpacity(0.1)
              : Theme.of(context).colorScheme.inverseSurface.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryColor
                : Theme.of(context).colorScheme.inverseSurface.withOpacity(0.2),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryColor
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
                  AppText(
                    text: title,
                    fontWeight: FontWeight.bold,
                  ),
                  AppText(
                    text: subtitle,
                    fontSize: context.smallText,
                    color: Theme.of(context)
                        .colorScheme
                        .inverseSurface
                        .withOpacity(0.5),
                  ),
                ],
              ),
            ),
            AppText(
              text: fee > 0
                  ? '${NumberFormat.currency(locale: 'fr_FR', symbol: 'F', decimalDigits: 0).format(fee)}'
                  : 'Gratuit',
              fontWeight: FontWeight.bold,
              color: isSelected ? AppColors.primaryColor : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  void _handleContinue() {
    if (_formKey.currentState!.validate()) {
      // Retourner les données à la page précédente
      Navigator.pop(context, {
        'address': _addressController.text,
        'city': _cityController.text,
        'receiverNum': _receiverNumController.text,
        'country': 'Bénin',
        'additionalInfo': _additionalInfoController.text,
        'deliveryMode': _selectedDeliveryMode,
        'deliveryFee': _deliveryFee,
      });
    }
  }
}
