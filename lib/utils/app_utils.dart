import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:benin_poulet/widgets/app_text.dart';
import 'package:flutter/material.dart';

import 'dialog.dart';

class AppUtils {
  //==============================================
  //AFFICHAGE D'INFOS DANS L'INTERFACE UTILISATEUR
  //==============================================
  static Widget showInfo({required String info}) {
    return Builder(builder: (context) {
      return Padding(
          padding: const EdgeInsets.only(
              top: 1.0, right: 8.0, left: 8.0, bottom: 16.0),
          child: Container(
            padding:
                EdgeInsets.only(top: 8.0, right: 4.0, left: 8.0, bottom: 8.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.orange),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              // mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.info_outline,
                  color: Colors.orange,
                ),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: AppText(
                    text: info,
                    fontSize: context.smallText,
                    color: Colors.orange,
                    overflow: TextOverflow.visible,
                  ),
                ),
              ],
            ),
          ));
    });
  }

  //============================================
  //DIALOGE DE CONFIRMATION DE SORTIE DE LA PAGE
  //============================================
  static Future<bool> showExitConfirmationDialog(BuildContext context,
      {String? message}) async {
    return await AppDialog.showDialog<bool>(
      context: context,
      title: 'Confirmation',
      content:
          message ?? 'Voulez-vous vraiment abandonner et quitter cette page ?',
      confirmText: 'Oui',
      cancelText: 'Non',
      isDefaultActionOnCancel: true,
      isDestructiveActionOnConfirm: true,
      onConfirm: () => Navigator.of(context).pop(true),
      onCancel: () => Navigator.of(context).pop(false),
    ).then((value) =>
        value ?? false); // Si l’utilisateur ferme sans choix explicite
  }
}
