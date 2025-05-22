import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/app_text.dart';

@Deprecated("Utiliser AppUtils à la place")
class AppSnackBar {
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
