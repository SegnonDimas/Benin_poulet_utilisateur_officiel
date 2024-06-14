import 'package:flutter/material.dart';

class InfoBoutiquePage extends StatefulWidget {
  @override
  _InfoBoutiquePageState createState() => _InfoBoutiquePageState();
}

class _InfoBoutiquePageState extends State<InfoBoutiquePage> {
  final _formKey = GlobalKey<FormState>();

  final _nomBoutiqueController = TextEditingController();
  final _numeroBoutiqueController = TextEditingController();
  final _adresseEmailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inscription Boutique'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Nom de la boutique',
                ),
                controller: _nomBoutiqueController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez entrer un nom de boutique';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Numéro de la boutique',
                  prefix: Text('+229'),
                ),
                controller: _numeroBoutiqueController,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez entrer un numéro de boutique';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Adresse e-mail',
                ),
                controller: _adresseEmailController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez entrer une adresse e-mail';
                  }
                  if (!RegExp(r'^\w+@\w+\.\w+').hasMatch(value)) {
                    return 'Veuillez entrer une adresse e-mail valide';
                  }
                  return null;
                },
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Enregistrer les informations de la boutique
                    // ...

                    // Aller à la page suivante
                    Navigator.pushNamed(context, '/page-suivante');
                  }
                },
                child: Text('Suivant'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
