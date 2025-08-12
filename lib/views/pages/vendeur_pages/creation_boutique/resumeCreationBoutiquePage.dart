import 'package:benin_poulet/bloc/storeCreation/store_creation_bloc.dart';
import 'package:benin_poulet/utils/app_utils.dart';
import 'package:benin_poulet/views/colors/app_colors.dart';
import 'package:benin_poulet/views/models_ui/model_secteur.dart';
import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:benin_poulet/widgets/app_phone_textField.dart';
import 'package:benin_poulet/widgets/app_text.dart';
import 'package:benin_poulet/widgets/app_textField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../../../bloc/choixCategorie/secteur_bloc.dart';
import '../../../../bloc/choixCategorie/secteur_event.dart';
import '../../../../bloc/choixCategorie/secteur_state.dart';
import '../../../../bloc/fiscalty/fiscal_bloc.dart';
import '../../../../models/fiscal_info.dart';
import '../../../models_ui/model_resumeTextFormFiel.dart';

class ResumeCreationBoutiquePage extends StatefulWidget {
  @override
  State<ResumeCreationBoutiquePage> createState() =>
      _ResumeCreationBoutiquePageState();
}

class _ResumeCreationBoutiquePageState
    extends State<ResumeCreationBoutiquePage> {
  ScrollController sectorScrollController = ScrollController();
  ScrollController subSectorScrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    final storeInfoState =
        context.watch<StoreCreationBloc>().state as StoreCreationGlobalState;
    return Scaffold(
      body: Padding(
        padding:
            const EdgeInsets.only(top: 4.0, right: 8.0, left: 8.0, bottom: 8.0),
        child: ListView(padding: EdgeInsets.zero, children: [
          /// résumé infos boutique
          Container(
            height: context.height * 0.05,
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                    flex: 7,
                    child: AppText(text: 'Informations sur votre boutique')),
                Flexible(
                  flex: 2,
                  child: GestureDetector(
                    onTap: () {
                      _showModificationBottomSheet(context, storeInfoState);
                      //bottomSheet pour modifier les informations
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.edit,
                          size: context.mediumText,
                          color: AppColors.primaryColor,
                        ),
                        AppText(
                          text: "Modifier",
                          color: AppColors.primaryColor,
                          fontSize: context.smallText * 1.1,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: context.height * 0.015,
          ),

          // Avertissement sur les champs obligatoires à renseigner
          AppUtils.showInfo(
              //color: AppColors.redColor,
              info:
                  "Vous devez obligatoirement remplir le nom de la boutique, le secteur d'activité et la localisation avant qu'elle ne soit visible chez les potentiels clients et acheteurs"),
          ModelResumeTextField(
            attribut: 'Nom de boutique',
            valeur: storeInfoState.storeName,
          ),

          ModelResumeTextField(
            attribut: 'Tel associé à votre boutique',
            valeur: storeInfoState.storePhoneNumber,
          ),

          ModelResumeTextField(
            attribut: 'Email boutique',
            valeur: storeInfoState.storeEmail,
          ),

          //Les secteurs d'activités
          ModelResumeTextField(
            attribut: 'Secteurs d\'activité',
            height: context.height * 0.075,
            listeValeur: true,
            valeur: '',
            listeValeurWidget: SizedBox(
              width: context.width * 0.6,
              child: BlocBuilder<SecteurBloc, SecteurState>(
                builder: (context, sectorState) {
                  return Scrollbar(
                    controller: sectorScrollController,
                    trackVisibility: true,
                    thumbVisibility: true,
                    thickness: 3,
                    radius: Radius.circular(20),
                    child: ListView(
                      controller: sectorScrollController,
                      padding: const EdgeInsets.all(8),
                      scrollDirection: Axis.horizontal,
                      children: List.generate(
                          sectorState.selectedSectorNames.length, (index) {
                        return ModelSecteur(
                            text: sectorState.selectedSectorNames[index],
                            isSelected: true,
                            contentAligment: Alignment.center,
                            textColor: AppColors.primaryColor,
                            fontWeigth: FontWeight.bold,
                            activeColor:
                                AppColors.primaryColor.withOpacity(0.2),
                            disabledColor: Colors.grey,
                            onTap: () {});
                      }),
                    ),
                  );
                },
              ),
            ),
          ),

          //Les sous-secteurs d'activités
          ModelResumeTextField(
            attribut: 'Sous Secteurs d\'activité',
            height: context.height * 0.075,
            listeValeur: true,
            valeur: '',
            listeValeurWidget: SizedBox(
              width: context.width * 0.6,
              child: BlocBuilder<SecteurBloc, SecteurState>(
                builder: (context, sectorState) {
                  return Scrollbar(
                    controller: subSectorScrollController,
                    trackVisibility: true,
                    thumbVisibility: true,
                    thickness: 3,
                    radius: Radius.circular(20),
                    child: ListView(
                      controller: subSectorScrollController,
                      padding: const EdgeInsets.all(8),
                      scrollDirection: Axis.horizontal,
                      children: List.generate(
                          sectorState.selectedCategoryNames.length, (index) {
                        return ModelSecteur(
                            text: sectorState.selectedCategoryNames[index],
                            isSelected: true,
                            contentAligment: Alignment.center,
                            textColor: AppColors.primaryColor,
                            fontWeigth: FontWeight.bold,
                            activeColor:
                                AppColors.primaryColor.withOpacity(0.2),
                            disabledColor: Colors.grey,
                            onTap: () {});
                      }),
                    ),
                  );
                },
              ),
            ),
          ),

          ModelResumeTextField(
            attribut: 'Num translation',
            valeur:
                "${storeInfoState.paymentMethod ?? ""} : ${storeInfoState.paymentPhoneNumber ?? ""} (${storeInfoState.payementOwnerName ?? ""})",
          ),

          ModelResumeTextField(
            attribut: 'Statut ficale',
            valeur: storeInfoState.storeFiscalType,
          ),

          ModelResumeTextField(
            attribut: 'Emplacement',
            valeur: storeInfoState.location,
            valueOverflow: TextOverflow.visible,
          ),
          ModelResumeTextField(
            attribut: 'Description de l\'emplacement',
            valeur: storeInfoState.locationDescription,
            valueOverflow: TextOverflow.visible,
          ),

          //espace
          SizedBox(
            height: 50,
          ),
/*
          //============================
          // RESUME INFOS PERSONNELLES
          //============================
          Container(
            height: context.height * 0.05,
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                    flex: 7,
                    child: AppText(text: 'Vos informations personnelles')),
                Flexible(
                  flex: 2,
                  child: GestureDetector(
                    onTap: () {
                      _showModificationBottomSheet(context, storeInfoState);
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.edit,
                          size: context.mediumText,
                          color : AppColors.primaryColor,
                        ),
                        AppText(
                          text: "Modifier",
                          color : AppColors.primaryColor,
                          fontSize: context.smallText * 1.1,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),

          //nom
          ModelResumeTextField(
            attribut: 'Nom',
            valeur: storeInfoState.sellerLastName,
          ),
          //prenom
          ModelResumeTextField(
            attribut: 'Prenom',
            valeur: storeInfoState.sellerFirstName,
          ),
          //date et lieu de naissance
          ModelResumeTextField(
            attribut: 'Date et lieu de naissance',
            valeur:
                '${storeInfoState.sellerBirthDate} à ${storeInfoState.sellerBirthPlace}',
          ),
          //adresse
          ModelResumeTextField(
            attribut: 'Adresse',
            valeur: storeInfoState.storeEmail,
          ),
          //type de piece
          const ModelResumeTextField(
            attribut: 'Type de pièce',
            valeur: 'Type de pièce',
          ),
          //espace
          SizedBox(
            height: context.height * 0.05,
          ),
          // Espace pour compenser l'espace occupé par le bouton "Suivant" dans la page CreationBoutiquePage
          /*SizedBox(
            height: context.height * 0.07,
          )*/
          */
        ]),
      ),
    );
  }

  void _showModificationBottomSheet(
      BuildContext context, StoreCreationGlobalState storeInfoState) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return _ModificationBottomSheet(storeInfoState: storeInfoState);
      },
    );
  }

  @override
  void dispose() {
    sectorScrollController.dispose();
    subSectorScrollController.dispose();
    super.dispose();
  }
}

