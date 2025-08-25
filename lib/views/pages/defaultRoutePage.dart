import 'package:benin_poulet/views/colors/app_colors.dart';
import 'package:benin_poulet/widgets/app_text.dart';
import 'package:flutter/material.dart';

class DefaultRoutePage extends StatelessWidget {
  const DefaultRoutePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: AppText(text: 'Fonctionnalité à venir'),
          centerTitle: true,
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: Icon(
                Icons.access_time_filled_sharp,
                color: AppColors.orangeColor,
              ),
            ),
          ]),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.settings_rounded,
              size: 80,
              color: AppColors.orangeColor,
            ),
            AppText(
              text: 'Cette fonctionnalité est en cours de développement ...',
              textAlign: TextAlign.center,
              overflow: TextOverflow.visible,
            ),
          ],
        ),
      ),
    );
  }
}
