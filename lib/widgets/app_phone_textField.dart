import 'package:benin_poulet/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class AppPhoneTextField extends StatefulWidget {
  final String? initialCountry;
  final String? hintText;
  final String? errorMessage;
  final String? label;
  final Color? labelColor;
  final Color? fontColor;
  final double? fontSize;
  final TextEditingController controller;
  late Function(PhoneNumber)? onSeved;
  late Function(PhoneNumber)? onInputChanged;
  late Function(bool)? onInputValidated;

  AppPhoneTextField({
    super.key,
    this.initialCountry = 'BJ',
    this.hintText = 'Numéro de téléphone',
    this.errorMessage = 'numéro incorrect',
    this.label = 'Numéro de téléphone',
    this.labelColor = Colors.grey,
    required this.controller,
    this.onSeved,
    this.onInputChanged,
    this.onInputValidated,
    this.fontColor = Colors.black,
    this.fontSize = 16,
  });

  @override
  State<AppPhoneTextField> createState() => _AppPhoneTextFieldState();
}

class _AppPhoneTextFieldState extends State<AppPhoneTextField> {
  late String initialCountry;
  PhoneNumber number = PhoneNumber(isoCode: 'BJ');

  @override
  void initState() {
    initialCountry = widget.initialCountry!;
    //widget.controller = TextEditingController();
    widget.onInputChanged = (number) {};
    widget.onInputValidated = (bool) {};
    widget.onSeved = (number) {};
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: MediaQuery.of(context).size.height * 0.08,
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Theme.of(context).colorScheme.background,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InternationalPhoneNumberInput(
          onInputChanged: widget.onInputChanged,
          /*(PhoneNumber number) {
            // le numéro de téléphone saisi.
            print(number.phoneNumber);
          },*/
          onInputValidated: widget.onInputValidated,
          /*(bool value) {
            // true, si le numéro saisi est correct; false sinon.
            print('Valeur : $value');
          },*/
          hintText: widget.hintText!,
          errorMessage: widget.errorMessage!,
          selectorConfig: const SelectorConfig(
              selectorType: PhoneInputSelectorType.DIALOG,
              useBottomSheetSafeArea: true,
              setSelectorButtonAsPrefixIcon: true,
              leadingPadding: 10),
          ignoreBlank: false,
          autoValidateMode: AutovalidateMode.disabled,
          selectorTextStyle: const TextStyle(color: Colors.grey),
          textStyle: TextStyle(
              color: widget.fontColor,
              fontSize: widget
                  .fontSize //Theme.of(context).colorScheme.inverseSurface,

              ),
          initialValue: number,
          textFieldController: widget.controller!,
          formatInput: true,
          autoFocus: false,
          autoFocusSearch: true,
          keyboardType: const TextInputType.numberWithOptions(
              signed: true, decimal: true),
          inputBorder: const OutlineInputBorder(),
          inputDecoration: InputDecoration(
            border: InputBorder.none,
            label: AppText(
              text: widget.label!,
              color: widget.labelColor!,
            ),
          ),
          onSaved: widget.onSeved,
        ),
      ),
    );
  }
}