/*
DottedLine(
dashColor:
Theme.of(context).colorScheme.inversePrimary.withOpacity(0.1),
),*/

class _ModificationBottomSheet extends StatefulWidget {
  final StoreCreationGlobalState storeInfoState;

  const _ModificationBottomSheet({required this.storeInfoState});

  @override
  State<_ModificationBottomSheet> createState() =>
      _ModificationBottomSheetState();
}

class _ModificationBottomSheetState extends State<_ModificationBottomSheet> {
  final TextEditingController _nomBoutiqueController = TextEditingController();
  final TextEditingController _numeroBoutiqueController =
      TextEditingController();
  final TextEditingController _adresseEmailController = TextEditingController();
  final TextEditingController _payementOwnerNameController =
      TextEditingController();
  final TextEditingController _paymentPhoneNumberController =
      TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _locationDescriptionController =
      TextEditingController();

  String? _selectedFiscalType;
  String? _selectedPaymentMethod;
  bool? _sellerOwnDeliver;
  PhoneNumber _paymentPhoneNumber = PhoneNumber(isoCode: 'BJ');

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _nomBoutiqueController.text = widget.storeInfoState.storeName ?? '';
    _numeroBoutiqueController.text =
        widget.storeInfoState.storePhoneNumber ?? '';
    _adresseEmailController.text = widget.storeInfoState.storeEmail ?? '';
    _payementOwnerNameController.text =
        widget.storeInfoState.payementOwnerName ?? '';
    _paymentPhoneNumberController.text =
        widget.storeInfoState.paymentPhoneNumber ?? '';
    _locationController.text = widget.storeInfoState.location ?? '';
    _locationDescriptionController.text =
        widget.storeInfoState.locationDescription ?? '';

