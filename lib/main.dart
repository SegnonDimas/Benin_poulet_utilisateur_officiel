import 'package:benin_poulet/views/pages/connexion_pages/loginPage.dart';
import 'package:benin_poulet/views/pages/inscription_pages/inscriptionPage.dart';
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
      /*theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
        useMaterial3: true,

        // textTheme
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontFamily: 'MontserratSemiBold'),
          displayMedium: TextStyle(fontFamily: 'MontserratSemiBold'),
          displaySmall: TextStyle(fontFamily: 'MontserratSemiBold'),
          headlineLarge: TextStyle(fontFamily: 'MontserratSemiBold'),
          headlineMedium: TextStyle(fontFamily: 'MontserratSemiBold'),
          headlineSmall: TextStyle(fontFamily: 'MontserratSemiBold'),
          titleLarge: TextStyle(fontFamily: 'MontserratSemiBold'),
          titleMedium: TextStyle(fontFamily: 'MontserratSemiBold'),
          titleSmall: TextStyle(fontFamily: 'MontserratSemiBold'),
          bodyLarge: TextStyle(fontFamily: 'MontserratSemiBold'),
          bodyMedium: TextStyle(fontFamily: 'MontserratSemiBold'),
          bodySmall: TextStyle(fontFamily: 'MontserratSemiBold'),
          labelLarge: TextStyle(fontFamily: 'MontserratSemiBold'),
          labelMedium: TextStyle(fontFamily: 'MontserratSemiBold'),
          labelSmall: TextStyle(fontFamily: 'MontserratSemiBold'),
        ),
      ),*/
      home: const InscriptionPage(),
      routes: {
        '/firstPage': (context) => const FirstPage(),
        '/login': (context) => const LoginPage(),
        '/presentationPage': (context) => const PresentationPage(),
        '/inscriptionPage': (context) => const InscriptionPage(),
      },
      //initialRoute: '/firstPage',
    );
  }
}
