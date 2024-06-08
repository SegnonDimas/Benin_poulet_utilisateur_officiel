import 'package:benin_poulet/views/colors/app_colors.dart';
import 'package:benin_poulet/views/pages/connexion_pages/loginPage.dart';
import 'package:benin_poulet/views/pages/started_pages/firstPage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bénin Poulet',
      theme: ThemeData(

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
      ),
      //home: const Placeholder(),
      routes: {
        '/firstPage': (context) => const FirstPage(),
        '/login'  : (context) => const LoginPage(),
      },
      initialRoute: '/firstPage',
    );
  }
}

