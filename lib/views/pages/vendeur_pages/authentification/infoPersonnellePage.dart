import 'package:benin_poulet/views/sizes/app_sizes.dart';
import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../../../widgets/app_textField.dart';

class InfoPersonnellePage extends StatefulWidget {
  @override
  _InfoPersonnellePageState createState() => _InfoPersonnellePageState();
}

class _InfoPersonnellePageState extends State<InfoPersonnellePage> {
  final _formKey = GlobalKey<FormState>();

  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _adresseController = TextEditingController();
  final _dateNaissanceController = TextEditingController();
  final _lieuNaissanceController = TextEditingController();
  String initialCountry = 'BJ';
  PhoneNumber number = PhoneNumber(isoCode: 'BJ');

  DateTime _selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2301),
      cancelText: 'Annuler',
      confirmText: 'Confirmer',
      helpText: 'Choisissez votre date de naissance',
      fieldLabelText: "Date de naissance",
      fieldHintText: "dd/mm/yyyy",
      locale: const Locale('fr', 'FR'),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateNaissanceController.text =
            "${_selectedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              // nom
              AppTextField(
                label: 'Nom',
                height: appHeightSize(context) * 0.08,
                width: appWidthSize(context) * 0.8,
                controller: _nomController,
                color: Theme.of(context).colorScheme.background,
                prefixIcon: Icons.account_circle,
                fontColor: Theme.of(context).colorScheme.inversePrimary,
              ),
              const SizedBox(
                height: 15,
              ),

              // prenom
              AppTextField(
                label: 'Prénom',
                height: appHeightSize(context) * 0.08,
                width: appWidthSize(context) * 0.8,
                controller: _prenomController,
                color: Theme.of(context).colorScheme.background,
                prefixIcon: Icons.account_circle,
                fontColor: Theme.of(context).colorScheme.inversePrimary,
              ),
              const SizedBox(
                height: 15,
              ),

              // date et lieu de naissance
              SizedBox(
                height: appHeightSize(context) * 0.09,
                width: appWidthSize(context),
                child: ListView(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  scrollDirection: Axis.horizontal,
                  children: [
                    //date de naissance
                    AppTextField(
                      label: 'Date',
                      height: appHeightSize(context) * 0.08,
                      width: appWidthSize(context) * 0.4,
                      controller: _dateNaissanceController,
                      color: Theme.of(context).colorScheme.background,
                      prefixIcon: Icons.calendar_month_outlined,
                      keyboardType: TextInputType.datetime,
                      fontColor: Theme.of(context).colorScheme.inversePrimary,
                      fontSize: mediumText() * 0.8,
                      readOnly: true,
                      onTap: () async {
                        await _selectDate(context);
                      },
                    ),

                    const SizedBox(
                      width: 15,
                    ),

                    // lieu de naissance
                    AppTextField(
                      label: 'Lieu',
                      height: appHeightSize(context) * 0.08,
                      width: appWidthSize(context) * 0.5,
                      controller: _lieuNaissanceController,
                      color: Theme.of(context).colorScheme.background,
                      prefixIcon: Icons.location_city_outlined,
                      fontColor: Theme.of(context).colorScheme.inversePrimary,
                      fontSize: mediumText() * 0.8,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),

              // adresse
              AppTextField(
                label: 'Adresse actuelle',
                height: appHeightSize(context) * 0.08,
                width: appWidthSize(context) * 0.8,
                controller: _adresseController,
                color: Theme.of(context).colorScheme.background,
                prefixIcon: Icons.location_on_outlined,
                fontColor: Theme.of(context).colorScheme.inversePrimary,
              ),
              SizedBox(
                height: appHeightSize(context) * 0.08,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
