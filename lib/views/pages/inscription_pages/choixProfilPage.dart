import 'package:benin_poulet/views/colors/app_colors.dart';
import 'package:benin_poulet/views/sizes/app_sizes.dart';
import 'package:flutter/material.dart';

class ChoixProfilPage extends StatefulWidget {
  const ChoixProfilPage({super.key});

  @override
  State<ChoixProfilPage> createState() => _ChoixProfilPageState();
}

class _ChoixProfilPageState extends State<ChoixProfilPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Dialog(
        elevation: 10,
        shadowColor: Theme.of(context).colorScheme.inversePrimary,
        surfaceTintColor: Theme.of(context).colorScheme.inversePrimary,

        child: SizedBox(
          height: appHeightSize(context)*0.25,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Choix de profil',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Annuler'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Confirmer'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

