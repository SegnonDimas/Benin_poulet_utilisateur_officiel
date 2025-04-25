import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:benin_poulet/widgets/app_text.dart';
import 'package:flutter/cupertino.dart';

import '../views/colors/app_colors.dart';

class AppDialog {
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
}
