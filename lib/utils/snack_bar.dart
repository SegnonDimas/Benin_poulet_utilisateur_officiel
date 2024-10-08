import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:flutter/material.dart';

import '../views/sizes/app_sizes.dart';
import '../widgets/app_text.dart';

class AppSnackBar {
  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: AppText(
            text: message,
            color: Theme.of(context).colorScheme.surface,
            overflow: TextOverflow.visible,
          ),
          backgroundColor: Theme.of(context).colorScheme.inverseSurface,
          elevation: 3,
          duration: const Duration(seconds: 6),
          closeIconColor: Theme.of(context).colorScheme.surface,
          showCloseIcon: true,
          // permettre de
          behavior: SnackBarBehavior.floating,
          width: appWidthSize(context) * 0.9,
        ),
        snackBarAnimationStyle: AnimationStyle(
            reverseCurve: Curves.fastEaseInToSlowEaseOut,
            curve: Curves.fastOutSlowIn,
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
        titleTextStyle: TextStyle(fontSize: mediumText(), color: Colors.white),

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