    _selectedFiscalType = widget.storeInfoState.storeFiscalType;
    _selectedPaymentMethod = widget.storeInfoState.paymentMethod;
    _sellerOwnDeliver = widget.storeInfoState.sellerOwnDeliver;

    if (widget.storeInfoState.paymentPhoneNumber != null) {
      _paymentPhoneNumber = PhoneNumber(
        phoneNumber: widget.storeInfoState.paymentPhoneNumber,
        isoCode: 'BJ',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.height * 0.9,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  text: 'Modifier les informations',
                  fontSize: context.largeText * 0.85,
                  fontWeight: FontWeight.bold,
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoBoutiqueSection(),
                  const SizedBox(height: 20),
                  _buildSecteursSection(),
                  const SizedBox(height: 20),
                  _buildFiscaliteSection(),
                  const SizedBox(height: 20),
                  _buildLivraisonSection(),
                ],
              ),
            ),
          ),

          // Footer
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context)
                          .colorScheme
                          .inverseSurface
                          .withOpacity(0.15),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: AppText(
                      text: 'Retour',
                      color: Colors.white,
                      fontSize: context.mediumText,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveModifications,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: AppText(
                      text: 'Enregistrer',
                      color: Colors.white,
                      fontSize: context.mediumText,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBoutiqueSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: 'Informations de la boutique',
          fontSize: context.mediumText,
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(height: 12),
        AppText(
          text: 'Nom de la boutique',
          fontSize: context.smallText,
          fontWeight: FontWeight.w500,
        ),
        const SizedBox(height: 8),
        AppTextField(
          controller: _nomBoutiqueController,
          prefixIcon: Icons.storefront,
          color: Theme.of(context).colorScheme.background,
          fontSize: context.mediumText,
          fontColor: Theme.of(context).colorScheme.inversePrimary,
          onChanged: (value) => _updateStoreInfo(),
        ),
        const SizedBox(height: 12),
        AppText(
          text: 'Téléphone de la boutique',
          fontSize: context.smallText,
          fontWeight: FontWeight.w500,
        ),
        const SizedBox(height: 8),
        AppPhoneTextField(
          controller: _numeroBoutiqueController,
          initialCountry: 'BJ',
          onInputChanged: (PhoneNumber number) {
            //_numeroBoutiqueController.text = number.phoneNumber ?? '';
            _updateStoreInfo();
          },
        ),
        const SizedBox(height: 12),
        AppText(
          text: 'Email de la boutique',
          fontSize: context.smallText,
          fontWeight: FontWeight.w500,
        ),
        const SizedBox(height: 8),
        AppTextField(
          controller: _adresseEmailController,
          prefixIcon: Icons.email,
          color: Theme.of(context).colorScheme.background,
          fontSize: context.mediumText,
          fontColor: Theme.of(context).colorScheme.inversePrimary,
          onChanged: (value) => _updateStoreInfo(),
        ),
      ],
    );
  }

  Widget _buildSecteursSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: 'Secteurs d\'activité',
          fontSize: context.mediumText,
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(height: 12),
        BlocBuilder<SecteurBloc, SecteurState>(
          builder: (context, sectorState) {
            return Column(
              children: sectorState.sectors.map((sector) {
                return ExpansionTile(
                  title: GestureDetector(
                    onTap: () {
                      context
                          .read<SecteurBloc>()
                          .add(ToggleSectorSelection(sector.id));
                      _updateSecteursInfo();
                    },
                    child: ModelSecteur(
                      text: sector.name,
                      isSelected: sector.isSelected,
                      activeColor: AppColors.primaryColor,
                      disabledColor: Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        context
                            .read<SecteurBloc>()
                            .add(ToggleSectorSelection(sector.id));
                        _updateSecteursInfo();
                      },
                    ),
                  ),
                  children: [
                    Wrap(
                      children: sector.categories.map((cat) {
                        return ModelSecteur(
                          text: cat.name,
                          isSelected: cat.isSelected,
                          activeColor: AppColors.blueColor,
                          disabledColor: Colors.grey,
                          onTap: () {
                            context.read<SecteurBloc>().add(
                                  ToggleCategorySelection(sector.id, cat.name),
                                );
                            _updateSecteursInfo();
                          },
                        );
                      }).toList(),
                    ),
                  ],
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildFiscaliteSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: 'Informations fiscales et de paiement',
          fontSize: context.mediumText,
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(height: 12),

        // Type fiscal
        AppText(
          text: 'Type fiscal',
          fontSize: context.smallText,
          fontWeight: FontWeight.w500,
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedFiscalType,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          dropdownColor: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.circular(10),
          //padding: EdgeInsets.all(8),
          items: ['Particulier', 'Entreprise ou Société individuelle']
              .map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: AppText(
                text: value,
                fontSize: context.smallText * 1.2,
                color: Theme.of(context)
                    .colorScheme
                    .inverseSurface
                    .withOpacity(0.6),
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedFiscalType = newValue;
            });
            _updateFiscalInfo();
          },
        ),

        const SizedBox(height: 12),

        // Méthode de paiement
        AppText(
          text: 'Méthode de paiement',
          fontSize: context.smallText,
          fontWeight: FontWeight.w500,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: ['Celtiis', 'MTN', 'Moov Africa'].map((method) {
            return ChoiceChip(
              label: Text(method),
              selected: _selectedPaymentMethod == method,
              onSelected: (selected) {
                setState(() {
                  _selectedPaymentMethod = selected ? method : null;
                });
                _updateFiscalInfo();
              },
              selectedColor: _getChipColor(method),
              checkmarkColor: Colors.white,
              labelStyle: TextStyle(
                color: _selectedPaymentMethod == method ? Colors.white : null,
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 12),

        // Nom du propriétaire du compte
        AppText(
          text: 'Nom du propriétaire du compte',
          fontSize: context.smallText,
          fontWeight: FontWeight.w500,
        ),
        const SizedBox(height: 8),
        AppTextField(
          controller: _payementOwnerNameController,
          prefixIcon: Icons.person,
          color: Theme.of(context).colorScheme.background,
          fontSize: context.mediumText,
          fontColor: Theme.of(context).colorScheme.inversePrimary,
          onChanged: (value) => _updateFiscalInfo(),
        ),

        const SizedBox(height: 12),

        // Numéro de téléphone de paiement
        AppText(
          text: 'Numéro de téléphone de paiement',
          fontSize: context.smallText,
          fontWeight: FontWeight.w500,
        ),
        const SizedBox(height: 8),
        AppPhoneTextField(
          controller: _paymentPhoneNumberController,
          initialCountry: 'BJ',
          onInputChanged: (PhoneNumber number) {
            //_paymentPhoneNumberController.text = number.phoneNumber ?? '';
            _updateFiscalInfo();
          },
        ),
      ],
    );
  }

  Widget _buildLivraisonSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: 'Informations de livraison',
          fontSize: context.mediumText,
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(height: 12),

        // Livraison propre
        Row(
          children: [
            Checkbox(
              value: _sellerOwnDeliver ?? false,
              onChanged: (bool? value) {
                /*setState(() {
                  _sellerOwnDeliver = value;
                });
                _updateDeliveryInfo();*/
                AppUtils.showInfoDialog(
                    context: context,
                    message:
                        'Pour l\'instant, vous ne pouvez pas livrer vos produits vous-même');
              },
              activeColor: AppColors.primaryColor,
            ),
            Expanded(
              child: AppText(
                text: 'Je livre moi-même mes produits',
                fontSize: context.smallText,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Emplacement
        AppText(
          text: 'Emplacement',
          fontSize: context.smallText,
          fontWeight: FontWeight.w500,
        ),
        const SizedBox(height: 8),
        AppTextField(
          controller: _locationController,
          prefixIcon: Icons.location_on,
          color: Theme.of(context).colorScheme.background,
          fontSize: context.mediumText,
          fontColor: Theme.of(context).colorScheme.inversePrimary,
          onChanged: (value) => _updateDeliveryInfo(),
        ),

        const SizedBox(height: 12),

        // Description de l'emplacement
        AppText(
          text: 'Description de l\'emplacement',
          fontSize: context.smallText,
          fontWeight: FontWeight.w500,
        ),
        const SizedBox(height: 8),
        AppTextField(
          controller: _locationDescriptionController,
          prefixIcon: Icons.description,
          color: Theme.of(context).colorScheme.background,
          fontSize: context.mediumText,
          fontColor: Theme.of(context).colorScheme.inversePrimary,
          maxLines: 3,
          onChanged: (value) => _updateDeliveryInfo(),
        ),
      ],
    );
  }

  void _updateStoreInfo() {
    final storeInfo = StoreCreationGlobalEvent(
      storeName: _nomBoutiqueController.text,
      storeEmail: _adresseEmailController.text,
      storePhoneNumber: _numeroBoutiqueController.text,
    );
    context.read<StoreCreationBloc>().add(storeInfo);
  }

  void _updateSecteursInfo() {
    final sectorState = context.read<SecteurBloc>().state;
    final storeSectors = StoreCreationGlobalEvent(
      storeSectors: sectorState.selectedSectorNames,
      storeSubSectors: sectorState.selectedCategoryNames,
    );
    context.read<StoreCreationBloc>().add(storeSectors);
  }

  void _updateFiscalInfo() {
    final bloc = context.read<FiscalBloc>();
    final fiscalInfo = FiscalInfo(
      storeFiscalType: _selectedFiscalType,
      paymentMethod: _selectedPaymentMethod,
      paymentPhoneNumberController: bloc.paymentPhoneNumberController.text,
      payementOwnerNameController: bloc.payementOwnerNameController.text,
    );

    context.read<FiscalBloc>().add(SubmitFiscalInfo(fiscalInfo));

    final storeFiscalInfo = StoreCreationGlobalEvent(
      storeFiscalType: _selectedFiscalType,
      paymentMethod: _selectedPaymentMethod,
      paymentPhoneNumber: _paymentPhoneNumberController.text,
      payementOwnerName: _payementOwnerNameController.text,
    );
    context.read<StoreCreationBloc>().add(storeFiscalInfo);
  }

  void _updateDeliveryInfo() {
    final deliveryInfo = StoreCreationGlobalEvent(
      sellerOwnDeliver: _sellerOwnDeliver,
      location: _locationController.text,
      locationDescription: _locationDescriptionController.text,
    );
    context.read<StoreCreationBloc>().add(deliveryInfo);
  }

  void _saveModifications() {
    // Mettre à jour toutes les informations
    _updateStoreInfo();
    _updateSecteursInfo();
    _updateFiscalInfo();
    _updateDeliveryInfo();

    // Fermer le bottomSheet
    Navigator.pop(context);
  }

// Fonction pour retourner la couleur spécifique de chaque option
  Color _getChipColor(String label) {
    switch (label) {
      case 'Celtiis':
        return Colors.deepPurpleAccent;
      case 'MTN':
        return Colors.orange;
      case 'Moov Africa':
        return Colors.lightGreen.shade700;
      default:
        return Colors.grey.withOpacity(0.3); //.colorScheme.background;
    }
  }

  @override
  void dispose() {
    _nomBoutiqueController.dispose();
    _numeroBoutiqueController.dispose();
    _adresseEmailController.dispose();
    _payementOwnerNameController.dispose();
    _paymentPhoneNumberController.dispose();
    _locationController.dispose();
    _locationDescriptionController.dispose();
    super.dispose();
  }
}
