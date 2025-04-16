import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:flutter/cupertino.dart';

import '../views/colors/app_colors.dart';
import '../widgets/app_text.dart';

class AppDialog {
  static void showDialog({
    required BuildContext context,
    required String title,
    required String content,
    required String confirmText,
    required String cancelText,
    void Function()? onConfirm,
    void Function()? onCancel,
    bool? barrierDismissible,
  }) {
    // Implement your dialog logic here
    showCupertinoDialog(
        context: context,
        barrierDismissible: barrierDismissible ?? true,
        builder: (context) {
          return CupertinoAlertDialog(
            title: AppText(
              text: title,
              textAlign: TextAlign.center,
              fontWeight: FontWeight.bold,
              fontSize: context.mediumText * 1.2,
              fontFamily: 'PoppinsMedium',
            ),
            content: AppText(
              text: content,
              textAlign: TextAlign.center,
              fontSize: context.mediumText * 0.8,
              overflow: TextOverflow.visible,
              //color: AppColors.redColor,
              fontFamily: 'PoppinsMedium',
            ),
            actions: [
              CupertinoDialogAction(
                onPressed: onConfirm ??
                    () {
                      Navigator.pop(context);
                    },
                child: AppText(
                  text: confirmText,
                  fontWeight: FontWeight.bold,
                  fontSize: context.mediumText * 0.8,
                  color: AppColors.redColor,
                  fontFamily: 'PoppinsMedium',
                ),
              ),
              CupertinoDialogAction(
                onPressed: onCancel ??
                    () {
                      Navigator.pop(context);
                    },
                child: AppText(
                  text: cancelText,
                  fontWeight: FontWeight.bold,
                  fontSize: context.mediumText * 0.8,
                  color: AppColors.primaryColor,
                  fontFamily: 'PoppinsMedium',
                ),
              ),
            ],
          );
        });
  }
}
