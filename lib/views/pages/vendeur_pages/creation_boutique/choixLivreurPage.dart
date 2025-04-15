import 'package:benin_poulet/widgets/app_textField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:super_tooltip/super_tooltip.dart';

import '../../../../bloc/delivery/delivery_bloc.dart';
import '../../../../bloc/storeCreation/store_creation_bloc.dart';
import '../../../../widgets/app_text.dart';
import '../../../colors/app_colors.dart';
import '../../../sizes/text_sizes.dart';

class ChoixLivreurPage extends StatelessWidget {
  ChoixLivreurPage({super.key});

  final _controllerOui = SuperTooltipController();
  final _controllerNon = SuperTooltipController();

  void _updateDeliveryInfo(
      BuildContext context, StoreCreationGlobalState state) {
    final bloc = context.read<DeliveryBloc>();
    final info = DeliveryInfo(
      sellerOwnDeliver: state.sellerOwnDeliver,
      location: bloc.emplacementController.text,
      locationDescription: bloc.descriptionEmplacementController.text,
    );

    context.read<DeliveryBloc>().add(DeliveryInfoEvent(info));

    context.read<StoreCreationBloc>().add(SubmitDeliveryInfo(
          sellerOwnDeliver: state.sellerOwnDeliver,
          location: state.location,
          locationDescription: state.locationDescription,
        ));

    context.read<StoreCreationBloc>().add(StoreCreationGlobalEvent(
          sellerOwnDeliver: info.sellerOwnDeliver,
          location: info.location,
          locationDescription: info.locationDescription,
        ));
  }

