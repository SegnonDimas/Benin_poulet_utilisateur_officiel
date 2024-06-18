import 'package:benin_poulet/widgets/app_text.dart';
import 'package:flutter/material.dart';

class VHomePage extends StatefulWidget {
  const VHomePage({super.key});

  @override
  State<VHomePage> createState() => _VHomePageState();
}

class _VHomePageState extends State<VHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText(text: 'Accueil'),
      ),
      body: Center(
        child: AppText(
          text: 'Welcom to your home page',
        ),
      ),
    );
  }
}
