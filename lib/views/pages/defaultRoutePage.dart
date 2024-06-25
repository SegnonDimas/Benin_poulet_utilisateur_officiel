import 'package:benin_poulet/widgets/app_text.dart';
import 'package:flutter/material.dart';

class DefaultRoutePage extends StatelessWidget {
  const DefaultRoutePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText(text: 'Default Route'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.warning_amber,
              size: 50,
              color: Colors.amber,
            ),
            AppText(
              text: 'Default Route\nVeuillez définir une route pour votre page',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
