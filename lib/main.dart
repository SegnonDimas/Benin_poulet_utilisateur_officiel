import 'package:benin_poulet/views/pages/connexion_pages/loginPage.dart';
import 'package:benin_poulet/views/pages/connexion_pages/loginWithEmailPage.dart';
import 'package:benin_poulet/views/pages/inscription_pages/inscriptionPage.dart';
import 'package:benin_poulet/views/pages/inscription_pages/inscription_vendeurPage.dart';
import 'package:benin_poulet/views/pages/inscription_pages/signupWithEmailPage.dart';
import 'package:benin_poulet/views/pages/started_pages/firstPage.dart';
import 'package:benin_poulet/views/pages/started_pages/presentationPage.dart';
import 'package:benin_poulet/views/themes/dark_mode.dart';
import 'package:benin_poulet/views/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => ThemeProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvider>(context).themeData,
      darkTheme: darkMode,
      title: 'Bénin Poulet',

      home: const InscriptionVendeurPage(),
      routes: {
        '/firstPage': (context) => const FirstPage(),
        '/loginPage': (context) => const LoginPage(),
        '/presentationPage': (context) => const PresentationPage(),
        '/inscriptionPage': (context) => const InscriptionPage(),
        '/loginWithEmailPage': (context) => const LoginWithEmailPage(),
        '/signupWithEmailPage': (context) => const SignupWithEmailPage(),
        '/inscriptionVendeurPage': (context) => const InscriptionVendeurPage(),
      },
      //initialRoute: '/firstPage',
    );
  }
}