  @override
  Widget build(BuildContext context) {
    final deliveryBloc = context.read<DeliveryBloc>();
    return Scaffold(
      body: BlocBuilder<DeliveryBloc, DeliveryState>(
        builder: (context, deliveryState) {
          final info = deliveryState.infos;

          return BlocBuilder<StoreCreationBloc, StoreCreationState>(
            builder: (context, storeCreationState) {
              return Padding(
                padding: const EdgeInsets.only(
                    bottom: 8.0, right: 8.0, left: 8.0, top: 0),
                child: ListView(
                  padding: const EdgeInsets.only(
                      bottom: 1.0, right: 1.0, left: 1.0, top: 0),
                  children: [
                    SizedBox(
                      height: context.height * 0.05,
                      width: context.width * 0.9,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildRadioOption(
                            context: context,
                            value: false,
                            groupValue: info.sellerOwnDeliver ?? true,
                            controller: _controllerOui,
                            label: 'OUI',
                            tooltip:
                                'Nous engagerons nos partenaires professionnels pour assurer vos livraisons pour des raisons de sécurité',
                          ),
                          _buildRadioOption(
                            context: context,
                            value: true,
                            groupValue: info.sellerOwnDeliver ?? true,
                            controller: _controllerNon,
                            label: 'NON',
                            tooltip:
                                'Pour l\'instant vous ne pouvez pas livrer vos produits vous-même',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    AppText(
                      text:
                          'Pour l\'instant, vous ne pouvez pas livrer vos produits vous-même',
                      color: Theme.of(context)
                          .colorScheme
                          .inversePrimary
                          .withOpacity(0.3),
                      overflow: TextOverflow.visible,
                      fontSize: mediumText() * 0.8,
                    ),
                    const SizedBox(height: 10),
                    Divider(
                      color: Theme.of(context).colorScheme.background,
                    ),
                    const SizedBox(height: 20),
                    AppText(
                      text:
                          'Spécifier l\'emplacement de votre boutique pour la récupération des commandes par nos livreurs',
                      overflow: TextOverflow.visible,
                      fontSize: mediumText() * 0.8,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                    const SizedBox(height: 10),
                    AppTextField(
                      //label: '',
                      //height: context.height * 0.08,
                      width: context.width * 0.9,
                      controller: deliveryBloc.descriptionEmplacementController,
                      prefixIcon: Icons.not_listed_location_rounded,
                      color: Theme.of(context).colorScheme.background,
                      fontSize: mediumText() * 0.9,
                      fontColor: Theme.of(context).colorScheme.inversePrimary,
                      maxLines: 10,
                      expands: true,
                      onChanged: (string) {
                        _updateDeliveryInfo(context,
                            storeCreationState as StoreCreationGlobalState);
                      },

                      onFieldSubmitted: (string) {
                        _updateDeliveryInfo(context,
                            storeCreationState as StoreCreationGlobalState);
                      },
                    ),
                    const SizedBox(height: 20),
                    AppText(
                      text: 'Veuillez partager avec nous votre emplacement',
                      overflow: TextOverflow.visible,
                      fontSize: mediumText() * 0.8,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                    const SizedBox(height: 10),
                    AppTextField(
                      //label: '',
                      // height: context.height * 0.08,
                      width: context.width * 0.9,
                      controller: deliveryBloc.emplacementController,
                      prefixIcon: Icons.location_on_outlined,
                      color: Theme.of(context).colorScheme.background,
                      maxLines: 3,
                      fontSize: mediumText() * 0.9,
                      fontColor: Theme.of(context).colorScheme.inversePrimary,
                      onChanged: (string) {
                        _updateDeliveryInfo(context,
                            storeCreationState as StoreCreationGlobalState);
                      },
                      onFieldSubmitted: (string) {
                        _updateDeliveryInfo(context,
                            storeCreationState as StoreCreationGlobalState);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildRadioOption({
    required BuildContext context,
    required bool value,
    required bool groupValue,
    required SuperTooltipController controller,
    required String label,
    required String tooltip,
  }) {
    return SuperTooltip(
      showBarrier: true,
      controller: controller,
      popupDirection: TooltipDirection.up,
      backgroundColor: Theme.of(context).colorScheme.inverseSurface,
      left: context.width * 0.05,
      right: context.width * 0.05,
      arrowTipDistance: 15.0,
      arrowBaseWidth: 20.0,
      arrowLength: 15.0,
      borderWidth: 0.0,
      constraints: BoxConstraints(
        minHeight: context.height * 0.03,
        maxHeight: context.height * 0.3,
        minWidth: context.width * 0.3,
        maxWidth: context.width * 0.7,
      ),
      showCloseButton: false,
      touchThroughAreaShape: ClipAreaShape.rectangle,
      touchThroughAreaCornerRadius: 30,
      barrierColor: const Color.fromARGB(26, 47, 55, 47),
      content: AppText(
        text: tooltip,
        overflow: TextOverflow.visible,
        color: Theme.of(context).colorScheme.surface,
      ),
      child: BlocBuilder<StoreCreationBloc, StoreCreationState>(
        builder: (context, storeCreationState) {
          return SizedBox(
            height: context.height * 0.05,
            width: context.width * 0.4,
            child: ListTile(
              title: AppText(
                text: label,
                fontSize: smallText() * 1.3,
                fontWeight: (groupValue == !value)
                    ? FontWeight.bold
                    : FontWeight.normal,
                color: (groupValue == !value)
                    ? Theme.of(context).colorScheme.inversePrimary
                    : Theme.of(context)
                        .colorScheme
                        .inverseSurface
                        .withAlpha(50),
              ),
              leading: Radio<bool>(
                value: !value,
                groupValue: groupValue,
                activeColor: primaryColor,
                onChanged: (bool? val) {
                  /*if (val != null) {
                    context.read<DeliveryBloc>().add(
                          DeliveryInfoEvent(
                            context
                                .read<DeliveryBloc>()
                                .currentInfo
                                .copyWith(sellerOwnDeliver: !val),
                          ),
                        );
                    _updateDeliveryInfo(context,
                        storeCreationState as StoreCreationGlobalState);
                  }*/
                },
              ),
              horizontalTitleGap: 0,
            ),
          );
        },
      ),
    );
  }
}
