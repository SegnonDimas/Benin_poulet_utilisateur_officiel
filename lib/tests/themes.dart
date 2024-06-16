import 'package:benin_poulet/widgets/app_text.dart';
import 'package:flutter/material.dart';

class ThemesPage extends StatefulWidget {
  const ThemesPage({super.key});

  @override
  State<ThemesPage> createState() => _ThemesPageState();
}

class _ThemesPageState extends State<ThemesPage> {
  @override
  Widget build(BuildContext context) {
    double size = 100;
    List<Container> _list = [
      Container(
        height: size,
        width: size,
        color: Theme.of(context).colorScheme.primary,
        child: AppText(
          text: 'primary',
          color: Colors.red,
        ),
      ),
      Container(
        height: size,
        width: size,
        color: Theme.of(context).colorScheme.inversePrimary,
        child: AppText(
          text: 'inversePrimary',
          color: Colors.red,
        ),
      ),
      Container(
        height: size,
        width: size,
        color: Theme.of(context).colorScheme.secondary,
        child: AppText(
          text: 'secondary',
          color: Colors.red,
        ),
      ),
      Container(
        height: size,
        width: size,
        color: Theme.of(context).colorScheme.tertiary,
        child: AppText(
          text: 'primary',
          color: Colors.red,
        ),
      ),
      Container(
        height: size,
        width: size,
        color: Theme.of(context).colorScheme.inverseSurface,
        child: AppText(
          text: 'background',
          color: Colors.red,
        ),
      ),
      Container(
        alignment: Alignment.center,
        height: size,
        width: size,
        color: Theme.of(context).colorScheme.background,
        child: Container(
          height: 80,
          width: 80,
          color: Theme.of(context).colorScheme.surface,
        ),
      ),
      Container(
        alignment: Alignment.center,
        height: size,
        width: size,
        color: Theme.of(context).colorScheme.surface,
        child: Container(
          height: 80,
          width: 80,
          color: Theme.of(context).colorScheme.inverseSurface,
        ),
      ),
      Container(
        alignment: Alignment.center,
        height: size,
        width: size,
        color: Color.fromRGBO(245, 246, 250, 1.0),
        child: Container(
            height: 80, width: 80, color: Color.fromRGBO(220, 221, 225, 150)),
      ),
    ];
    return Scaffold(
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.count(
              crossAxisCount: 2, // Nombre de colonnes
              children: _list,
            )),
      ),
    );
  }
}
