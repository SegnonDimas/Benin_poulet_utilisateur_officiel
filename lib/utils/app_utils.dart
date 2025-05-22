import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:benin_poulet/widgets/app_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../views/colors/app_colors.dart';

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

  //===========================
  //DIALOGE PAR DEFAUT DE L'APP
  //===========================
  static Future<T?> showDialog<T>({
    required BuildContext context,
    required String title,
    required String content,
    required String confirmText,
    required String cancelText,
    void Function()? onConfirm,
    void Function()? onCancel,
    bool? barrierDismissible,
    bool? isDestructiveActionOnConfirm,
    bool? isDestructiveActionOnCancel,
    bool? isDefaultActionOnConfirm,
    bool? isDefaultActionOnCancel,
    Curve? insetAnimationCurve,
    Color? titleColor,
    Color? confirmTextColor,
    Color? cancelTextColor,
    Color? contentTextColor,
    double? titleSize,
    double? contentSize,
    double? confirmTextSize,
    double? cancelTextSize,
  }) {
    return showCupertinoDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible ?? true,
      builder: (context) {
        return CupertinoAlertDialog(
          // TITLE
          title: AppText(
            text: title,
            textAlign: TextAlign.center,
            fontWeight: FontWeight.bold,
            color: titleColor,
            fontSize: titleSize ?? context.mediumText * 1.2,
            fontFamily: 'PoppinsMedium',
          ),

          // CONTENT
          content: AppText(
            text: content,
            textAlign: TextAlign.center,
            color: contentTextColor,
            fontSize: contentSize ?? context.mediumText * 0.8,
            overflow: TextOverflow.visible,
            fontFamily: 'PoppinsMedium',
          ),

          // ACTIONS
          actions: [
            // CANCEL
            CupertinoDialogAction(
              isDestructiveAction: isDestructiveActionOnConfirm ?? false,
              isDefaultAction: isDefaultActionOnConfirm ?? false,
              onPressed: onConfirm ?? () => Navigator.pop(context, true),
              child: AppText(
                text: confirmText,
                fontWeight: FontWeight.bold,
                fontSize: cancelTextSize ?? context.mediumText * 0.8,
                color: cancelTextColor ?? AppColors.redColor,
                fontFamily: 'PoppinsMedium',
              ),
            ),

            // CONFIRM
            CupertinoDialogAction(
              isDestructiveAction: isDestructiveActionOnCancel ?? false,
              isDefaultAction: isDefaultActionOnCancel ?? false,
              onPressed: onCancel ?? () => Navigator.pop(context, false),
              child: AppText(
                text: cancelText,
                fontWeight: FontWeight.bold,
                fontSize: confirmTextSize ?? context.mediumText * 0.8,
                color: confirmTextColor ?? AppColors.primaryColor,
                fontFamily: 'PoppinsMedium',
              ),
            ),
          ],

          // ANIMATION
          insetAnimationCurve: insetAnimationCurve ?? Curves.decelerate,
        );
      },
    );
  }

  //============================================
  //DIALOGE DE CONFIRMATION DE SORTIE D'UNE PAGE
  //============================================
  static Future<bool> showExitConfirmationDialog(BuildContext context,
      {String? message}) async {
    return await AppUtils.showDialog<bool>(
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

  //========================
  //AFFICHAGE D'UN SNACKBAR
  //========================
  static void showSnackBar(BuildContext context, String message,
      {Color? backgroundColor, Color? messageColor, Color? closeIconColor}) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          padding: EdgeInsets.only(top: 4, bottom: 4, left: 8, right: 2),
          content: AppText(
            text: message,
            color: messageColor ?? Theme.of(context).colorScheme.surface,
            overflow: TextOverflow.visible,
          ),
          backgroundColor:
              backgroundColor ?? Theme.of(context).colorScheme.inverseSurface,
          elevation: 3,
          duration: const Duration(seconds: 6),
          closeIconColor:
              closeIconColor ?? Theme.of(context).colorScheme.surface,
          showCloseIcon: true,
          // permettre de
          behavior: SnackBarBehavior.floating,
          width: context.width * 0.97,
        ),
        snackBarAnimationStyle: AnimationStyle(
            reverseCurve: Curves.easeOutExpo,
            curve: Curves.easeOutExpo,
            duration: const Duration(seconds: 2),
            reverseDuration: const Duration(seconds: 2)));
  }

  //====================================
  // AFFICHAGE D'UN SNACKBAR AVEC ICONES
  //====================================
  static void showAwesomeSnackBar(
    BuildContext context,
    String title,
    String message,
    ContentType contentType,
    Color? color,
  ) {
    final snackBar = SnackBar(
      /// need to set following properties for best effect of awesome_snackbar_content
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: title,
        message: message,
        titleTextStyle:
            TextStyle(fontSize: context.mediumText, color: Colors.white),

        /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
        contentType: contentType,
        color: color,
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
